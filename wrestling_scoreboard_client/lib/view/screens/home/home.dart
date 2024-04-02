import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/division_weight_class.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/explore.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/organization_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Home extends ConsumerStatefulWidget {
  static const route = 'home';

  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.home)),
      body: LoadingBuilder(
          future: ref.watch(favoritesNotifierProvider),
          builder: (context, favorites) {
            if (favorites.isEmpty) {
              return Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "No favorites yet. Add some using the "),
                      const WidgetSpan(child: Icon(Icons.star, size: 14)),
                      const TextSpan(text: " symbol on the top right corner while "),
                      TextSpan(
                        text: "exploring.",
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () => context.go('/${Explore.route}'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final children = favorites.entries.map((entry) {
              final tableName = entry.key;
              final ids = entry.value;
              return switch (tableName) {
                // 'bout_config' => buildGroup<BoutConfig>(localizations.boutConfigs, Icons.question_mark, ids, (d) => d.id.toString()),
                'bout' => buildGroup<Bout>(
                    localizations.bouts, Icons.sports_kabaddi, ids, BoutOverview.route, (d) => d.title(context)),
                // 'bout_action' => buildGroup<BoutAction>(localizations.actions, Icons.question_mark, ids, BoutOverview.route, (d) => d.id.toString()),
                'club' =>
                  buildGroup<Club>(localizations.clubs, Icons.foundation, ids, ClubOverview.route, (d) => d.name),
                'organization' => buildGroup<Organization>(
                    localizations.organizations, Icons.corporate_fare, ids, OrganizationOverview.route, (d) => d.name),
                'division' => buildGroup<Division>(
                    localizations.divisions, Icons.inventory, ids, DivisionOverview.route, (d) => d.name),
                'league' => buildGroup<League>(
                    localizations.leagues, Icons.emoji_events, ids, LeagueOverview.route, (d) => d.fullname),
                'division_weight_class' => buildGroup<DivisionWeightClass>(localizations.weightClasses,
                    Icons.fitness_center, ids, DivisionWeightClassOverview.route, (d) => d.localize(context)),
                'league_team_participation' => buildGroup<LeagueTeamParticipation>(localizations.participatingTeam,
                    Icons.group, ids, LeagueTeamParticipationOverview.route, (d) => d.team.name),
                // 'lineup' => buildGroup<Lineup>(localizations.lineups, Icons.view_list, ids, LineupOverview.route, (d) => d.team.name),
                'membership' => buildGroup<Membership>(
                    localizations.memberships, Icons.person, ids, MembershipOverview.route, (d) => d.info),
                // 'participation' => buildGroup<Participation>(localizations.participations, Icons.question_mark, ids, BoutOverview.route, (d) => d.name),
                // 'participant_state' => buildGroup<ParticipantState>(localizations.participantStates, Icons.question_mark, ids, BoutOverview.route, (d) => d.name),
                'person' =>
                  buildGroup<Person>(localizations.persons, Icons.person, ids, PersonOverview.route, (d) => d.fullName),
                'team' => buildGroup<Team>(localizations.teams, Icons.group, ids, TeamOverview.route, (d) => d.name),
                'team_match' => buildGroup<TeamMatch>(
                    localizations.matches, Icons.event, ids, TeamMatchOverview.route, (d) => d.localize(context)),
                'team_match_bout' => buildGroup<TeamMatchBout>(localizations.bouts, Icons.sports_kabaddi, ids,
                    TeamMatchBoutOverview.route, (d) => d.bout.title(context)),
                // 'competition' =>
                //   buildGroup<Competition>(localizations.competitions, Icons.leaderboard, ids, CompetitionOverview.route, (d) => d.name),
                'weight_class' => buildGroup<WeightClass>(
                    localizations.weightClasses, Icons.fitness_center, ids, WeightClassOverview.route, (d) => d.name),
                _ => throw UnimplementedError(
                    'Data type $tableName not supported for favorites, please contact the developer.'),
              };
            });
            return ResponsiveColumn(children: children.toList());
          }),
    );
  }

  Widget buildGroup<T extends DataObject>(
    String groupTitle,
    IconData iconData,
    Set<int> ids,
    String route,
    String Function(T dataObject) getTitle,
  ) {
    return Column(
      children: [
        ListTile(title: Text(groupTitle), leading: Icon(iconData)),
        GridView.extent(
          maxCrossAxisExtent: 150,
          shrinkWrap: true,
          children: ids.map((id) => _createItem<T>(id, route, getTitle)).toList(),
        ),
      ],
    );
  }

  Widget _createItem<T extends DataObject>(int id, String route, String Function(T dataObject) getTitle) {
    return SingleConsumer<T>(
        id: id,
        builder: (context, data) {
          return InkWell(
            onTap: () {
              context.go('/$route/$id');
            },
            child: Card(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/icons/launcher.png'))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(getTitle(data), style: const TextStyle(color: Colors.white)),
                              ))),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
