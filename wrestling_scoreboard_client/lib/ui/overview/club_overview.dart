import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/exception.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_client/ui/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_overview.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ClubOverview extends StatelessWidget {
  static const route = 'club';

  final int id;
  final Club? club;

  const ClubOverview({super.key, required this.id, this.club});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Club>(
      id: id,
      initialData: club,
      builder: (context, data) {
        if (data == null) return ExceptionWidget(localizations.notFoundException);
        final description = InfoWidget(
          obj: data,
          editPage: ClubEdit(
            club: data,
          ),
          onDelete: () => dataProvider.deleteSingle<Club>(data),
          classLocale: localizations.club,
          children: [
            ContentItem(
              title: data.no ?? '-',
              subtitle: localizations.clubNumber,
              icon: Icons.tag,
            )
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: localizations.club, details: data.name),
          ),
          body: GroupedList(items: [
            description,
            ManyConsumer<Team, Club>(
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
                      builder: (context, team) {
                        if (team == null) return ExceptionWidget(localizations.notFoundException);
                        return ContentItem(
                            title: team.name, icon: Icons.group, onTap: () => handleSelectedTeam(team, context));
                      })),
                );
              },
            ),
            ManyConsumer<Membership, Club>(
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
    context.push('/${TeamOverview.route}/${team.id}');
  }

  handleSelectedMembership(Membership membership, BuildContext context) {
    context.push('/${MembershipOverview.route}/${membership.id}');
  }
}
