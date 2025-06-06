import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/competition_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionParticipationItem extends ConsumerWidget {
  final CompetitionParticipation participation;
  final List<CompetitionParticipation> participations;
  final Map<int?, Set<CompetitionBout>> competitionBoutsByRound;

  /// Ranking starts at 1
  final int ranking;

  /// Pool Ranking starts at 1
  final int poolRanking;

  static const numberRelativeWidth = 0.03;
  static const nameRelativeWidth = 0.18;
  static const clubRelativeWidth = 0.15;
  static const roundRelativeWidth = 0.06;
  static const pointsRelativeWidth = 0.02;

  const CompetitionParticipationItem({
    super.key,
    required this.participation,
    required this.participations,
    required this.competitionBoutsByRound,
    required this.ranking,
    required this.poolRanking,
  });

  Future<List<BoutAction>> _getActions(WidgetRef ref, Bout bout) => ref.readAsync(
    manyDataStreamProvider<BoutAction, Bout>(ManyProviderData<BoutAction, Bout>(filterObject: bout)).future,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleConsumer<CompetitionParticipation>(
      initialData: participation,
      id: participation.id,
      builder: (context, participation) {
        final items = <Widget>[];
        int i = 0;
        int wins = 0;
        int classificationPointsSum = 0;
        List<Future<int>> futureTechnicalPointsList = [];
        while (competitionBoutsByRound[i] != null) {
          final Widget item;
          final cBout =
              competitionBoutsByRound[i]!
                  .where(
                    (element) =>
                        element.bout.r?.membership == participation.membership ||
                        element.bout.b?.membership == participation.membership,
                  )
                  .zeroOrOne;

          if (cBout != null) {
            final BoutRole role;
            final CompetitionParticipation? opponentParticipation;
            final AthleteBoutState? boutState;
            if (cBout.bout.r?.membership == participation.membership) {
              role = BoutRole.red;
              boutState = cBout.bout.r;
              opponentParticipation =
                  participations.where((element) => element.membership == cBout.bout.b?.membership).zeroOrOne;
            } else {
              role = BoutRole.blue;
              boutState = cBout.bout.b;
              opponentParticipation =
                  participations.where((element) => element.membership == cBout.bout.r?.membership).zeroOrOne;
            }
            if (cBout.bout.winnerRole == role) {
              wins++;
            }
            classificationPointsSum += boutState?.classificationPoints ?? 0;
            final futureTechnicalPoints = _getActions(
              ref,
              cBout.bout,
            ).then((actions) => AthleteBoutState.getTechnicalPoints(actions, role));
            futureTechnicalPointsList.add(futureTechnicalPoints);
            item = InkWell(
              onTap: () => navigateToCompetitionBoutScreen(context, cBout),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: role.color())),
                child: Row(
                  children: [
                    Expanded(child: Center(child: ScaledText(opponentParticipation?.displayPoolId ?? ''))),
                    Expanded(
                      child: Container(
                        color: cBout.bout.winnerRole == role ? role.color() : null,
                        child: Column(
                          children: [
                            ScaledText(cBout.bout.result?.abbreviation(context) ?? '-', fontSize: 8),
                            LoadingBuilder(
                              future: futureTechnicalPoints,
                              builder: (context, technicalPoints) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ScaledText(
                                      boutState?.classificationPoints?.toString() ?? '-',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                    if (technicalPoints > 0 || boutState?.classificationPoints != null)
                                      ScaledText(' | $technicalPoints', fontSize: 8),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            item = SizedBox();
          }
          items.add(
            Row(
              children: [
                ScaledContainer(width: CompetitionParticipationItem.roundRelativeWidth, child: item),
                VerticalDivider(width: 1),
              ],
            ),
          );
          i++;
        }
        final row = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ScaledContainer(
              width: CompetitionParticipationItem.numberRelativeWidth,
              child: ScaledText(participation.displayPoolId),
            ),
            VerticalDivider(),
            ScaledContainer(
              width: CompetitionParticipationItem.nameRelativeWidth,
              child: InkWell(
                onTap: () {
                  // FIXME: use `navigateToCompetitionParticipationOverview` route, https://github.com/flutter/flutter/issues/140586
                  context.go('/${CompetitionParticipationOverview.route}/${participation.id}');
                },
                child: ScaledText(
                  participation.membership.person.fullName,
                  decoration:
                      participation.contestantStatus == ContestantStatus.disqualified
                          ? TextDecoration.lineThrough
                          : null,
                ),
              ),
            ),
            VerticalDivider(),
            ScaledContainer(
              width: CompetitionParticipationItem.clubRelativeWidth,
              child: ScaledText(
                participation.lineup.club.name,
                decoration:
                    participation.contestantStatus == ContestantStatus.disqualified ? TextDecoration.lineThrough : null,
              ),
            ),
            VerticalDivider(width: 1),
            ...items,
            VerticalDivider(width: 1),
            ScaledContainer(
              width: CompetitionParticipationItem.pointsRelativeWidth,
              child: ScaledText(wins.toString()),
            ),
            VerticalDivider(width: 1),
            ScaledContainer(
              width: CompetitionParticipationItem.pointsRelativeWidth,
              child: ScaledText(classificationPointsSum.toString()),
            ),
            VerticalDivider(width: 1),
            ScaledContainer(
              width: CompetitionParticipationItem.pointsRelativeWidth,
              child: LoadingBuilder(
                future: Future.wait(futureTechnicalPointsList).then((list) => list.fold(0, (prev, cur) => prev + cur)),
                builder: (context, technicalPointsSum) {
                  return ScaledText(technicalPointsSum.toString());
                },
              ),
            ),
            VerticalDivider(width: 1),
            ScaledContainer(
              width: CompetitionParticipationItem.pointsRelativeWidth,
              child: ScaledText(poolRanking.toString()),
            ),
            VerticalDivider(width: 1),
            ScaledContainer(
              width: CompetitionParticipationItem.pointsRelativeWidth,
              child: ScaledText(ranking.toString()),
            ),
            VerticalDivider(width: 1),
          ],
        );
        if (participation.isExcluded) {
          return DefaultTextStyle.merge(child: row, style: TextStyle(color: Theme.of(context).disabledColor));
        }
        return row;
      },
    );
  }
}
