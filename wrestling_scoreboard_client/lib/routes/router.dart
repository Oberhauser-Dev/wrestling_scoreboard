import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/app_navigation.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/match/match_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppNavigation(), routes: [
      GoRoute(
        path: '${TeamOverview.route}/:team_id',
        builder: (context, state) => TeamOverview(id: int.parse(state.pathParameters['team_id']!)),
      ),
      GoRoute(
        path: '${ClubOverview.route}/:club_id',
        builder: (context, state) => ClubOverview(id: int.parse(state.pathParameters['club_id']!)),
      ),
      GoRoute(
        path: '${LeagueOverview.route}/:league_id',
        builder: (context, state) => LeagueOverview(id: int.parse(state.pathParameters['league_id']!)),
      ),
      GoRoute(
        path: '${TeamMatchOverview.route}/:match_id',
        builder: (context, state) => TeamMatchOverview(id: int.parse(state.pathParameters['match_id']!)),
        routes: [
          GoRoute(
            path: MatchDisplay.route,
            builder: (context, state) => MatchDisplay(id: int.parse(state.pathParameters['match_id']!)),
          ),
          GoRoute(
            path: '${TeamMatchBoutDisplay.route}/:team_match_bout_id',
            builder: (context, state) {
              final matchId = int.parse(state.pathParameters['match_id']!);
              final teamMatchBoutId = int.parse(state.pathParameters['team_match_bout_id']!);
              return TeamMatchBoutDisplay(matchId: matchId, teamMatchBoutId: teamMatchBoutId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '${LeagueTeamParticipationOverview.route}/:participation_id',
        builder: (context, state) =>
            LeagueTeamParticipationOverview(id: int.parse(state.pathParameters['participation_id']!)),
      ),
      GoRoute(
        path: '${LeagueWeightClassOverview.route}/:league_weight_class_id',
        builder: (context, state) =>
            LeagueWeightClassOverview(id: int.parse(state.pathParameters['league_weight_class_id']!)),
      ),
      GoRoute(
        path: '${TeamMatchBoutOverview.route}/:team_match_bout_id',
        builder: (context, state) => TeamMatchBoutOverview(id: int.parse(state.pathParameters['team_match_bout_id']!)),
      ),
      GoRoute(
        path: '${MembershipOverview.route}/:membership_id',
        builder: (context, state) => MembershipOverview(id: int.parse(state.pathParameters['membership_id']!)),
      ),
    ]),
  ],
);
