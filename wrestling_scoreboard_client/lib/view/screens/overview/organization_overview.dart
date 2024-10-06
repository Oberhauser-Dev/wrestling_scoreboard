import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/organization_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationOverview extends ConsumerWidget {
  static const route = 'organization';

  final int id;
  final Organization? organization;

  const OrganizationOverview({super.key, required this.id, this.organization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Organization>(
      id: id,
      initialData: organization,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: OrganizationEdit(
            organization: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Organization>(data),
          classLocale: localizations.organization,
          children: [
            ContentItem(
              title: data.name,
              subtitle: localizations.name,
              icon: Icons.description,
            ),
            ContentItem(
              title: data.abbreviation ?? '-',
              subtitle: localizations.abbreviation,
              icon: Icons.short_text,
            ),
            ContentItem(
              title: data.parent?.name ?? '-',
              subtitle: localizations.umbrellaOrganization,
              icon: Icons.corporate_fare,
            ),
            ContentItem(
              title: data.apiProvider?.name ?? '-',
              subtitle: localizations.apiProvider,
              icon: Icons.api,
            ),
            ContentItem(
              title: data.reportProvider?.name ?? '-',
              subtitle: localizations.reportProvider,
              icon: Icons.description,
            ),
          ],
        );
        return OverviewScaffold<Organization>(
          dataObject: data,
          label: localizations.organization,
          details: data.name,
          actions: [OrganizationImportAction(id: id, orgId: id, importType: OrganizationImportType.organization)],
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            Tab(child: HeadingText(localizations.organizations)),
            Tab(child: HeadingText(localizations.divisions)),
            Tab(child: HeadingText(localizations.clubs)),
            Tab(child: HeadingText(localizations.competitions))
          ],
          body: TabGroup(items: [
            description,
            ManyConsumer<Organization, Organization>(
              filterObject: data,
              builder: (BuildContext context, List<Organization> childOrganizations) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrganizationEdit(
                            initialParent: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: childOrganizations.map(
                    (e) => SingleConsumer<Organization>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.fullname,
                            icon: Icons.inventory,
                            onTap: () => handleSelectedChildOrganization(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            ManyConsumer<Division, Organization>(
              filterObject: data,
              builder: (BuildContext context, List<Division> divisions) {
                divisions.sort((a, b) {
                  final comparison = b.startDate.compareTo(a.startDate);
                  if (comparison != 0) return comparison;
                  return a.name.compareTo(b.name);
                });
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DivisionEdit(
                            initialOrganization: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: divisions.map(
                    (e) => SingleConsumer<Division>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: '${data.fullname}, ${data.startDate.year}',
                            icon: Icons.inventory,
                            onTap: () => handleSelectedDivision(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            ManyConsumer<Club, Organization>(
              filterObject: data,
              builder: (BuildContext context, List<Club> clubs) {
                clubs.sort((a, b) => a.name.compareTo(b.name));
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClubEdit(
                            initialOrganization: data,
                          ),
                        ),
                      ),
                    ),
                  ),
                  items: clubs.map(
                    (e) => SingleConsumer<Club>(
                        id: e.id,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.name,
                            icon: Icons.foundation,
                            onTap: () => handleSelectedClub(data, context),
                          );
                        }),
                  ),
                );
              },
            ),
            ManyConsumer<Competition, Organization>(
              filterObject: data,
              builder: (BuildContext context, List<Competition> competitions) {
                return GroupedList(
                  header: HeadingItem(
                    trailing: RestrictedAddButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CompetitionEdit(initialOrganization: data),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  items: competitions.map((e) {
                    return SingleConsumer<Competition>(
                      id: e.id,
                      initialData: e,
                      builder: (context, data) {
                        return ContentItem(
                            title: e.name,
                            icon: Icons.leaderboard,
                            onTap: () => handleSelectedCompetition(data, context));
                      },
                    );
                  }),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  handleSelectedChildOrganization(Organization organization, BuildContext context) {
    context.push('/${OrganizationOverview.route}/${organization.id}');
  }

  handleSelectedDivision(Division division, BuildContext context) {
    context.push('/${DivisionOverview.route}/${division.id}');
  }

  handleSelectedClub(Club club, BuildContext context) {
    context.push('/${ClubOverview.route}/${club.id}');
  }

  handleSelectedCompetition(Competition competition, BuildContext context) {
    // context.push('/${CompetitionOverview.route}/${competition.id}');
  }
}
