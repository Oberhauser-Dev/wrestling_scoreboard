import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/league_weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_weight_class_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_weight_class_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueOverview extends ConsumerWidget {
  static const route = 'league';

  final int id;
  final League? league;

  const LeagueOverview({super.key, required this.id, this.league});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<League>(
      id: id,
      initialData: league,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: LeagueEdit(
            league: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<League>(data),
          classLocale: localizations.league,
          children: [
            ContentItem(
              title: data.startDate.toDateString(context),
              subtitle: localizations.startDate,
              icon: Icons.event,
            ),
            ContentItem(
              title: data.endDate.toDateString(context),
              subtitle: localizations.endDate,
              icon: Icons.event,
            ),
            ContentItem(
              title: data.boutDays.toString(),
              subtitle: localizations.boutDays,
              icon: Icons.calendar_month,
            ),
            ContentItem(
              title: data.division.fullname,
              subtitle: localizations.division,
              icon: Icons.inventory,
            ),
          ],
        );
        return FavoriteScaffold<League>(
          dataObject: data,
          label: localizations.league,
          details: '${data.fullname}, ${data.startDate.year}',
          actions: [
            ConditionalOrganizationImportAction(
                id: id, organization: data.organization!, importType: OrganizationImportType.league)
          ],
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.matches)),
            Tab(child: HeadingText(localizations.participatingTeams)),
            Tab(child: HeadingText(localizations.weightClasses)),
          ],
          body: TabGroup(items: [
            description,
            MatchesWidget<League>(filterObject: data),
            ManyConsumer<LeagueTeamParticipation, League>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueTeamParticipation> teamParticipations) {
                teamParticipations.sort((a, b) => a.team.name.compareTo(b.team.name));
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueTeamParticipationEdit(
                            initialLeague: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: teamParticipations.map(
                    (e) => SingleConsumer<LeagueTeamParticipation>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.team.name,
                            icon: Icons.group,
                            onTap: () => handleSelectedTeam(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            ManyConsumer<LeagueWeightClass, League>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueWeightClass> leagueWeightClasses) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueWeightClassEdit(initialLeague: data),
                        ),
                      ),
                    ),
                  ),
                  items: leagueWeightClasses.map((e) {
                    return SingleConsumer<LeagueWeightClass>(
                      id: e.id,
                      initialData: e,
                      builder: (context, data) {
                        return ContentItem(
                            title: data.localize(context),
                            icon: Icons.fitness_center,
                            onTap: () => handleSelectedWeightClass(data, context));
                      },
                    );
                  }),
                );
              },
            )
          ]),
        );
      },
    );
  }

  handleSelectedTeam(LeagueTeamParticipation teamParticipation, BuildContext context) {
    context.push('/${LeagueTeamParticipationOverview.route}/${teamParticipation.id}');
  }

  handleSelectedWeightClass(LeagueWeightClass leagueWeightClass, BuildContext context) {
    context.push('/${LeagueWeightClassOverview.route}/${leagueWeightClass.id}');
  }
}
