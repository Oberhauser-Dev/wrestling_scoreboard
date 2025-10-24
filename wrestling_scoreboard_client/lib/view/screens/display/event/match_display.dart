import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_transcript.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/team_match_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/bout_list_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchDisplay extends ConsumerWidget {
  static const route = 'display';

  static void navigateTo(BuildContext context, TeamMatch match) {
    context.push('/${TeamMatchOverview.route}/${match.id}/$route');
  }

  final int id;
  final TeamMatch? teamMatch;

  const MatchDisplay({required this.id, this.teamMatch, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final double width = MediaQuery.of(context).size.width;
    final double padding = width / 140;
    return SingleConsumer<TeamMatch>(
      id: id,
      initialData: teamMatch,
      builder: (context, match) {
        final infoAction = ResponsiveScaffoldActionItem(
          label: localizations.info,
          icon: const Icon(Icons.info),
          onTap: () => TeamMatchOverview.navigateTo(context, match),
        );
        final pdfAction = ResponsiveScaffoldActionItem(
          label: localizations.print,
          icon: const Icon(Icons.print),
          onTap: () async {
            List<TeamMatchBout> teamMatchBouts = await ref.readAsync(
              manyDataStreamProvider<TeamMatchBout, TeamMatch>(
                ManyProviderData<TeamMatchBout, TeamMatch>(filterObject: match),
              ).future,
            );

            teamMatchBouts = await Future.wait(
              teamMatchBouts.map((tmb) async {
                return tmb.copyWith(
                  bout: await ref.readAsync(
                    singleDataStreamProvider<Bout>(SingleProviderData<Bout>(id: tmb.bout.id!)).future,
                  ),
                );
              }),
            );

            final teamMatchBoutActions = Map.fromEntries(
              await Future.wait(
                teamMatchBouts.map((teamMatchBout) async {
                  final boutActions = await ref.readAsync(
                    manyDataStreamProvider<BoutAction, Bout>(
                      ManyProviderData<BoutAction, Bout>(filterObject: teamMatchBout.bout),
                    ).future,
                  );
                  // final boutActions = await (await ref.read(dataManagerProvider)).readMany<BoutAction, Bout>(filterObject: teamMatchBout.bout);
                  return MapEntry(teamMatchBout, boutActions);
                }),
              ),
            );
            final isTimeCountDown = await ref.read(timeCountDownProvider);

            final homeParticipations = await ref.readAsync(
              manyDataStreamProvider<TeamLineupParticipation, TeamLineup>(
                ManyProviderData<TeamLineupParticipation, TeamLineup>(filterObject: match.home),
              ).future,
            );

            final guestParticipations = await ref.readAsync(
              manyDataStreamProvider<TeamLineupParticipation, TeamLineup>(
                ManyProviderData<TeamLineupParticipation, TeamLineup>(filterObject: match.guest),
              ).future,
            );

            final officials = await ref.readAsync(
              manyDataStreamProvider<TeamMatchPerson, TeamMatch>(
                ManyProviderData<TeamMatchPerson, TeamMatch>(filterObject: match),
              ).future,
            );

            if (context.mounted) {
              final bytes =
                  await TeamMatchTranscript(
                    teamMatchBoutActions: teamMatchBoutActions,
                    buildContext: context,
                    teamMatch: match,
                    officials: Map.fromEntries(officials.map((tmp) => MapEntry(tmp.person, tmp.role))),
                    boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                    isTimeCountDown: isTimeCountDown,
                    homeParticipations: homeParticipations,
                    guestParticipations: guestParticipations,
                  ).buildPdf();
              Printing.sharePdf(bytes: bytes, filename: '${match.fileBaseName}.pdf');
            }
          },
        );
        return WindowStateScaffold(
          hideAppBarOnFullscreen: true,
          actions: [infoAction, pdfAction],
          body: ManyConsumer<TeamMatchPerson, TeamMatch>(
            filterObject: match,
            builder: (context, officials) {
              return ManyConsumer<TeamMatchBout, TeamMatch>(
                filterObject: match,
                builder: (context, teamMatchBouts) {
                  final matchInfos = [match.league?.fullname, '${localizations.matchNumber}: ${match.id ?? ''}'];
                  final headerItems = <Widget>[
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Center(
                        child: ScaledText(matchInfos.join('\n'), softWrap: false, fontSize: 12, minFontSize: 10),
                      ),
                    ),
                    ...CommonElements.getTeamHeader(
                      match.home.team,
                      match.guest.team,
                      teamMatchBouts.map((e) => e.bout).toList(),
                      context,
                    ),
                  ];
                  final column = Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children:
                              headerItems
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Expanded(flex: BoutListItem.flexWidths[entry.key], child: entry.value),
                                  )
                                  .toList(),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teamMatchBouts.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => TeamMatchBoutDisplay.navigateTo(context, teamMatchBouts[index]),
                                  child: IntrinsicHeight(
                                    child: BoutListItem(
                                      boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                                      bout: teamMatchBouts[index].bout,
                                      weightClass: teamMatchBouts[index].weightClass,
                                    ),
                                  ),
                                ),
                                const Divider(height: 1),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        children:
                            officials
                                .where(
                                  (official) =>
                                      official.role == PersonRole.referee ||
                                      official.role == PersonRole.matChairman ||
                                      official.role == PersonRole.judge,
                                )
                                .map(
                                  (tmp) => Expanded(
                                    child: Center(child: Text('${tmp.role.localize(context)}: ${tmp.person.fullName}')),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  );
                  return column;
                },
              );
            },
          ),
        );
      },
    );
  }
}
