import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/competition.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// Class to load a single bout, while also consider the previous and the next bout.
/// So must load the whole list of bouts to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class CompetitionBoutDisplay extends ConsumerWidget {
  static const route = 'display';

  static String fullRoute(CompetitionBout bout) =>
      '/${CompetitionOverview.route}/${bout.competition.id}/${CompetitionBoutOverview.route}/${bout.id}/$route';

  static void navigateTo(BuildContext context, CompetitionBout bout) {
    context.push(fullRoute(bout));
  }

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
  Widget build(BuildContext context, WidgetRef ref) {
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
            final matCompetitionBouts = competitionBouts.where((cb) => cb.mat == competitionBout.mat).toList();
            final matCompetitionBoutIndex = matCompetitionBouts.indexOf(competitionBout);
            // Use competitionBout for navigation.
            return ManyConsumer<CompetitionParticipation, CompetitionWeightCategory>(
              // TODO: change filter mechanism if weightCategory is null
              filterObject: competitionBout.weightCategory,
              builder: (context, participations) {
                return ManyConsumer<BoutResultRule, BoutConfig>(
                  filterObject: competitionBout.competition.boutConfig,
                  builder: (BuildContext context, List<BoutResultRule> boutResultRules) {
                    return SingleConsumer<Bout>(
                      id: competitionBout.bout.id,
                      builder: (context, bout) {
                        final homeParticipation =
                            CompetitionParticipation.fromParticipationsAndMembershipAndWeightCategory(
                              participations: participations,
                              membership: bout.r?.membership,
                              weightCategory: competitionBout.weightCategory,
                            );
                        final guestParticipation =
                            CompetitionParticipation.fromParticipationsAndMembershipAndWeightCategory(
                              participations: participations,
                              membership: bout.b?.membership,
                              weightCategory: competitionBout.weightCategory,
                            );

                        return BoutScreen(
                          wrestlingEvent: competition,
                          // TODO: Need to be able to define official per bout
                          officials: {},
                          boutConfig: competition.boutConfig,
                          boutRules: boutResultRules,
                          bouts: matCompetitionBouts.map((e) => e.bout).toList(),
                          boutIndex: matCompetitionBoutIndex,
                          bout: bout,
                          mat: competitionBout.displayMat,
                          actions: [
                            DefaultResponsiveScaffoldActionItem(
                              label: localizations.info,
                              icon: const Icon(Icons.info),
                              onTap: () => CompetitionBoutOverview.navigateTo(context, competitionBout),
                            ),
                          ],
                          navigateToBoutByIndex: (context, index) {
                            context.pushReplacement(CompetitionBoutDisplay.fullRoute(matCompetitionBouts[index]));
                          },
                          // TODO
                          headerItems: [],
                          weightClass: competitionBout.weightCategory?.weightClass,
                          ageCategory: competitionBout.weightCategory?.competitionAgeCategory.ageCategory,
                          roundDescription: competitionBout.roundDescription(context),
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
