import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/app.dart';
import 'package:wrestling_scoreboard_client/view/app_navigation.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/bout/bout_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/display/match/match_display.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/explore.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/home.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/organization_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';

getRouter() {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
    initialLocation: '/${Home.route}',
    navigatorKey: rootNavigatorKey,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ConnectionWidget(child: AppNavigation(child: child));
        },
        routes: [
          GoRoute(
            path: '/${Home.route}',
            builder: (context, state) => const Home(),
          ),
          GoRoute(
            path: '/${Explore.route}',
            builder: (context, state) => const Explore(),
            routes: [
              GoRoute(
                path: '${TeamOverview.route}/:team_id',
                builder: (context, state) => TeamOverview(id: int.parse(state.pathParameters['team_id']!)),
              ),
              GoRoute(
                path: '${ClubOverview.route}/:club_id',
                builder: (context, state) => ClubOverview(id: int.parse(state.pathParameters['club_id']!)),
              ),
              GoRoute(
                path: '${OrganizationOverview.route}/:organization_id',
                builder: (context, state) =>
                    OrganizationOverview(id: int.parse(state.pathParameters['organization_id']!)),
              ),
              GoRoute(
                path: '${DivisionOverview.route}/:division_id',
                builder: (context, state) => DivisionOverview(id: int.parse(state.pathParameters['division_id']!)),
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
                    parentNavigatorKey: rootNavigatorKey, // Hide bottom navigation bar
                    builder: (context, state) => MatchDisplay(id: int.parse(state.pathParameters['match_id']!)),
                  ),
                  GoRoute(
                    path: '${TeamMatchBoutDisplay.route}/:team_match_bout_id',
                    parentNavigatorKey: rootNavigatorKey, // Hide bottom navigation bar
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
                path: '${DivisionWeightClassOverview.route}/:division_weight_class_id',
                builder: (context, state) =>
                    DivisionWeightClassOverview(id: int.parse(state.pathParameters['division_weight_class_id']!)),
              ),
              GoRoute(
                path: '${TeamMatchBoutOverview.route}/:team_match_bout_id',
                builder: (context, state) =>
                    TeamMatchBoutOverview(id: int.parse(state.pathParameters['team_match_bout_id']!)),
              ),
              GoRoute(
                path: '${MembershipOverview.route}/:membership_id',
                builder: (context, state) => MembershipOverview(id: int.parse(state.pathParameters['membership_id']!)),
              ),
            ],
          ),
          GoRoute(
            path: '/${MoreScreen.route}',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
    ],
  );
}
