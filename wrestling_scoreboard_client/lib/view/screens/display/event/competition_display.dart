import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/competition_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/event/bout_list_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionDisplay extends ConsumerWidget {
  static const route = 'display';

  final int id;
  final Competition? competition;

  const CompetitionDisplay({required this.id, this.competition, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    double width = MediaQuery.of(context).size.width;
    double padding = width / 140;
    return SingleConsumer<Competition>(
      id: id,
      initialData: competition,
      builder: (context, competition) {
        final infoAction = IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => handleSelectedCompetition(competition, context),
        );
        // final pdfAction = IconButton(
        //   icon: const Icon(Icons.print),
        //   onPressed: () async {
        //     final competitionBouts = await ref.readAsync(manyDataStreamProvider<CompetitionBout, Competition>(
        //       ManyProviderData<CompetitionBout, Competition>(filterObject: competition),
        //     ).future);
        //
        //     final competitionBoutActions = Map.fromEntries(await Future.wait(competitionBouts.map((competitionBout) async {
        //       final boutActions = await ref.readAsync(manyDataStreamProvider<BoutAction, Bout>(
        //         ManyProviderData<BoutAction, Bout>(filterObject: competitionBout.bout),
        //       ).future);
        //       // final boutActions = await (await ref.read(dataManagerNotifierProvider)).readMany<BoutAction, Bout>(filterObject: competitionBout.bout);
        //       return MapEntry(competitionBout, boutActions);
        //     })));
        //     final isTimeCountDown = await ref.read(timeCountDownNotifierProvider);
        //
        //     final homeParticipations = await ref.readAsync(manyDataStreamProvider<CompetitionParticipation, TeamLineup>(
        //       ManyProviderData<CompetitionParticipation, TeamLineup>(filterObject: competition.home),
        //     ).future);
        //
        //     final guestParticipations = await ref.readAsync(manyDataStreamProvider<CompetitionParticipation, TeamLineup>(
        //       ManyProviderData<CompetitionParticipation, TeamLineup>(filterObject: competition.guest),
        //     ).future);
        //
        //     if (context.mounted) {
        //       final bytes = await CompetitionTranscript(
        //         competitionBoutActions: competitionBoutActions,
        //         buildContext: context,
        //         competition: competition,
        //         boutConfig: competition.boutConfig ?? Competition.defaultBoutConfig,
        //         isTimeCountDown: isTimeCountDown,
        //         homeParticipations: homeParticipations,
        //         guestParticipations: guestParticipations,
        //       ).buildPdf();
        //       Printing.sharePdf(bytes: bytes, filename: '${competition.fileBaseName}.pdf');
        //     }
        //   },
        // );
        return WindowStateScaffold(
          hideAppBarOnFullscreen: true,
          actions: [
            infoAction,
            // pdfAction,
          ],
          body: ManyConsumer<CompetitionBout, Competition>(
            filterObject: competition,
            builder: (context, competitionBouts) {
              final competitionInfos = [
                competition.name,
                '${localizations.competitionNumber}: ${competition.id ?? ''}',
                // if (competition.referee != null) '${localizations.refereeAbbr}: ${competition.referee?.fullName}',
                // Not enough space to display all three referees
                // if (competition.matChairman != null)
                //   '${context.l10n.refereeAbbr}: ${competition.matChairman?.fullName}',
                // if (competition.judge != null) '${context.l10n.refereeAbbr}: ${competition.judge?.fullName}',
              ];

              final headerItems = <Widget>[
                Padding(
                    padding: EdgeInsets.all(padding),
                    child: Center(
                        child: ScaledText(
                      competitionInfos.join('\n'),
                      softWrap: false,
                      fontSize: 12,
                      minFontSize: 10,
                    ))),
                // ...CommonElements.getTeamHeader(
                //     competition.home.team, competition.guest.team, competitionBouts.map((e) => e.bout).toList(), context),
              ];
              final column = Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: headerItems
                            .asMap()
                            .entries
                            .map((entry) => Expanded(flex: BoutListItem.flexWidths[entry.key], child: entry.value))
                            .toList()),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: competitionBouts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () =>
                                  navigateToCompetitionBoutScreen(context, competition, competitionBouts[index]),
                              child: IntrinsicHeight(
                                child: ManyConsumer<BoutAction, Bout>(
                                  filterObject: competitionBouts[index].bout,
                                  builder: (context, actions) => BoutListItem(
                                    boutConfig: competition.boutConfig,
                                    bout: competitionBouts[index].bout,
                                    actions: actions,
                                    weightClass: competitionBouts[index].weightCategory?.weightClass,
                                  ),
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

  handleSelectedCompetition(Competition competition, BuildContext context) {
    // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
    context.go('/${CompetitionOverview.route}/${competition.id}');
  }
}
