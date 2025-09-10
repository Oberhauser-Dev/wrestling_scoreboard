import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_club_affiliation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/league_team_participation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/match_list.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/league_team_participation_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamOverview<T extends DataObject> extends ConsumerWidget {
  static const route = 'team';

  static void navigateTo(BuildContext context, Team team) {
    context.push('/$route/${team.id}');
  }

  final int id;
  final Team? team;

  const TeamOverview({super.key, required this.id, this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<Team>(
      id: id,
      initialData: team,
      builder: (context, team) {
        final description = InfoWidget(
          obj: team,
          editPage: TeamEdit(team: team),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Team>(team),
          classLocale: localizations.team,
          children: [
            ContentItem(title: team.description ?? '-', subtitle: localizations.description, icon: Icons.subject),
          ],
        );
        return FavoriteScaffold<Team>(
          dataObject: team,
          label: localizations.team,
          details: team.name,
          actions: const [
            // TODO: Enable, when endpoint is ready
            // ConditionalOrganizationImportAction(
            //     id: id, organization: team.organization!, importType: OrganizationImportType.team)
          ],
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.matches)),
            Tab(child: HeadingText(localizations.clubs)),
            Tab(child: HeadingText(localizations.leagues)),
          ],
          body: TabGroup(
            items: [
              description,
              MatchList<Team>(filterObject: team),
              FilterableManyConsumer<Club, Team>.addOrCreate(
                context: context,
                filterObject: team,
                addPageBuilder: (context) => TeamClubAffiliationEdit(initialTeam: team),
                createPageBuilder:
                    (context) => ClubEdit(
                      initialOrganization: team.organization,
                      onCreated: (club) async {
                        await (await ref.read(
                          dataManagerNotifierProvider,
                        )).createOrUpdateSingle(TeamClubAffiliation(team: team, club: club));
                      },
                    ),
                itemBuilder:
                    (context, club) => ContentItem(
                      title: club.name,
                      icon: Icons.foundation,
                      onTap: () => ClubOverview.navigateTo(context, club),
                    ),
              ),
              FilterableManyConsumer<LeagueTeamParticipation, Team>.add(
                context: context,
                addPageBuilder: (context) => LeagueTeamParticipationEdit(initialTeam: team),
                filterObject: team,
                mapData:
                    (teamParticipations) =>
                        teamParticipations..sort((a, b) {
                          final dateComp = b.league.startDate.compareTo(a.league.startDate);
                          if (dateComp != 0) return dateComp;
                          return a.league.fullname.compareTo(b.league.fullname);
                        }),
                itemBuilder:
                    (context, item) => ContentItem(
                      title: '${item.league.fullname}, ${item.league.startDate.year}',
                      icon: Icons.emoji_events,
                      onTap: () => LeagueTeamParticipationOverview.navigateTo(context, item),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
