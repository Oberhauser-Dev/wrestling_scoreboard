import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_club_affiliation_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ClubOverview extends ConsumerWidget {
  static const route = 'club';

  final int id;
  final Club? club;

  const ClubOverview({super.key, required this.id, this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Club>(
      id: id,
      initialData: club,
      builder: (context, club) {
        final description = InfoWidget(
          obj: club,
          editPage: ClubEdit(
            club: club,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Club>(club),
          classLocale: localizations.club,
          children: [
            ContentItem(
              title: club.no ?? '-',
              subtitle: localizations.clubNumber,
              icon: Icons.tag,
            )
          ],
        );
        return OverviewScaffold<Club>(
          dataObject: club,
          label: localizations.club,
          details: club.name,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.teams)),
            Tab(child: HeadingText(localizations.memberships)),
          ],
          body: TabGroup(items: [
            description,
            ManyConsumer<Team, Club>(
              filterObject: club,
              builder: (BuildContext context, List<Team> teams) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: MenuAnchor(
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamEdit(
                                initialOrganization: club.organization,
                                onCreated: (team) async {
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
                                initialClub: club,
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
                  items: teams.map((team) => SingleConsumer<Team>(
                      id: team.id,
                      initialData: team,
                      builder: (context, team) {
                        return ContentItem(
                            title: team.name, icon: Icons.group, onTap: () => handleSelectedTeam(team, context));
                      })),
                );
              },
            ),
            ManyConsumer<Membership, Club>(
              filterObject: club,
              builder: (BuildContext context, List<Membership> memberships) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembershipEdit(
                            initialClub: club,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: memberships.map(
                    (membership) => SingleConsumer<Membership>(
                      id: membership.id,
                      initialData: membership,
                      builder: (context, team) => ContentItem(
                        title: '${membership.info},\t${membership.person.gender?.localize(context)}',
                        icon: Icons.person,
                        onTap: () => handleSelectedMembership(membership, context),
                      ),
                    ),
                  ),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  handleSelectedTeam(Team team, BuildContext context) {
    context.push('/${TeamOverview.route}/${team.id}');
  }

  handleSelectedMembership(Membership membership, BuildContext context) {
    context.push('/${MembershipOverview.route}/${membership.id}');
  }
}
