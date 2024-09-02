import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/division_weight_class.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/localization/type.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
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
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Home extends ConsumerStatefulWidget {
  static const route = 'home';

  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  Map<String, List<DataObject>>? searchResults;
  Type? searchType;
  Organization? searchOrganization;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final Widget gridEntries;
    if (searchResults != null) {
      if (searchResults!.isEmpty) {
        gridEntries = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(localizations.noItems),
        );
      } else {
        gridEntries = _EntityGrid(
          entities: searchResults!.map(
              (key, resultsOfType) => MapEntry(key, Map.fromEntries(resultsOfType.map((r) => MapEntry(r.id!, r))))),
          onHandleException: <T extends DataObject>({
            required BuildContext context,
            required int id,
            Object? exception,
            StackTrace? stackTrace,
          }) async {
            final localizations = AppLocalizations.of(context)!;
            await showOkDialog(
              context: context,
              child: Column(
                children: [
                  Text('There was a problem with the object of type $T and id $id.'),
                  ExceptionInfo(
                    exception ?? localizations.errorOccurred,
                    stackTrace: stackTrace,
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      gridEntries = LoadingBuilder(
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
            return _EntityGrid(
              entities: favorites.map((k, ids) => MapEntry(k, Map.fromEntries(ids.map((id) => MapEntry(id, null))))),
              onHandleException: <T extends DataObject>({
                required BuildContext context,
                required int id,
                Object? exception,
                StackTrace? stackTrace,
              }) async {
                final localizations = AppLocalizations.of(context)!;
                final removeItem = await showOkCancelDialog(
                  okText: localizations.remove,
                  getResult: () => true,
                  context: context,
                  child: Column(
                    children: [
                      Text('There was a problem with the object of type $T and id $id.'),
                      ExceptionInfo(
                        exception ?? localizations.errorOccurred,
                        stackTrace: stackTrace,
                      ),
                    ],
                  ),
                );
                if (removeItem == true) {
                  final notifier = ref.read(favoritesNotifierProvider.notifier);
                  notifier.removeFavorite(getTableNameFromType(T), id);
                }
              },
            );
          });
    }

    return WindowStateScaffold(
      appBarTitle: Text(localizations.home),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SearchBar(
                padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                leading: const Icon(Icons.search),
                elevation: WidgetStateProperty.all(0),
                side: WidgetStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)),
                backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface),
                onChanged: (searchTerm) async {
                  if (searchTerm.length < 3 && (double.tryParse(searchTerm) == null)) {
                    setState(() {
                      searchResults = null;
                    });
                  } else {
                    try {
                      final authService = (await ref.read(orgAuthNotifierProvider))[searchOrganization?.id];
                      final results = await (await ref.read(dataManagerNotifierProvider)).search(
                          searchTerm: searchTerm,
                          type: searchType,
                          organizationId: searchOrganization?.id,
                          authService: authService);
                      setState(() {
                        searchResults = results;
                      });
                    } catch (e, st) {
                      if (context.mounted) {
                        showExceptionDialog(context: context, exception: e, stackTrace: st);
                      }
                    }
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SimpleDropdown<Type?>(
                    options: [
                      null,
                      ...dataTypes
                        ..remove(ParticipantState)
                        ..remove(User)
                        ..remove(SecuredUser)
                    ].map((type) => MapEntry(
                          type,
                          Text(type != null ? localizeType(context, type) : '${localizations.optionSelect} Type'),
                        )),
                    selected: searchType,
                    onChange: (value) {
                      setState(() {
                        searchType = value;
                      });
                    },
                    isExpanded: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ManyConsumer<Organization, Null>(
                    builder: (BuildContext context, List<Organization> organizations) {
                      return SimpleDropdown<Organization?>(
                        options: [null, ...organizations].map((organization) => MapEntry(
                              organization,
                              Text(organization != null
                                  ? organization.name
                                  : '${localizations.optionSelect} ${localizations.organization}'),
                            )),
                        selected: searchOrganization,
                        onChange: (value) {
                          setState(() {
                            searchOrganization = value;
                          });
                        },
                        isExpanded: false,
                      );
                    },
                    onException: (context, exception, {stackTrace}) => SizedBox(
                      width: 250,
                      child: ExceptionInfo(AppLocalizations.of(context)!.notFoundException, stackTrace: stackTrace),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                searchResults == null ? localizations.favorites : 'Search results',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(child: SingleChildScrollView(child: gridEntries)),
          ],
        ),
      ),
    );
  }
}

class _EntityGrid extends StatelessWidget {
  final Map<String, Map<int, DataObject?>> entities;
  final Future<void> Function<T extends DataObject>({
    required int id,
    required BuildContext context,
    Object? exception,
    StackTrace? stackTrace,
  }) onHandleException;

  const _EntityGrid({required this.entities, required this.onHandleException});

  @override
  Widget build(BuildContext context) {
    final children = entities.entries.map((entry) {
      final tableName = entry.key;
      final ids = entry.value;
      return switch (tableName) {
        // 'bout_config' => buildGroup<BoutConfig>(localizations.boutConfigs, Icons.question_mark, ids, (d) => d.id.toString()),
        'bout' => _buildGroup<Bout>(
            Icons.sports_kabaddi,
            ids.map((id, value) => MapEntry(id, value as Bout?)),
            BoutOverview.route,
            (d) => d.title(context),
            context: context,
          ),
        // 'bout_action' => buildGroup<BoutAction>(localizations.actions, Icons.question_mark, ids, BoutOverview.route, (d) => d.id.toString()),
        'club' => _buildGroup<Club>(
            Icons.foundation,
            ids.map((id, value) => MapEntry(id, value as Club?)),
            ClubOverview.route,
            (d) => d.name,
            context: context,
          ),
        'organization' => _buildGroup<Organization>(
            Icons.corporate_fare,
            ids.map((id, value) => MapEntry(id, value as Organization?)),
            OrganizationOverview.route,
            (d) => d.name,
            context: context,
          ),
        'division' => _buildGroup<Division>(
            Icons.inventory,
            ids.map((id, value) => MapEntry(id, value as Division?)),
            DivisionOverview.route,
            (d) => d.name,
            context: context,
          ),
        'league' => _buildGroup<League>(
            Icons.emoji_events,
            ids.map((id, value) => MapEntry(id, value as League?)),
            LeagueOverview.route,
            (d) => d.fullname,
            context: context,
          ),
        'division_weight_class' => _buildGroup<DivisionWeightClass>(
            Icons.fitness_center,
            ids.map((id, value) => MapEntry(id, value as DivisionWeightClass?)),
            DivisionWeightClassOverview.route,
            (d) => d.localize(context),
            context: context,
          ),
        'league_team_participation' => _buildGroup<LeagueTeamParticipation>(
            Icons.group,
            ids.map((id, value) => MapEntry(id, value as LeagueTeamParticipation?)),
            LeagueTeamParticipationOverview.route,
            (d) => d.team.name,
            context: context,
          ),
        // 'lineup' => buildGroup<Lineup>(localizations.lineups, Icons.view_list, ids, LineupOverview.route, (d) => d.team.name),
        'membership' => _buildGroup<Membership>(
            Icons.person,
            ids.map((id, value) => MapEntry(id, value as Membership?)),
            MembershipOverview.route,
            (d) => d.info,
            context: context,
          ),
        // 'participation' => buildGroup<Participation>(localizations.participations, Icons.question_mark, ids, BoutOverview.route, (d) => d.name),
        // 'participant_state' => buildGroup<ParticipantState>(localizations.participantStates, Icons.question_mark, ids, BoutOverview.route, (d) => d.name),
        'person' => _buildGroup<Person>(
            Icons.person,
            ids.map((id, value) => MapEntry(id, value as Person?)),
            PersonOverview.route,
            (d) => d.fullName,
            context: context,
          ),
        'team' => _buildGroup<Team>(
            Icons.group,
            ids.map((id, value) => MapEntry(id, value as Team?)),
            TeamOverview.route,
            (d) => d.name,
            context: context,
          ),
        'team_match' => _buildGroup<TeamMatch>(
            Icons.event,
            ids.map((id, value) => MapEntry(id, value as TeamMatch?)),
            TeamMatchOverview.route,
            (d) => d.localize(context),
            context: context,
          ),
        'team_match_bout' => _buildGroup<TeamMatchBout>(
            Icons.sports_kabaddi,
            ids.map((id, value) => MapEntry(id, value as TeamMatchBout?)),
            TeamMatchBoutOverview.route,
            (d) => d.bout.title(context),
            context: context,
          ),
        // 'competition' =>
        //   buildGroup<Competition>(localizations.competitions, Icons.leaderboard, ids, CompetitionOverview.route, (d) => d.name),
        'weight_class' => _buildGroup<WeightClass>(
            Icons.fitness_center,
            ids.map((id, value) => MapEntry(id, value as WeightClass?)),
            WeightClassOverview.route,
            (d) => d.name,
            context: context,
          ),
        _ =>
          throw UnimplementedError('Data type $tableName not supported for favorites, please contact the developer.'),
      };
    });
    return Column(children: children.toList());
  }

  Widget _buildGroup<T extends DataObject>(
    IconData iconData,
    Map<int, T?> ids,
    String route,
    String Function(T dataObject) getTitle, {
    required BuildContext context,
  }) {
    return Column(
      children: [
        ListTile(title: Text(localizeType(context, T)), leading: Icon(iconData)),
        GridView.extent(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          maxCrossAxisExtent: 150,
          children: ids.entries
              .map((entry) => _createItem<T>(entry.key, entry.value, route, getTitle, context: context))
              .toList(),
        ),
      ],
    );
  }

  Widget _createItem<T extends DataObject>(int id, T? initialData, String route, String Function(T dataObject) getTitle,
      {required BuildContext context}) {
    return SingleConsumer<T>(
        onException: (context, exception, {stackTrace}) => Card(
              child: Center(
                child: IconButton(
                    onPressed: () =>
                        onHandleException<T>(id: id, context: context, exception: exception, stackTrace: stackTrace),
                    icon: const Icon(Icons.warning)),
              ),
            ),
        id: id,
        initialData: initialData,
        builder: (context, data) {
          return InkWell(
            onTap: () {
              context.push('/$route/$id');
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
