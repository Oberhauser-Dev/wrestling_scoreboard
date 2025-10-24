import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_club_affiliation_edit.dart';
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

  static void navigateTo(BuildContext context, Club club) {
    context.push('/$route/${club.id}');
  }

  final int id;
  final Club? club;

  const ClubOverview({super.key, required this.id, this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<Club>(
      id: id,
      initialData: club,
      builder: (context, club) {
        final description = InfoWidget(
          obj: club,
          editPage: ClubEdit(club: club),
          onDelete: () async => (await ref.read(dataManagerProvider)).deleteSingle<Club>(club),
          classLocale: localizations.club,
          children: [ContentItem(title: club.no ?? '-', subtitle: localizations.clubNumber, icon: Icons.tag)],
        );
        return FavoriteScaffold<Club>(
          dataObject: club,
          label: localizations.club,
          details: club.name,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.teams)),
            Tab(child: HeadingText(localizations.memberships)),
          ],
          body: TabGroup(
            items: [
              description,
              FilterableManyConsumer<Team, Club>.addOrCreate(
                context: context,
                filterObject: club,
                addPageBuilder: (context) => TeamClubAffiliationEdit(initialClub: club),
                createPageBuilder:
                    (context) => TeamEdit(
                      initialOrganization: club.organization,
                      onCreated: (team) async {
                        await (await ref.read(
                          dataManagerProvider,
                        )).createOrUpdateSingle(TeamClubAffiliation(team: team, club: club));
                      },
                    ),
                itemBuilder:
                    (context, item) => ContentItem(
                      title: item.name,
                      icon: Icons.group,
                      onTap: () => TeamOverview.navigateTo(context, item),
                    ),
              ),
              FilterableManyConsumer<Membership, Club>.addOrCreate(
                context: context,
                filterObject: club,
                addPageBuilder: (context) => MembershipEdit(initialOrganization: club.organization, initialClub: club),
                createPageBuilder: (context) => MembershipPersonEdit(initialClub: club),
                itemBuilder:
                    (context, item) => ContentItem(
                      title: '${item.info},\t${item.person.gender?.localize(context)}',
                      icon: Icons.person,
                      onTap: () => MembershipOverview.navigateTo(context, item),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
