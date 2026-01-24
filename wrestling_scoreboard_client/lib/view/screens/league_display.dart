import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/image.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

// TODO: Loading is quite expensive, as every bout needs to be downloaded in order to sum up the classification points:
//  We could optimize this by saving the points directly in the league-team-participation table,
//  and update it when a bout / team match has changed.
class LeagueDisplay extends ConsumerWidget {
  static const route = 'display';

  static void navigateTo(BuildContext context, League league) {
    context.push('/${LeagueOverview.route}/${league.id}/$route');
  }

  final int id;
  final League? league;
  static const flexWidths = [3, 4, 30, 10, 12, 5, 5, 5, 5];

  const LeagueDisplay({required this.id, this.league, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    final double width = MediaQuery.of(context).size.width;
    final double padding = width / 140;
    return SingleConsumer<League>(
      id: id,
      initialData: league,
      builder: (context, league) {
        final infoAction = DefaultResponsiveScaffoldActionItem(
          label: localizations.info,
          icon: const Icon(Icons.info),
          onTap: () => LeagueOverview.navigateTo(context, league),
        );
        return DisplayTheme(
          child: WindowStateScaffold(
            hideAppBarOnFullscreen: true,
            actions: [infoAction],
            body: ManyConsumer<LeagueTeamParticipation, League>(
              filterObject: league,
              builder: (context, leagueTeamParticipations) {
                return ManyConsumer<TeamMatch, League>(
                  filterObject: league,
                  builder: (context, matches) {
                    Future<List<MapEntry<Team, LeagueTeamPoints>>> getAllLeagueTeamPoints() async {
                      final List<MapEntry<TeamMatch, (LeagueTeamPoints, LeagueTeamPoints)>> teamMatchBoutsMap =
                          await Future.wait(
                            matches.map((tm) async {
                              final bouts = (await _getTeamMatchBouts(ref, tm));
                              final homeCPoints = TeamMatch.getHomePoints(bouts);
                              final guestCPoints = TeamMatch.getGuestPoints(bouts);
                              if (homeCPoints == guestCPoints) {
                                // If the match has not yet taken place, do not count it as tie.
                                final matchStartedValue = homeCPoints == 0 ? 0 : 1;
                                final homePoints = LeagueTeamPoints(
                                  teamPoints: matchStartedValue,
                                  teamLossPoints: matchStartedValue,
                                  classificationPoints: homeCPoints,
                                  classificationLossPoints: guestCPoints,
                                  wins: 0,
                                  ties: matchStartedValue,
                                  losses: 0,
                                  matchCount: matchStartedValue,
                                );
                                final guestPoints = LeagueTeamPoints(
                                  teamPoints: matchStartedValue,
                                  teamLossPoints: matchStartedValue,
                                  classificationPoints: guestCPoints,
                                  classificationLossPoints: homeCPoints,
                                  wins: 0,
                                  ties: matchStartedValue,
                                  losses: 0,
                                  matchCount: matchStartedValue,
                                );
                                return MapEntry(tm, (homePoints, guestPoints));
                              }
                              final LeagueTeamPoints winner, looser;
                              final isHomeWinner = homeCPoints > guestCPoints;
                              winner = LeagueTeamPoints(
                                teamPoints: 2,
                                teamLossPoints: 0,
                                classificationPoints: isHomeWinner ? homeCPoints : guestCPoints,
                                classificationLossPoints: isHomeWinner ? guestCPoints : homeCPoints,
                                wins: 1,
                                ties: 0,
                                losses: 0,
                                matchCount: 1,
                              );
                              looser = LeagueTeamPoints(
                                teamPoints: 0,
                                teamLossPoints: 2,
                                classificationPoints: isHomeWinner ? guestCPoints : homeCPoints,
                                classificationLossPoints: isHomeWinner ? homeCPoints : guestCPoints,
                                wins: 0,
                                ties: 0,
                                losses: 1,
                                matchCount: 1,
                              );
                              return MapEntry(tm, isHomeWinner ? (winner, looser) : (looser, winner));
                            }),
                          );
                      final pointsPerTeam =
                          leagueTeamParticipations.map((ltp) {
                            final pointsTuplePerMatch = teamMatchBoutsMap
                                .where((tmbm) {
                                  return tmbm.key.home.team == ltp.team || tmbm.key.guest.team == ltp.team;
                                })
                                .map((tmbm) {
                                  if (tmbm.key.home.team == ltp.team) {
                                    return tmbm.value.$1;
                                  }
                                  return tmbm.value.$2;
                                });
                            final pointsPerTeam = pointsTuplePerMatch.fold(
                              LeagueTeamPoints(
                                classificationPoints: 0,
                                classificationLossPoints: 0,
                                teamPoints: 0,
                                teamLossPoints: 0,
                                wins: 0,
                                losses: 0,
                                ties: 0,
                                matchCount: 0,
                              ),
                              (p, n) => LeagueTeamPoints(
                                classificationPoints: p.classificationPoints + n.classificationPoints,
                                classificationLossPoints: p.classificationLossPoints + n.classificationLossPoints,
                                teamPoints: p.teamPoints + n.teamPoints,
                                teamLossPoints: p.teamLossPoints + n.teamLossPoints,
                                wins: p.wins + n.wins,
                                losses: p.losses + n.losses,
                                ties: p.ties + n.ties,
                                matchCount: p.matchCount + n.matchCount,
                              ),
                            );
                            return MapEntry(ltp.team, pointsPerTeam);
                          }).toList();
                      pointsPerTeam.sort((b, a) => a.value.compareTo(b.value));
                      return pointsPerTeam;
                    }

                    final headerItems = <Widget>[
                      ScaledText(localizations.rank, softWrap: false, fontSize: 12, minFontSize: 10),
                      ScaledText(localizations.image, softWrap: false, fontSize: 12, minFontSize: 10),
                      ScaledText(localizations.team, softWrap: false, fontSize: 12, minFontSize: 10),
                      Center(
                        child: ScaledText(localizations.teamPoints, softWrap: false, fontSize: 12, minFontSize: 10),
                      ),
                      Center(
                        child: ScaledText(
                          localizations.classificationPoints,
                          softWrap: false,
                          fontSize: 12,
                          minFontSize: 10,
                        ),
                      ),
                      Center(child: ScaledText(localizations.wins, softWrap: false, fontSize: 12, minFontSize: 10)),
                      Center(child: ScaledText(localizations.ties, softWrap: false, fontSize: 12, minFontSize: 10)),
                      Center(child: ScaledText(localizations.losses, softWrap: false, fontSize: 12, minFontSize: 10)),
                      Center(
                        child: ScaledText(localizations.matchCount, softWrap: false, fontSize: 12, minFontSize: 10),
                      ),
                    ];
                    final column = Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:
                                headerItems
                                    .mapIndexed(
                                      (index, element) => Expanded(
                                        flex: LeagueDisplay.flexWidths[index],
                                        child: Padding(padding: EdgeInsets.all(padding), child: element),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        Expanded(
                          child: SafeArea(
                            child: LoadingBuilder(
                              future: getAllLeagueTeamPoints(),
                              builder: (context, pointsPerTeam) {
                                return ListView.builder(
                                  itemCount: pointsPerTeam.length,
                                  itemBuilder: (context, index) {
                                    final team = pointsPerTeam[index].key;
                                    final points = pointsPerTeam[index].value;
                                    return SingleConsumer<Team>(
                                      id: team.id,
                                      initialData: team,
                                      builder: (context, team) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () => TeamOverview.navigateTo(context, team),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children:
                                                      [
                                                            Center(child: ScaledText('${index + 1}.', minFontSize: 10)),
                                                            ManyConsumer<Club, Team>(
                                                              filterObject: team,
                                                              builder:
                                                                  (context, data) => OverlappingCircularImage(
                                                                    imageUris: data.map((e) => e.imageUri).toList(),
                                                                    size: width / 50,
                                                                    borderWidth: 0.5,
                                                                  ),
                                                            ),
                                                            ScaledText(
                                                              team.name,
                                                              softWrap: false,
                                                              minFontSize: 10,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Center(
                                                                    child: ScaledText(
                                                                      '${points.teamPoints} : ${points.teamLossPoints}',
                                                                      softWrap: false,
                                                                      minFontSize: 10,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: PointsDiffChip(points: points.teamPointsDiff),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: Center(
                                                                    child: ScaledText(
                                                                      '${points.classificationPoints} : ${points.classificationLossPoints}',
                                                                      softWrap: false,
                                                                      minFontSize: 10,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: PointsDiffChip(
                                                                    points: points.classificationPointsDiff,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Center(
                                                              child: ScaledText(
                                                                points.wins.toString(),
                                                                softWrap: false,
                                                                minFontSize: 10,
                                                              ),
                                                            ),
                                                            Center(
                                                              child: ScaledText(
                                                                points.ties.toString(),
                                                                softWrap: false,
                                                                minFontSize: 10,
                                                              ),
                                                            ),
                                                            Center(
                                                              child: ScaledText(
                                                                points.losses.toString(),
                                                                softWrap: false,
                                                                minFontSize: 10,
                                                              ),
                                                            ),
                                                            Center(
                                                              child: ScaledText(
                                                                points.matchCount.toString(),
                                                                softWrap: false,
                                                                minFontSize: 10,
                                                              ),
                                                            ),
                                                          ]
                                                          .mapIndexed(
                                                            (index, element) => Expanded(
                                                              flex: LeagueDisplay.flexWidths[index],
                                                              child: Padding(
                                                                padding: EdgeInsets.all(padding),
                                                                child: element,
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                ),
                                              ),
                                            ),
                                            const Divider(height: 1),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                    return column;
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<List<TeamMatchBout>> _getTeamMatchBouts(WidgetRef ref, TeamMatch event) async => await ref.readAsync(
    manyDataStreamProvider(ManyProviderData<TeamMatchBout, TeamMatch>(filterObject: event)).future,
  );
}

class PointsDiffChip extends StatelessWidget {
  const PointsDiffChip({super.key, required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: EdgeInsets.all(0),
      color: WidgetStateProperty.all(
        (points > 0 ? Colors.green : (points < 0 ? Colors.red : null))?.withValues(alpha: 0.2),
      ),
      label: ScaledText('$points', fontSize: 10),
    );
  }
}

class LeagueTeamPoints implements Comparable<LeagueTeamPoints> {
  final int teamPoints;
  final int teamLossPoints;
  final int classificationPoints;
  final int classificationLossPoints;
  final int wins;
  final int losses;
  final int ties;
  final int matchCount;

  const LeagueTeamPoints({
    required this.teamPoints,
    required this.teamLossPoints,
    required this.classificationPoints,
    required this.classificationLossPoints,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.matchCount,
  });

  int get teamPointsDiff => teamPoints - teamLossPoints;

  int get classificationPointsDiff => classificationPoints - classificationLossPoints;

  @override
  int compareTo(LeagueTeamPoints other) {
    final teamPointsComp = teamPoints.compareTo(other.teamPoints);
    if (teamPointsComp != 0) return teamPointsComp;
    final teamPointsDiffComp = teamPointsDiff.compareTo(other.teamPointsDiff);
    if (teamPointsDiffComp != 0) return teamPointsDiffComp;
    final classificationPointsComp = classificationPoints.compareTo(other.classificationPoints);
    if (classificationPointsComp != 0) return classificationPointsComp;
    final classificationPointsDiffComp = classificationPointsDiff.compareTo(other.classificationPointsDiff);
    if (classificationPointsDiffComp != 0) return classificationPointsDiffComp;
    final winsComp = wins.compareTo(other.wins);
    if (winsComp != 0) return winsComp;
    final tiesComp = ties.compareTo(other.ties);
    if (tiesComp != 0) return tiesComp;
    return 0;
  }
}
