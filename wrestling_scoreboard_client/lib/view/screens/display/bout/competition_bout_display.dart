import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void navigateToCompetitionBoutScreen(BuildContext context, Competition competition, CompetitionBout bout) {
  context.push(
    '/${CompetitionOverview.route}/${competition.id}/${CompetitionBoutOverview.route}/${bout.id}/${CompetitionBoutDisplay.route}',
  );
}

/// Class to load a single bout, while also consider the previous and the next bout.
/// So must load the whole list of bouts to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class CompetitionBoutDisplay extends StatelessWidget {
  static const route = 'display';
  final int competitionId;
  final int competitionBoutId;
  final Competition? initialMatch;

  const CompetitionBoutDisplay({
    required this.competitionId,
    required this.competitionBoutId,
    this.initialMatch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SingleConsumer<Competition>(
      id: competitionId,
      initialData: initialMatch,
      builder: (context, competition) {
        return ManyConsumer<CompetitionBout, Competition>(
          filterObject: competition,
          builder: (context, competitionBouts) {
            if (competitionBouts.isEmpty) {
              return Center(child: Text(localizations.noItems, style: Theme.of(context).textTheme.bodySmall));
            }
            final competitionBout = competitionBouts.singleWhere((element) => element.id == competitionBoutId);
            final competitionBoutIndex = competitionBouts.indexOf(competitionBout);
            // Use bout to get the actual state, but use competitionBout for navigation.
            return SingleConsumer<Bout>(
              id: competitionBout.bout.id,
              initialData: competitionBout.bout,
              builder: (context, bout) {
                return ManyConsumer<CompetitionParticipation, CompetitionWeightCategory>(
                  // TODO: change filter mechanism if weightCategory is null
                  filterObject: competitionBout.weightCategory,
                  builder: (context, participations) {
                    final homeParticipation = CompetitionParticipation.fromParticipationsAndMembershipAndWeightCategory(
                      participations: participations,
                      membership: bout.r?.membership,
                      weightCategory: competitionBout.weightCategory,
                    );
                    final guestParticipation =
                        CompetitionParticipation.fromParticipationsAndMembershipAndWeightCategory(
                          participations: participations,
                          membership: bout.r?.membership,
                          weightCategory: competitionBout.weightCategory,
                        );

                    return ManyConsumer<BoutResultRule, BoutConfig>(
                      filterObject: competitionBout.competition.boutConfig,
                      builder: (BuildContext context, List<BoutResultRule> boutResultRules) {
                        return BoutScreen(
                          wrestlingEvent: competition,
                          boutConfig: competition.boutConfig,
                          boutRules: boutResultRules,
                          bouts: competitionBouts.map((e) => e.bout).toList(),
                          boutIndex: competitionBoutIndex,
                          bout: bout,
                          onPressBoutInfo: (BuildContext context) {
                            // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
                            context.go(
                              '/${CompetitionOverview.route}/${competition.id}/${CompetitionBoutOverview.route}/${competitionBout.id}',
                            );
                          },
                          navigateToBoutByIndex: (context, index) {
                            context.pop();
                            navigateToCompetitionBoutScreen(context, competition, competitionBouts[index]);
                          },
                          headerItems: [], // TODO
                          weightClass: competitionBout.weightCategory?.weightClass,
                          ageCategory: competitionBout.weightCategory?.ageCategory,
                          weightR: homeParticipation?.weight,
                          weightB: guestParticipation?.weight,
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
