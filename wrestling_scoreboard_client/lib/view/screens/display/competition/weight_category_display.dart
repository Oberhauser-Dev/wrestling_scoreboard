import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/round_type.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/competition/competition_participation_item.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_weight_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionWeightCategoryDisplay extends ConsumerWidget {
  static const route = 'display';

  final int id;
  final CompetitionWeightCategory? competitionWeightCategory;

  const CompetitionWeightCategoryDisplay({required this.id, this.competitionWeightCategory, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<CompetitionWeightCategory>(
      id: id,
      initialData: competitionWeightCategory,
      builder: (context, competitionWeightCategory) {
        final infoAction = IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => handleSelectedWeightCategory(competitionWeightCategory, context),
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
          body: ManyConsumer<CompetitionParticipation, CompetitionWeightCategory>(
            filterObject: competitionWeightCategory,
            builder: (context, competitionParticipations) {
              final competitionInfos = [
                competitionWeightCategory.competition.name,
                competitionWeightCategory.competition.date.toDateString(context),
              ];
              final competitionParticipationsByPool = competitionParticipations.groupListsBy(
                (element) => element.poolGroup,
              );

              return ManyConsumer<CompetitionBout, CompetitionWeightCategory>(
                filterObject: competitionWeightCategory,
                builder: (context, competitionBouts) {
                  final ranking = CompetitionWeightCategory.calculateRanking(
                    competitionParticipations,
                    competitionBouts,
                  );
                  final competitionBoutsByRound = SplayTreeMap<int?, Set<CompetitionBout>>.from(
                    competitionBouts.groupSetsBy((element) => element.round),
                  );
                  final participantWidgets = <Widget>[];
                  for (int poolGroup = 0; poolGroup < competitionWeightCategory.poolGroupCount; poolGroup++) {
                    if (competitionWeightCategory.poolGroupCount > 1) {
                      participantWidgets.add(
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Card(
                            child: Center(child: ScaledText('${localizations.pool} ${poolGroup.toLetter()}')),
                          ),
                        ),
                      );
                    }
                    final participationsOfPoolGroup = competitionParticipationsByPool[poolGroup]!;
                    participationsOfPoolGroup.sort(
                      (a, b) => (a.poolDrawNumber ?? -1).compareTo(b.poolDrawNumber ?? -1),
                    );
                    for (final participationOfPoolGroup in participationsOfPoolGroup) {
                      final poolRanking = CompetitionWeightCategory.calculateRanking(
                        participationsOfPoolGroup,
                        competitionBouts,
                      );
                      participantWidgets.add(
                        Column(
                          children: [
                            IntrinsicHeight(
                              child: CompetitionParticipationItem(
                                participation: participationOfPoolGroup,
                                // Need to pass all participations as it can pair with another pool in the finals.
                                participations: competitionParticipations,
                                competitionBoutsByRound: competitionBoutsByRound,
                                ranking: ranking.indexWhere((element) => element.$1 == participationOfPoolGroup) + 1,
                                poolRanking:
                                    poolRanking.indexWhere((element) => element.$1 == participationOfPoolGroup) + 1,
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      );
                    }
                  }
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
                                      (e) =>
                                          Center(child: ScaledText(e, softWrap: false, fontSize: 10, minFontSize: 8)),
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
                            ...competitionBoutsByRound.keys.where((round) => round != null && round >= 0).map((round) {
                              final competitionBout = competitionBoutsByRound[round]!.first;
                              return Row(
                                children: [
                                  ScaledContainer(
                                    width: CompetitionParticipationItem.roundRelativeWidth,
                                    child: ScaledText(
                                      '${competitionBout.roundType.localize(context)} ${competitionBout.displayRound}',
                                      fontSize: 10,
                                    ),
                                  ),
                                  VerticalDivider(width: 1),
                                ],
                              );
                            }),
                            ScaledContainer(
                              width: CompetitionParticipationItem.pointsRelativeWidth,
                              child: ScaledText(localizations.wins, fontSize: 8),
                            ),
                            VerticalDivider(width: 1),
                            ScaledContainer(
                              width: CompetitionParticipationItem.pointsRelativeWidth,
                              child: ScaledText(localizations.classificationPointsAbbr),
                            ),
                            VerticalDivider(width: 1),
                            ScaledContainer(
                              width: CompetitionParticipationItem.pointsRelativeWidth,
                              child: ScaledText(localizations.technicalPointsAbbr),
                            ),
                            VerticalDivider(width: 1),
                            ScaledContainer(
                              width: CompetitionParticipationItem.pointsRelativeWidth,
                              child: ScaledText('${localizations.rank} (${localizations.pool})', fontSize: 8),
                            ),
                            VerticalDivider(width: 1),
                            ScaledContainer(
                              width: CompetitionParticipationItem.pointsRelativeWidth,
                              child: ScaledText(localizations.rank, fontSize: 8),
                            ),
                            VerticalDivider(width: 1),
                          ],
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: participantWidgets.length,
                          itemBuilder: (context, index) => participantWidgets[index],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  handleSelectedWeightCategory(CompetitionWeightCategory weightCategory, BuildContext context) {
    // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
    context.go('/${CompetitionWeightCategoryOverview.route}/${weightCategory.id}');
  }
}
