import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/score_sheet.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/team_match_bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchBoutOverview extends BoutOverview {
  static const route = 'team_match_bout';

  final int id;
  final TeamMatchBout? teamMatchBout;

  const TeamMatchBoutOverview({super.key, required this.id, this.teamMatchBout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return SingleConsumer<TeamMatchBout>(
      id: id,
      initialData: teamMatchBout,
      builder: (context, teamMatchBout) {
        final bout = teamMatchBout.bout;
        Future<List<BoutAction>> getActions() => ref.read(
            manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future);

        final pdfAction = IconButton(
          icon: const Icon(Icons.print),
          onPressed: () async {
            final actions = await getActions();
            if (context.mounted) {
              final bytes = await ScoreSheet(
                bout: bout,
                boutActions: actions,
                buildContext: context,
                wrestlingEvent: teamMatchBout.teamMatch,
                boutConfig: teamMatchBout.teamMatch.league?.division.boutConfig ?? const BoutConfig(),
              ).buildPdf();
              Printing.sharePdf(bytes: bytes, filename: '${bout.getFileBaseName(teamMatchBout.teamMatch)}.pdf');
            }
          },
        );

        return buildOverview(
          context,
          ref,
          classLocale: localizations.bout,
          editPage: TeamMatchBoutEdit(
            teamMatchBout: teamMatchBout,
            initialTeamMatch: teamMatchBout.teamMatch,
          ),
          onDelete: () async =>
              (await ref.read(dataManagerNotifierProvider)).deleteSingle<TeamMatchBout>(teamMatchBout),
          tiles: [],
          actions: [
            pdfAction,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.tv),
                onPressed: () => handleSelectedBoutDisplay(teamMatchBout, context),
                label: Text(localizations.display),
              ),
            )
          ],
          dataId: teamMatchBout.bout.id!,
          initialData: teamMatchBout.bout,
        );
      },
    );
  }

  handleSelectedBoutDisplay(TeamMatchBout bout, BuildContext context) {
    context.push(
        '/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}/${TeamMatchBoutDisplay.route}');
  }
}

extension BoutFileExt on Bout {
  String getFileBaseName(WrestlingEvent event) {
    final fileNameBuilder = [
      event.date.toIso8601String().substring(0, 10),
      id?.toString(),
      r?.participation.membership.person.surname,
      '–',
      b?.participation.membership.person.surname,
    ];
    fileNameBuilder.removeWhere((e) => e == null || e.isEmpty);
    return fileNameBuilder.map((e) => e!.replaceAll(' ', '-')).join('_');
  }
}
