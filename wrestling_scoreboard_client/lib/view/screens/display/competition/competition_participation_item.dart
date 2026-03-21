import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/bout_result.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/competition_bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionParticipationItem extends ConsumerWidget {
  final CompetitionParticipation participation;
  final List<CompetitionParticipation> participations;
  final Map<int?, Map<int?, Map<CompetitionBout, Iterable<BoutAction>>>> competitionBoutsByPhaseAndRound;

  final List<Rank?> ranks;
  final List<CompetitionSystemPhase> phases;

  static const numberRelativeWidth = 0.03;
  static const nameRelativeWidth = 0.18;
  static const clubRelativeWidth = 0.15;
  static const roundRelativeWidth = 0.06;
  static const pointsRelativeWidth = 0.02;

  const CompetitionParticipationItem({
    super.key,
    required this.participation,
    required this.participations,
    required this.competitionBoutsByPhaseAndRound,
    required this.ranks,
    required this.phases,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleConsumer<CompetitionParticipation>(
      initialData: participation,
      id: participation.id,
      builder: (context, participation) {
        final row = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ScaledContainer(
              alignment: Alignment.center,
              width: CompetitionParticipationItem.numberRelativeWidth,
              child: ScaledText(participation.displayPoolId(phases: phases, phasePos: phases.length - 1)),
            ),
            VerticalDivider(),
            ScaledContainer(
              width: CompetitionParticipationItem.nameRelativeWidth,
              child: InkWell(
                onTap: () => CompetitionParticipationOverview.navigateTo(context, participation),
                child: ScaledText(
                  participation.membership.person.fullName,
                  decoration: participation.contestantStatus == ContestantStatus.disqualified
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
                decoration: participation.contestantStatus == ContestantStatus.disqualified
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            VerticalDivider(width: 1),
            ...phases.map((phase) {
              final competitionBoutsOfPhase = competitionBoutsByPhaseAndRound[phase.pos]!;

              final boutResultItems = <Widget>[];
              int round = 0;
              while (competitionBoutsOfPhase[round] != null) {
                final Widget item;
                final competitionBoutsOfRound = competitionBoutsOfPhase[round]!;
                final cBout = competitionBoutsOfRound.keys
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
                    opponentParticipation = participations
                        .where((element) => element.membership == cBout.bout.b?.membership)
                        .zeroOrOne;
                  } else {
                    role = BoutRole.blue;
                    boutState = cBout.bout.b;
                    opponentParticipation = participations
                        .where((element) => element.membership == cBout.bout.r?.membership)
                        .zeroOrOne;
                  }
                  final technicalPoints = AthleteBoutState.getTechnicalPoints(competitionBoutsOfRound[cBout]!, role);
                  item = InkWell(
                    onTap: () => CompetitionBoutDisplay.navigateTo(context, cBout),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: role.color())),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: ScaledText(
                                opponentParticipation?.displayPoolId(phases: phases, phasePos: cBout.phasePos) ?? '',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: cBout.bout.winnerRole == role ? role.color() : null,
                              child: Column(
                                children: [
                                  ScaledText(cBout.bout.result?.abbreviation(context) ?? '-', fontSize: 8),
                                  Row(
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
                boutResultItems.add(
                  Row(
                    children: [
                      ScaledContainer(width: CompetitionParticipationItem.roundRelativeWidth, child: item),
                      VerticalDivider(width: 1),
                    ],
                  ),
                );
                round++;
              }
              final boutResults = Row(children: boutResultItems);

              final rank = ranks.elementAtOrNull(phase.pos);
              final points = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ScaledContainer(
                    alignment: Alignment.center,
                    width: CompetitionParticipationItem.pointsRelativeWidth,
                    child: ScaledText(rank?.metric.wins.toString() ?? '-', textAlign: TextAlign.center),
                  ),
                  VerticalDivider(width: 1),
                  ScaledContainer(
                    alignment: Alignment.center,
                    width: CompetitionParticipationItem.pointsRelativeWidth,
                    child: ScaledText(rank?.metric.classificationPoints.toString() ?? '-', textAlign: TextAlign.center),
                  ),
                  VerticalDivider(width: 1),
                  ScaledContainer(
                    alignment: Alignment.center,
                    width: CompetitionParticipationItem.pointsRelativeWidth,
                    child: ScaledText(rank?.metric.technicalPoints.toString() ?? '-', textAlign: TextAlign.center),
                  ),
                  VerticalDivider(width: 1),
                  ScaledContainer(
                    alignment: Alignment.center,
                    color: switch (rank?.rank) {
                      1 => Colors.yellow,
                      2 => Colors.grey,
                      3 => Colors.brown,
                      _ => null,
                    }?.withValues(alpha: 0.3),
                    width: CompetitionParticipationItem.pointsRelativeWidth,
                    child: ScaledText(rank?.rank.toString() ?? '-', textAlign: TextAlign.center),
                  ),
                ],
              );
              return Row(children: [boutResults, points, VerticalDivider(width: 2, thickness: 2)]);
            }),
          ],
        );
        if (participation.isExcluded) {
          return DefaultTextStyle.merge(
            child: row,
            style: TextStyle(color: Theme.of(context).disabledColor),
          );
        }
        return row;
      },
    );
  }
}
