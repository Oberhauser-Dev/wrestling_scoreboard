import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
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
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/match_list.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_weight_class_overview.dart';
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
    final localizations = context.l10n;
    return SingleConsumer<League>(
      id: id,
      initialData: league,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: LeagueEdit(league: data),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<League>(data),
          classLocale: localizations.league,
          children: [
            ContentItem(
              title: data.startDate.toDateString(context),
              subtitle: localizations.startDate,
              icon: Icons.event,
            ),
            ContentItem(title: data.endDate.toDateString(context), subtitle: localizations.endDate, icon: Icons.event),
            ContentItem(title: data.boutDays.toString(), subtitle: localizations.boutDays, icon: Icons.calendar_month),
            ContentItem(title: data.division.fullname, subtitle: localizations.division, icon: Icons.inventory),
          ],
        );
        return FavoriteScaffold<League>(
          dataObject: data,
          label: localizations.league,
          details: '${data.fullname}, ${data.startDate.year}',
          actions: [
            ConditionalOrganizationImportAction(
              id: id,
              organization: data.organization!,
              importType: OrganizationImportType.league,
            ),
          ],
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.matches)),
            Tab(child: HeadingText(localizations.participatingTeams)),
            Tab(child: HeadingText(localizations.weightClasses)),
          ],
          body: TabGroup(
            items: [
              description,
              MatchList<League>(filterObject: data),
              FilterableManyConsumer<LeagueTeamParticipation, League>.edit(
                context: context,
                editPageBuilder: (context) => LeagueTeamParticipationEdit(initialLeague: data),
                filterObject: data,
                mapData: (teamParticipations) => teamParticipations..sort((a, b) => a.team.name.compareTo(b.team.name)),
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.team.name,
                      icon: Icons.group,
                      onTap: () => handleSelectedTeam(item, context),
                    ),
              ),
              FilterableManyConsumer<LeagueWeightClass, League>.edit(
                context: context,
                editPageBuilder: (context) => LeagueWeightClassEdit(initialLeague: data),
                filterObject: data,
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.localize(context),
                      icon: Icons.fitness_center,
                      onTap: () => handleSelectedWeightClass(item, context),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleSelectedTeam(LeagueTeamParticipation teamParticipation, BuildContext context) {
    context.push('/${LeagueTeamParticipationOverview.route}/${teamParticipation.id}');
  }

  void handleSelectedWeightClass(LeagueWeightClass leagueWeightClass, BuildContext context) {
    context.push('/${LeagueWeightClassOverview.route}/${leagueWeightClass.id}');
  }
}
