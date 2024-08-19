import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_overview.dart';
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
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: ClubEdit(
            club: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Club>(data),
          classLocale: localizations.club,
          children: [
            ContentItem(
              title: data.no ?? '-',
              subtitle: localizations.clubNumber,
              icon: Icons.tag,
            )
          ],
        );
        return OverviewScaffold<Club>(
          dataObject: data,
          label: localizations.club,
          details: data.name,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.teams)),
            Tab(child: HeadingText(localizations.memberships)),
          ],
          // TODO
          body: TabGroup(items: [
            description,
            ManyConsumer<Team, Club>(
              filterObject: data,
              builder: (BuildContext context, List<Team> teams) {
                return GroupedList(
                  header: HeadingItem(
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
                        return ContentItem(
                            title: team.name, icon: Icons.group, onTap: () => handleSelectedTeam(team, context));
                      })),
                );
              },
            ),
            ManyConsumer<Membership, Club>(
              filterObject: data,
              builder: (BuildContext context, List<Membership> memberships) {
                return GroupedList(
                  header: HeadingItem(
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
