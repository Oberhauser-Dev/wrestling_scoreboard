import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/score_sheet.dart';
import 'package:wrestling_scoreboard_client/utils/io.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/team_match_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutOverview extends ConsumerWidget with BoutOverview<TeamMatchBout> {
  static const route = 'team_match_bout';

  static void navigateTo(BuildContext context, TeamMatchBout bout) {
    context.push('/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}');
  }

  final int id;
  final TeamMatchBout? teamMatchBout;

  TeamMatchBoutOverview({super.key, required this.id, this.teamMatchBout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;

    return SingleConsumer<TeamMatchBout>(
      id: id,
      initialData: teamMatchBout,
      builder: (context, teamMatchBout) {
        final bout = teamMatchBout.bout;
        Future<List<BoutAction>> getActions() => ref.readAsync(
          manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
        );

        final pdfAction = ResponsiveScaffoldActionItem(
          label: localizations.print,
          icon: const Icon(Icons.print),
          onTap: () async {
            final actions = await getActions();
            final boutRules =
                teamMatchBout.teamMatch.league == null
                    ? TeamMatch.defaultBoutResultRules
                    : await ref.readAsync(
                      manyDataStreamProvider<BoutResultRule, BoutConfig>(
                        ManyProviderData<BoutResultRule, BoutConfig>(
                          filterObject: teamMatchBout.teamMatch.league!.division.boutConfig,
                        ),
                      ).future,
                    );

            final isTimeCountDown = await ref.read(timeCountDownProvider);

            final officials = await ref.readAsync(
              manyDataStreamProvider<TeamMatchPerson, TeamMatch>(
                ManyProviderData<TeamMatchPerson, TeamMatch>(filterObject: teamMatchBout.teamMatch),
              ).future,
            );

            if (context.mounted) {
              final bytes =
                  await ScoreSheet(
                    bout: bout,
                    boutActions: actions,
                    buildContext: context,
                    wrestlingEvent: teamMatchBout.teamMatch,
                    officials: Map.fromEntries(officials.map((tmp) => MapEntry(tmp.person, tmp.role))),
                    boutConfig: teamMatchBout.teamMatch.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                    boutRules: boutRules,
                    isTimeCountDown: isTimeCountDown,
                    weightClass: teamMatchBout.weightClass,
                  ).buildPdf();
              await Printing.sharePdf(bytes: bytes, filename: '${bout.getFileBaseName(teamMatchBout.teamMatch)}.pdf');
            }
          },
        );

        return buildOverview(
          context,
          ref,
          classLocale: localizations.bout,
          editPage: TeamMatchBoutEdit(teamMatchBout: teamMatchBout, initialTeamMatch: teamMatchBout.teamMatch),
          onDelete: () async => (await ref.read(dataManagerProvider)).deleteSingle<TeamMatchBout>(teamMatchBout),
          tiles: [
            ContentItem(
              title: teamMatchBout.teamMatch.localize(context),
              subtitle: localizations.match,
              icon: Icons.event,
              onTap: () => TeamMatchOverview.navigateTo(context, teamMatchBout.teamMatch),
            ),
          ],
          actions: [
            pdfAction,
            ResponsiveScaffoldActionItem(
              style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
              icon: const Icon(Icons.tv),
              onTap: () => TeamMatchBoutDisplay.navigateTo(context, teamMatchBout),
              label: localizations.display,
            ),
          ],
          dataId: teamMatchBout.bout.id!,
          initialData: teamMatchBout.bout,
          subClassData: teamMatchBout,
          boutConfig: teamMatchBout.teamMatch.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
        );
      },
    );
  }
}

extension BoutFileExt on Bout {
  String getFileBaseName(WrestlingEvent event) {
    final fileNameBuilder = [
      event.date.toFileNameDateFormat(),
      id?.toString(),
      r?.membership.person.surname,
      '–',
      b?.membership.person.surname,
    ];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.join('_').sanitizedFileName;
  }
}
