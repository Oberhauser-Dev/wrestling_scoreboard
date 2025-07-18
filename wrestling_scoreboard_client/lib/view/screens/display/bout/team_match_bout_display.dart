import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_common/common.dart';

void navigateToTeamMatchBoutScreen(BuildContext context, TeamMatch match, TeamMatchBout bout) {
  context.push(
    '/${TeamMatchOverview.route}/${match.id}/${TeamMatchBoutOverview.route}/${bout.id}/${TeamMatchBoutDisplay.route}',
  );
}

/// Class to load a single bout, while also consider the previous and the next bout.
/// So must load the whole list of bouts to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class TeamMatchBoutDisplay extends StatelessWidget {
  static const route = 'display';
  final int matchId;
  final int teamMatchBoutId;
  final TeamMatch? initialMatch;

  const TeamMatchBoutDisplay({required this.matchId, required this.teamMatchBoutId, this.initialMatch, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SingleConsumer<TeamMatch>(
      id: matchId,
      initialData: initialMatch,
      builder: (context, match) {
        return ManyConsumer<TeamMatchBout, TeamMatch>(
          filterObject: match,
          builder: (context, teamMatchBouts) {
            if (teamMatchBouts.isEmpty) {
              return Center(child: Text(localizations.noItems, style: Theme.of(context).textTheme.bodySmall));
            }
            final teamMatchBout = teamMatchBouts.singleWhere((element) => element.id == teamMatchBoutId);
            final teamMatchBoutIndex = teamMatchBouts.indexOf(teamMatchBout);
            // Use bout to get the actual state, but use teamMatchBout for navigation.
            return SingleConsumer<Bout>(
              id: teamMatchBout.bout.id,
              initialData: teamMatchBout.bout,
              builder: (context, bout) {
                return ManyConsumer<TeamLineupParticipation, TeamLineup>(
                  filterObject: match.home,
                  builder: (context, homeParticipations) {
                    final homeParticipation = TeamLineupParticipation.fromParticipationsAndMembershipAndWeightClass(
                      participations: homeParticipations,
                      membership: bout.r?.membership,
                      weightClass: teamMatchBout.weightClass,
                    );
                    return ManyConsumer<TeamLineupParticipation, TeamLineup>(
                      filterObject: match.guest,
                      builder: (context, guestParticipations) {
                        final guestParticipation =
                            TeamLineupParticipation.fromParticipationsAndMembershipAndWeightClass(
                              participations: guestParticipations,
                              membership: bout.r?.membership,
                              weightClass: teamMatchBout.weightClass,
                            );
                        return ManyConsumer<BoutResultRule, BoutConfig>(
                          filterObject: teamMatchBout.teamMatch.league!.division.boutConfig,
                          builder: (BuildContext context, List<BoutResultRule> boutResultRules) {
                            final bouts = teamMatchBouts.map((e) => e.bout).toList();
                            return BoutScreen(
                              wrestlingEvent: match,
                              boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                              boutRules: boutResultRules,
                              bouts: bouts,
                              boutIndex: teamMatchBoutIndex,
                              bout: bout,
                              actions: [
                                IconButton(
                                  icon: const Icon(Icons.info),
                                  onPressed:
                                      // FIXME: use `push` route, https://github.com/flutter/flutter/issues/140586
                                      () => context.go(
                                        '/${TeamMatchOverview.route}/${match.id}/${TeamMatchBoutOverview.route}/${teamMatchBout.id}',
                                      ),
                                ),
                              ],
                              navigateToBoutByIndex: (context, index) {
                                context.pop();
                                navigateToTeamMatchBoutScreen(context, match, teamMatchBouts[index]);
                              },
                              headerItems: CommonElements.getTeamHeader(
                                match.home.team,
                                match.guest.team,
                                bouts,
                                context,
                              ),
                              weightClass: teamMatchBout.weightClass,
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
      },
    );
  }
}
