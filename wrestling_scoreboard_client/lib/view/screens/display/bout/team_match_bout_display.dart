import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
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
                                    final guestParticipation = TeamLineupParticipation.fromParticipationsAndWeightClass(
                                      participations: guestParticipations,
                                      weightClass: teamMatchBout.weightClass,
                                    );

                                    // Watch the single participations, to also get updates when they change participants.
                                    return NullableSingleConsumer<TeamLineupParticipation>(
                                      id: homeParticipation?.id,
                                      builder: (context, home) => NullableSingleConsumer<TeamLineupParticipation>(
                                        id: guestParticipation?.id,
                                        builder: (context, guest) => _LineupMismatchGuard(
                                          match: match,
                                          hasMismatch:
                                              home?.membership != bout.r?.membership ||
                                              guest?.membership != bout.b?.membership,
                                          child: BoutScreen(
                                            wrestlingEvent: match,
                                            officials: Map.fromEntries(
                                              officials.map((tmp) => MapEntry(tmp.person, tmp.role)),
                                            ),
                                            boutConfig:
                                                match.league?.division.boutConfig ?? TeamMatch.defaultBoutConfig,
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
                                              context.pushReplacement(
                                                TeamMatchBoutDisplay.fullRoute(teamMatchBouts[index]),
                                              );
                                            },
                                            headerItems: CommonElements.getTeamHeader(
                                              match.home.team,
                                              match.guest.team,
                                              bouts,
                                              context,
                                            ),
                                            weightClass: teamMatchBout.weightClass,
                                            weightR: home?.weight,
                                            weightB: guest?.weight,
                                          ),
                                        ),
                                      ),
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

/// Proposes to pair the bouts, if the bout does not match the lineups.
///
/// The dialog is shown outside of the build method and only once per mismatch.
class _LineupMismatchGuard extends ConsumerStatefulWidget {
  final TeamMatch match;
  final bool hasMismatch;
  final Widget child;

  const _LineupMismatchGuard({required this.match, required this.hasMismatch, required this.child});

  @override
  ConsumerState<_LineupMismatchGuard> createState() => _LineupMismatchGuardState();
}

class _LineupMismatchGuardState extends ConsumerState<_LineupMismatchGuard> {
  bool _isPrompted = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void didUpdateWidget(covariant _LineupMismatchGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _check();
  }

  void _check() {
    if (!widget.hasMismatch) {
      // Ask again, if a mismatch appears later.
      _isPrompted = false;
      return;
    }
    if (_isPrompted) return;
    _isPrompted = true;
    // Dialogs must not be shown while building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showPairDialog();
    });
  }

  Future<void> _showPairDialog() async {
    final localizations = context.l10n;
    final confirmed = await showOkCancelDialog(
      context: context,
      title: Text(localizations.pairBouts),
      child: Text(localizations.warningBoutLineupMismatch),
      okText: localizations.pairBouts,
    );
    if (!confirmed || !mounted) return;
    await catchAsync(context, () async {
      // Pop, because current bout may be deleted.
      context.pop();
      final dataManager = await ref.read(dataManagerProvider);
      await dataManager.generateBouts<TeamMatch>(widget.match, false);
      if (mounted) {
        await showOkDialog(context: context, child: Text(localizations.actionSuccessful));
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
