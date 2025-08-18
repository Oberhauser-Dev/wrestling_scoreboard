import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/bout_utils.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/division_weight_class.dart';
import 'package:wrestling_scoreboard_client/localization/league_weight_class.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/localization/type.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/search.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/explore.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/profile.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/sign_in.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/organization_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/scratch_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_bout_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Home extends ConsumerWidget {
  static const route = '';

  /// Use this route to indicate that the path is the root default route on home and does not have a path name.
  /// If using `Home.route` only with a slash, subpaths would result in `//my-sub-path` instead of `/my-sub-path`.
  /// This empty string looks like it serves no purpose, but it ensures one can look up all routes supposed to be a subpath of home.
  static const defaultEmptyRoute = '';

  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return LoadingBuilder<User?>(
      future: ref.watch(userNotifierProvider),
      builder: (context, user) {
        return WindowStateScaffold(
          appBarTitle: Text(localizations.start),
          actions: [
            ResponsiveScaffoldActionItem(
              onTap: () => ScratchBoutOverview.navigateTo(context, ref),
              icon: const Icon(Icons.rocket_launch),
              label: localizations.launchScratchBout,
            ),
            ResponsiveScaffoldActionItem(
              onTap: () {
                if (user == null) {
                  context.push('/${MoreScreen.route}/${SignInScreen.route}');
                } else {
                  context.push('/${MoreScreen.route}/${ProfileScreen.route}');
                }
              },
              icon: Icon(user == null ? Icons.login : Icons.account_circle),
              label: user == null ? localizations.auth_signIn : '${localizations.profile}: ${user.username}',
            ),
          ],
          body: ResponsiveContainer(child: _HomeSearch()),
        );
      },
    );
  }
}

class _HomeSearch extends ConsumerStatefulWidget {
  const _HomeSearch();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeSearchState();
}

class _HomeSearchState extends ConsumerState<_HomeSearch> {
  Map<String, List<DataObject>>? _searchResults;
  Type? _searchType;
  Organization? _searchOrganization;
  bool _showFilterOptions = false;
  Timer? _throttleTimer;

  @override
  void dispose() {
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    final Widget gridEntries;
    if (_searchResults != null) {
      if (_searchResults!.isEmpty) {
        gridEntries = Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text(localizations.noItems));
      } else {
        gridEntries = _EntityGrid(
          entities: _searchResults!.map(
            (key, resultsOfType) => MapEntry(key, Map.fromEntries(resultsOfType.map((r) => MapEntry(r.id!, r)))),
          ),
          onHandleException: <T extends DataObject>({
            required BuildContext context,
            required int id,
            Object? exception,
            StackTrace? stackTrace,
          }) async {
            final localizations = context.l10n;
            await showOkDialog(
              context: context,
              child: Column(
                children: [
                  Text('There was a problem with the object of type "$T" and id "$id".'),
                  ExceptionInfo(exception ?? localizations.errorOccurred, stackTrace: stackTrace),
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
                    const TextSpan(text: 'No favorites yet. Add some using the '),
                    const WidgetSpan(child: Icon(Icons.star, size: 14)),
                    const TextSpan(text: ' symbol on the top right corner while '),
                    TextSpan(
                      text: 'exploring.',
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
            actionItemBuilder: <T extends DataObject>(context, id) {
              final localizations = context.l10n;
              return [
                PopupMenuItem(
                  child: Text(localizations.remove),
                  onTap: () {
                    final notifier = ref.read(favoritesNotifierProvider.notifier);
                    notifier.removeFavorite(getTableNameFromType(T), id);
                  },
                ),
              ];
            },
            onHandleException: <T extends DataObject>({
              required BuildContext context,
              required int id,
              Object? exception,
              StackTrace? stackTrace,
            }) async {
              final localizations = context.l10n;
              final removeItem = await showOkCancelDialog(
                okText: localizations.remove,
                context: context,
                child: Column(
                  children: [
                    Text('There was a problem with the object of type $T and id $id.'),
                    ExceptionInfo(exception ?? localizations.errorOccurred, stackTrace: stackTrace),
                  ],
                ),
              );
              if (removeItem) {
                final notifier = ref.read(favoritesNotifierProvider.notifier);
                notifier.removeFavorite(getTableNameFromType(T), id);
              }
            },
          );
        },
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: SearchBar(
            autoFocus: isOnDesktop,
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
            leading: const Icon(Icons.search),
            trailing: [
              IconButton(
                onPressed:
                    () => setState(() {
                      _showFilterOptions = !_showFilterOptions;
                    }),
                icon: Icon(_showFilterOptions ? Icons.tune_outlined : Icons.tune),
              ),
            ],
            elevation: WidgetStateProperty.all(0),
            side: WidgetStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)),
            backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface),
            onChanged: (searchTerm) async {
              _throttleTimer?.cancel();
              if (!isValidSearchTerm(searchTerm)) {
                setState(() {
                  _searchResults = null;
                });
              } else {
                _throttleTimer = Timer(throttleDuration, () async {
                  try {
                    final authService = await ref
                        .read(orgAuthNotifierProvider.notifier)
                        .getByOrganization(_searchOrganization?.id);
                    final results = await (await ref.read(dataManagerNotifierProvider)).search(
                      searchTerm: searchTerm,
                      type: _searchType,
                      organizationId: _searchOrganization?.id,
                      authService: authService,
                    );
                    setState(() {
                      _searchResults = results;
                    });
                  } catch (e, st) {
                    if (context.mounted) {
                      await showExceptionDialog(context: context, exception: e, stackTrace: st);
                    }
                  }
                });
              }
            },
          ),
        ),
        if (_showFilterOptions)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SimpleDropdown<Type?>(
                  options: [null, ...searchableDataTypes.keys].map(
                    (type) => MapEntry(
                      type,
                      Text(type != null ? localizeType(context, type) : '${localizations.optionSelect} Type'),
                    ),
                  ),
                  selected: _searchType,
                  onChange: (value) {
                    setState(() {
                      _searchType = value;
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
                      options: [null, ...organizations].map(
                        (organization) => MapEntry(
                          organization,
                          Text(
                            organization != null
                                ? organization.name
                                : '${localizations.optionSelect} ${localizations.organization}',
                          ),
                        ),
                      ),
                      selected: _searchOrganization,
                      onChange: (value) {
                        setState(() {
                          _searchOrganization = value;
                        });
                      },
                      isExpanded: false,
                    );
                  },
                  onException:
                      (context, exception, {stackTrace}) => SizedBox(
                        width: 250,
                        child: ExceptionInfo(context.l10n.notFoundException, stackTrace: stackTrace),
                      ),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            _searchResults == null ? localizations.favorites : localizations.searchResults,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(child: SingleChildScrollView(child: gridEntries)),
      ],
    );
  }
}

class _EntityGrid extends ConsumerWidget {
  final Map<String, Map<int, DataObject?>> entities;
  final Future<void> Function<T extends DataObject>({
    required int id,
    required BuildContext context,
    Object? exception,
    StackTrace? stackTrace,
  })
  onHandleException;
  final List<PopupMenuItem<T>> Function<T extends DataObject>(BuildContext context, int id)? actionItemBuilder;

  const _EntityGrid({required this.entities, required this.onHandleException, this.actionItemBuilder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = entities.entries.map((entry) {
      final tableName = entry.key;
      final ids = entry.value;
      return switch (tableName) {
        // 'bout_config' => buildGroup<BoutConfig>(localizations.boutConfigs, Icons.question_mark, ids, (d) => d.id.toString()),
        // 'bout_action' => buildGroup<BoutAction>(localizations.actions, Icons.question_mark, ids, BoutOverview.route, (d) => d.id.toString()),
        'club' => _buildGroup<Club>(
          Icons.foundation,
          ids.map((id, value) => MapEntry(id, value as Club?)),
          ClubOverview.route,
          (d) => d.name,
          context: context,
        ),
        'competition' => _buildGroup<Competition>(
          Icons.leaderboard,
          ids.map((id, value) => MapEntry(id, value as Competition?)),
          CompetitionOverview.route,
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
          (d) => '${d.fullname}, ${d.startDate.year}',
          context: context,
        ),
        'league' => _buildGroup<League>(
          Icons.emoji_events,
          ids.map((id, value) => MapEntry(id, value as League?)),
          LeagueOverview.route,
          (d) => '${d.fullname}, ${d.startDate.year}',
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
        'league_weight_class' => _buildGroup<LeagueWeightClass>(
          Icons.fitness_center,
          ids.map((id, value) => MapEntry(id, value as LeagueWeightClass?)),
          LeagueWeightClassOverview.route,
          (d) => d.localize(context),
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
        _ =>
          (() {
            final notifier = ref.read(favoritesNotifierProvider.notifier);
            ids.forEach((id, value) => notifier.removeFavorite(tableName, id));
            throw UnimplementedError('Data type $tableName not supported for favorites, please contact the developer.');
          })(),
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
          children:
              ids.entries
                  .map((entry) => _createItem<T>(entry.key, entry.value, route, getTitle, context: context))
                  .toList(),
        ),
      ],
    );
  }

  Widget _createItem<T extends DataObject>(
    int id,
    T? initialData,
    String route,
    String Function(T dataObject) getTitle, {
    required BuildContext context,
  }) {
    return SingleConsumer<T>(
      onException:
          (context, exception, {stackTrace}) => Card(
            child: Center(
              child: IconButton(
                onPressed:
                    () => onHandleException<T>(id: id, context: context, exception: exception, stackTrace: stackTrace),
                icon: const Icon(Icons.warning),
              ),
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
                image: DecorationImage(image: AssetImage('assets/images/icons/launcher.png')),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(getTitle(data), style: const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (actionItemBuilder != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<T>(itemBuilder: (context) => actionItemBuilder!(context, id)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
