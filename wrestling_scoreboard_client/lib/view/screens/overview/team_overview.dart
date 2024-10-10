import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_club_affiliation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/matches_widget.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamOverview<T extends DataObject> extends ConsumerWidget {
  static const route = 'team';

  final int id;
  final Team? team;

  const TeamOverview({super.key, required this.id, this.team});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Team>(
        id: id,
        initialData: team,
        builder: (context, team) {
          final description = InfoWidget(
              obj: team,
              editPage: TeamEdit(
                team: team,
              ),
              onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Team>(team),
              classLocale: localizations.team,
              children: [
                ContentItem(
                  title: team.description ?? '-',
                  subtitle: localizations.description,
                  icon: Icons.subject,
                ),
              ]);
          return OverviewScaffold<Team>(
            dataObject: team,
            label: localizations.team,
            details: team.name,
            actions: [
              ConditionalOrganizationImportAction(
                  id: id, organization: team.organization!, importType: OrganizationImportType.team)
            ],
            tabs: [
              Tab(child: HeadingText(localizations.info)),
              Tab(child: HeadingText(localizations.matches)),
              Tab(child: HeadingText(localizations.clubs)),
            ],
            body: TabGroup(items: [
              description,
              MatchesWidget<Team>(filterObject: team),
              ManyConsumer<Club, Team>(
                filterObject: team,
                builder: (BuildContext context, List<Club> clubs) {
                  return GroupedList(
                    header: HeadingItem(
                      trailing: MenuAnchor(
                        menuChildren: [
                          MenuItemButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClubEdit(
                                  initialOrganization: team.organization,
                                  onCreated: (club) async {
                                    await (await ref.read(dataManagerNotifierProvider))
                                        .createOrUpdateSingle(TeamClubAffiliation(team: team, club: club));
                                  },
                                ),
                              ),
                            ),
                            child: Text(localizations.create),
                          ),
                          MenuItemButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamClubAffiliationEdit(
                                  initialTeam: team,
                                ),
                              ),
                            ),
                            child: Text(localizations.addExisting),
                          ),
                        ],
                        builder: (context, controller, child) => RestrictedAddButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                        ),
                      ),
                    ),
                    items: clubs.map((club) => SingleConsumer<Club>(
                        id: club.id,
                        initialData: club,
                        builder: (context, club) {
                          return ContentItem(
                              title: club.name, icon: Icons.foundation, onTap: () => handleSelectedClub(club, context));
                        })),
                  );
                },
              ),
            ]),
          );
        });
  }

  handleSelectedClub(Club club, BuildContext context) {
    context.push('/${ClubOverview.route}/${club.id}');
  }
}
