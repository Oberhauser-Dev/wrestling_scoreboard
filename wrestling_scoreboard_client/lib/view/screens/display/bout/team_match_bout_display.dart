import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// Class to load a single bout, while also consider the previous and the next bout.
/// So must load the whole list of bouts to keep track of what comes next.
/// TODO: This may can be done server side with its own request in the future.
class TeamMatchBoutDisplay extends ConsumerWidget {
  static const route = 'display';

  static String fullRoute(TeamMatchBout bout) =>
      '/${TeamMatchOverview.route}/${bout.teamMatch.id}/${TeamMatchBoutOverview.route}/${bout.id}/$route';

  static void navigateTo(BuildContext context, TeamMatchBout bout) {
    context.push(fullRoute(bout));
  }

  final int matchId;
  final int teamMatchBoutId;
  final TeamMatch? initialMatch;

  const TeamMatchBoutDisplay({required this.matchId, required this.teamMatchBoutId, this.initialMatch, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<TeamMatch>(
      id: matchId,
      initialData: initialMatch,
      builder: (context, match) {
        return ManyConsumer<TeamMatchPerson, TeamMatch>(
          filterObject: match,
          builder: (context, officials) {
            return ManyConsumer<TeamLineupParticipation, TeamLineup>(
              filterObject: match.home,
              builder: (context, homeParticipations) {
                return ManyConsumer<TeamLineupParticipation, TeamLineup>(
                  filterObject: match.guest,
                  builder: (context, guestParticipations) {
                    return ManyConsumer<TeamMatchBout, TeamMatch>(
                      filterObject: match,
                      builder: (context, teamMatchBouts) {
                        if (teamMatchBouts.isEmpty) {
                          return Center(
                            child: Text(localizations.noItems, style: Theme.of(context).textTheme.bodySmall),
                          );
                        }
                        teamMatchBouts = TeamMatchBout.sortChronologically(teamMatchBouts);
                        final teamMatchBout = teamMatchBouts.singleWhere((element) => element.id == teamMatchBoutId);
                        final teamMatchBoutIndex = teamMatchBouts.indexOf(teamMatchBout);
                        // Use bout to get the actual state, but use teamMatchBout for navigation.
                        return ManyConsumer<BoutResultRule, BoutConfig>(
                          filterObject: teamMatchBout.teamMatch.league!.division.boutConfig,
                          builder: (BuildContext context, List<BoutResultRule> boutResultRules) {
                            final bouts = teamMatchBouts.map((e) => e.bout).toList();
                            return SingleConsumer<TeamMatchBout>(
                              id: teamMatchBout.id,
                              builder: (context, teamMatchBout) {
                                return SingleConsumer<Bout>(
                                  id: teamMatchBout.bout.id,
                                  builder: (context, bout) {
                                    final homeParticipation = TeamLineupParticipation.fromParticipationsAndWeightClass(
                                      participations: homeParticipations,
                                      weightClass: teamMatchBout.weightClass,
                                    );
                                    assert(
                                      homeParticipation?.membership == bout.r?.membership,
                                      'Memberships of home do not match',
                                    );
                                    final guestParticipation = TeamLineupParticipation.fromParticipationsAndWeightClass(
                                      participations: guestParticipations,
                                      weightClass: teamMatchBout.weightClass,
                                    );
                                    assert(
                                      guestParticipation?.membership == bout.b?.membership,
                                      'Memberships of guest do not match',
                                    );

                                    return BoutScreen(
                                      wrestlingEvent: match,
                                      officials: Map.fromEntries(
                                        officials.map((tmp) => MapEntry(tmp.person, tmp.role)),
                                      ),
                                      boutConfig: match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
                                      boutRules: boutResultRules,
                                      bouts: bouts,
                                      boutIndex: teamMatchBoutIndex,
                                      bout: bout,
                                      actions: [
                                        DefaultResponsiveScaffoldActionItem(
                                          label: localizations.info,
                                          icon: const Icon(Icons.info),
                                          onTap: () => TeamMatchBoutOverview.navigateTo(context, teamMatchBout),
                                        ),
                                      ],
                                      navigateToBoutByIndex: (context, index) {
                                        context.pushReplacement(TeamMatchBoutDisplay.fullRoute(teamMatchBouts[index]));
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
          },
        );
      },
    );
  }
}
