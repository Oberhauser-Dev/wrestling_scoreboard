import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/team_match_transcript.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/team_match_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/bout_list_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MatchDisplay extends ConsumerWidget {
  static const route = 'display';

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
        final infoAction = IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => handleSelectedTeamMatch(match, context),
        );
        final pdfAction = IconButton(
          icon: const Icon(Icons.print),
          onPressed: () async {
            final teamMatchBouts = await ref.readAsync(
              manyDataStreamProvider<TeamMatchBout, TeamMatch>(
                ManyProviderData<TeamMatchBout, TeamMatch>(filterObject: match),
              ).future,
            );

            final teamMatchBoutActions = Map.fromEntries(
              await Future.wait(
                teamMatchBouts.map((teamMatchBout) async {
                  final boutActions = await ref.readAsync(
                    manyDataStreamProvider<BoutAction, Bout>(
                      ManyProviderData<BoutAction, Bout>(filterObject: teamMatchBout.bout),
                    ).future,
                  );
                  // final boutActions = await (await ref.read(dataManagerNotifierProvider)).readMany<BoutAction, Bout>(filterObject: teamMatchBout.bout);
                  return MapEntry(teamMatchBout, boutActions);
                }),
              ),
            );
            final isTimeCountDown = await ref.read(timeCountDownNotifierProvider);

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

            if (context.mounted) {
              final bytes =
                  await TeamMatchTranscript(
                    teamMatchBoutActions: teamMatchBoutActions,
                    buildContext: context,
                    teamMatch: match,
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
          body: ManyConsumer<TeamMatchBout, TeamMatch>(
            filterObject: match,
            builder: (context, teamMatchBouts) {
              final matchInfos = [
                match.league?.fullname,
                '${localizations.matchNumber}: ${match.id ?? ''}',
                if (match.referee != null) '${localizations.refereeAbbr}: ${match.referee?.fullName}',
                // Not enough space to display all three referees
                // if (match.matChairman != null)
                //   '${context.l10n.refereeAbbr}: ${match.matChairman?.fullName}',
                // if (match.judge != null) '${context.l10n.refereeAbbr}: ${match.judge?.fullName}',
              ];

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
                              .map((entry) => Expanded(flex: BoutListItem.flexWidths[entry.key], child: entry.value))
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
                              onTap: () => navigateToTeamMatchBoutScreen(context, match, teamMatchBouts[index]),
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
                ],
              );
              return column;
            },
          ),
        );
      },
    );
  }

  handleSelectedTeamMatch(TeamMatch match, BuildContext context) {
    // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
    context.go('/${TeamMatchOverview.route}/${match.id}');
  }
}
