import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/app_navigation.dart';
import 'package:wrestling_scoreboard_client/ui/fight/fight_screen.dart';
import 'package:wrestling_scoreboard_client/ui/match/match_sequence.dart';
import 'package:wrestling_scoreboard_client/ui/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/league_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_overview.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppNavigation(), routes: [
      GoRoute(
        path: '${TeamOverview.route}/:id',
        builder: (context, state) => TeamOverview(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '${ClubOverview.route}/:id',
        builder: (context, state) => ClubOverview(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '${LeagueOverview.route}/:id',
        builder: (context, state) => LeagueOverview(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '${TeamMatchOverview.route}/:match_id',
        builder: (context, state) => TeamMatchOverview(id: int.parse(state.pathParameters['match_id']!)),
        routes: [
          GoRoute(
            path: MatchSequence.route,
            builder: (context, state) => MatchSequence(id: int.parse(state.pathParameters['match_id']!)),
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
        path: '${MembershipOverview.route}/:id',
        builder: (context, state) => MembershipOverview(id: int.parse(state.pathParameters['id']!)),
      ),
    ]),
  ],
);
