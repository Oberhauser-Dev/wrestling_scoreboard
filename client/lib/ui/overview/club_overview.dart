import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/edit/club_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/membership_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/team_edit.dart';
import 'package:wrestling_scoreboard/ui/overview/membership_overview.dart';
import 'package:wrestling_scoreboard/ui/overview/team_overview.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class ClubOverview extends StatelessWidget {
  final Club filterObject;

  const ClubOverview({Key? key, required this.filterObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Club>(
      id: filterObject.id!,
      initialData: filterObject,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data!,
          editPage: ClubEdit(
            club: data,
          ),
          onDelete: () => dataProvider.deleteSingle(data),
          children: [
            ContentItem(
              title: data.no ?? '-',
              subtitle: localizations.clubNumber,
              icon: Icons.tag,
            )
          ],
          classLocale: localizations.club,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(data.name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<Team>(
              filterObject: data,
              builder: (BuildContext context, List<Team> teams) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.teams,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamEdit(
                            initialClub: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: teams.map((team) => SingleConsumer<Team>(
                      id: team.id,
                      initialData: team,
                      builder: (context, team) => ContentItem(
                          title: team!.name, icon: Icons.group, onTap: () => handleSelectedTeam(team, context)))),
                );
              },
            ),
            ManyConsumer<Membership>(
              filterObject: data,
              builder: (BuildContext context, List<Membership> memberships) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.memberships,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembershipEdit(
                            initialClub: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: memberships.map((membership) => SingleConsumer<Membership>(
                      id: membership.id,
                      initialData: membership,
                      builder: (context, team) => ContentItem(
                          title: membership.person.fullName,
                          icon: Icons.person,
                          onTap: () => handleSelectedMembership(membership, context)))),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  handleSelectedTeam(Team team, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamOverview(
          filterObject: team,
        ),
      ),
    );
  }

  handleSelectedMembership(Membership membership, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MembershipOverview(
          filterObject: membership,
        ),
      ),
    );
  }
}
