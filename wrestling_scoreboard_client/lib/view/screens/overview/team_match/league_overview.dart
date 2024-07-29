import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
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
        return OverviewScaffold<League>(
          dataObject: data,
          label: localizations.league,
          details: data.name,
          actions: [
            OrganizationImportAction(id: id, orgId: data.organization!.id!, importType: OrganizationImportType.league)
          ],
          body: GroupedList(items: [
            description,
            ManyConsumer<LeagueTeamParticipation, League>(
              filterObject: data,
              builder: (BuildContext context, List<LeagueTeamParticipation> teamParticipations) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.participatingTeams,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
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
            MatchesWidget<League>(filterObject: data),
          ]),
        );
      },
    );
  }

  handleSelectedTeam(LeagueTeamParticipation teamParticipation, BuildContext context) {
    context.push('/${LeagueTeamParticipationOverview.route}/${teamParticipation.id}');
  }
}
