import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/competition.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/competition/competition_participation_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_weight_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionWeightCategoryDisplay extends ConsumerWidget {
  static const route = 'display';

  static void navigateTo(BuildContext context, CompetitionWeightCategory category) {
    context.push(
      '/${CompetitionOverview.route}/${category.competition.id}/${CompetitionWeightCategoryOverview.route}/${category.id}/$route',
    );
  }

  final int id;
  final CompetitionWeightCategory? competitionWeightCategory;

  const CompetitionWeightCategoryDisplay({required this.id, this.competitionWeightCategory, super.key});

  Future<List<BoutAction>> _getActions(WidgetRef ref, Bout bout) => ref.readAsync(
    manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionWeightCategory>(
      id: id,
      initialData: competitionWeightCategory,
      builder: (context, competitionWeightCategory) {
        final infoAction = DefaultResponsiveScaffoldActionItem(
          label: localizations.info,
          icon: const Icon(Icons.info),
          onTap: () => CompetitionWeightCategoryOverview.navigateTo(context, competitionWeightCategory),
        );
        // final pdfAction = ResponsiveScaffoldActionItem(
        //   tooltip: localizations.print,
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
        //       // final boutActions = await (await ref.read(dataManagerProvider)).readMany<BoutAction, Bout>(filterObject: competitionBout.bout);
        //       return MapEntry(competitionBout, boutActions);
        //     })));
        //     final isTimeCountDown = await ref.read(timeCountDownProvider);
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

        return DisplayTheme(
          child: WindowStateScaffold(
            hideAppBarOnFullscreen: true,
            actions: [
              infoAction,
              // pdfAction,
            ],
            body: ManyConsumer<CompetitionParticipation, CompetitionWeightCategory>(
              filterObject: competitionWeightCategory,
              builder: (context, competitionParticipations) {
                final competitionInfos = [
                  competitionWeightCategory.competition.name,
                  competitionWeightCategory.competition.date.toDateString(context),
                ];

                return ManyConsumer<CompetitionBout, CompetitionWeightCategory>(
                  filterObject: competitionWeightCategory,
                  builder: (context, competitionBouts) {
                    return ManyConsumer<CompetitionSystemPhase, CompetitionSystemAffiliation>(
                      filterObject: competitionWeightCategory.competitionSystemAffiliation,
                      builder: (context, phases) {
                        return LoadingBuilder(
                          future: Future.wait(
                            competitionBouts.map((cb) async => MapEntry(cb, await _getActions(ref, cb.bout))),
                          ),
                          builder: (context, competitionBoutsWithActions) {
                            final participantWidgets = <Widget>[];

                            final cBoutsByPhase = competitionBoutsWithActions.groupSetsBy(
                              (entry) => entry.key.phasePos,
                            );
                            final competitionBoutsByPhaseAndRound = cBoutsByPhase.map(
                              (phase, boutsWithActions) => MapEntry(
                                phase,
                                boutsWithActions
                                    .groupSetsBy((bout) => bout.key.round)
                                    .map(
                                      (round, boutsWithActions) => MapEntry(round, Map.fromEntries(boutsWithActions)),
                                    ),
                              ),
                            );

                            var currentPhase = 0;
                            while (cBoutsByPhase[currentPhase + 1] != null &&
                                cBoutsByPhase[currentPhase + 1]!.isNotEmpty) {
                              // The current phase is the one, which is the lastest and has bouts.
                              currentPhase++;
                            }

                            CompetitionWeightCategory.rankingBuilder(
                              groupPoolsByPhase: currentPhase,
                              phases: phases,
                              weightCategoryParticipants: competitionParticipations,
                              weightCategoryBoutsWithActions: competitionBoutsWithActions,
                              poolGroupBuilder: (poolGroup) {
                                if ((phases.length - 1) >= currentPhase && phases[currentPhase].poolGroupCount > 1) {
                                  participantWidgets.add(
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Card(
                                        child: Center(
                                          child: ScaledText('${localizations.pool} ${poolGroup.toLetter()}'),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              poolGroupParticipantBuilder: (participation, ranks) {
                                participantWidgets.add(
                                  Column(
                                    children: [
                                      IntrinsicHeight(
                                        child: CompetitionParticipationItem(
                                          participation: participation,
                                          // Need to pass all participations as it can pair with another pool in the finals.
                                          participations: competitionParticipations,
                                          competitionBoutsByPhaseAndRound: competitionBoutsByPhaseAndRound,
                                          ranks: ranks,
                                          phases: phases,
                                        ),
                                      ),
                                      const Divider(height: 1),
                                    ],
                                  ),
                                );
                              },
                            );
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: ScaledText(
                                          competitionWeightCategory.name,
                                          softWrap: false,
                                          fontSize: 16,
                                          minFontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children:
                                          competitionInfos
                                              .map(
                                                (e) => Center(
                                                  child: ScaledText(e, softWrap: false, fontSize: 10, minFontSize: 8),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                                Divider(),
                                IntrinsicHeight(
                                  // Need to see the vertical divider
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ScaledContainer(
                                        width: CompetitionParticipationItem.numberRelativeWidth,
                                        child: ScaledText(localizations.numberAbbreviation),
                                      ),
                                      VerticalDivider(),
                                      ScaledContainer(
                                        width: CompetitionParticipationItem.nameRelativeWidth,
                                        child: ScaledText(localizations.name),
                                      ),
                                      VerticalDivider(),
                                      ScaledContainer(
                                        width: CompetitionParticipationItem.clubRelativeWidth,
                                        child: ScaledText(localizations.club),
                                      ),
                                      VerticalDivider(width: 1),
                                      ...phases.map((phase) {
                                        final phaseBouts = competitionBoutsByPhaseAndRound[phase.pos]!;
                                        final nonEmptyRounds = phaseBouts.keys.nonNulls.where((round) => round >= 0);

                                        final boutResults = Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:
                                              nonEmptyRounds.map((round) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ScaledContainer(
                                                      width: CompetitionParticipationItem.roundRelativeWidth,
                                                      child: ScaledText(
                                                        '${localizations.round} ${round + 1}',
                                                        fontSize: 10,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    VerticalDivider(width: 1),
                                                  ],
                                                );
                                              }).toList(),
                                        );
                                        final pointWidgets = Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ScaledContainer(
                                              width: CompetitionParticipationItem.pointsRelativeWidth,
                                              child: ScaledText(
                                                localizations.wins,
                                                fontSize: 8,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            VerticalDivider(width: 1),
                                            ScaledContainer(
                                              width: CompetitionParticipationItem.pointsRelativeWidth,
                                              child: ScaledText(
                                                localizations.classificationPointsAbbr,
                                                fontSize: 8,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            VerticalDivider(width: 1),
                                            ScaledContainer(
                                              width: CompetitionParticipationItem.pointsRelativeWidth,
                                              child: ScaledText(
                                                localizations.technicalPointsAbbr,
                                                fontSize: 8,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            VerticalDivider(width: 1),
                                            ScaledContainer(
                                              width: CompetitionParticipationItem.pointsRelativeWidth,
                                              child: ScaledText(
                                                localizations.rank,
                                                fontSize: 8,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        );
                                        return Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                ScaledText(
                                                  phase.localize(context, phasesCount: phases.length),
                                                  textAlign: TextAlign.center,
                                                ),
                                                // For some reason "IntrinsicHeight" is needed to show VerticalDivider in a column.
                                                IntrinsicHeight(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [boutResults, pointWidgets],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            VerticalDivider(width: 2, thickness: 2),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Expanded(
                                  child: SafeArea(
                                    child: ListView.builder(
                                      itemCount: participantWidgets.length,
                                      itemBuilder: (context, index) => participantWidgets[index],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
