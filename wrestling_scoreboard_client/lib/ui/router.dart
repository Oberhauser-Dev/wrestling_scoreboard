import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/app_navigation.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_display.dart';
import 'package:wrestling_scoreboard_client/ui/match/match_display.dart';
import 'package:wrestling_scoreboard_client/ui/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/league_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_overview.dart';

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
            path: '${FightDisplay.route}/:fight_id',
            builder: (context, state) {
              final matchId = int.parse(state.pathParameters['match_id']!);
              final fightId = int.parse(state.pathParameters['fight_id']!);
              return FightDisplay(matchId: matchId, fightId: fightId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '${MembershipOverview.route}/:membership_id',
        builder: (context, state) => MembershipOverview(id: int.parse(state.pathParameters['membership_id']!)),
      ),
    ]),
  ],
);
