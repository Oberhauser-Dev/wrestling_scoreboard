import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/age_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/competition/competition_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/organization_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/team_match/division_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/age_category_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/shared/actions.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/division_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class OrganizationOverview extends ConsumerWidget {
  static const route = 'organization';

  static void navigateTo(BuildContext context, Organization organization) {
    context.push('/$route/${organization.id}');
  }

  final int id;
  final Organization? organization;

  const OrganizationOverview({super.key, required this.id, this.organization});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<Organization>(
      id: id,
      initialData: organization,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: OrganizationEdit(organization: data),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Organization>(data),
          classLocale: localizations.organization,
          children: [
            ContentItem(title: data.name, subtitle: localizations.name, icon: Icons.description),
            ContentItem(title: data.abbreviation ?? '-', subtitle: localizations.abbreviation, icon: Icons.short_text),
            ContentItem(
              title: data.parent?.name ?? '-',
              subtitle: localizations.umbrellaOrganization,
              icon: Icons.corporate_fare,
            ),
            ContentItem(title: data.apiProvider?.name ?? '-', subtitle: localizations.apiProvider, icon: Icons.api),
            ContentItem(
              title: data.reportProvider?.name ?? '-',
              subtitle: localizations.reportProvider,
              icon: Icons.description,
            ),
          ],
        );
        return ConditionalOrganizationImportActionBuilder(
          id: id,
          organization: data,
          importType: OrganizationImportType.organization,
          builder: (context, importAction) {
            return FavoriteScaffold<Organization>(
              dataObject: data,
              label: localizations.organization,
              details: data.name,
              actions: [if (importAction != null) importAction],
              tabs: [
                Tab(child: HeadingText(localizations.info)),
                Tab(child: HeadingText(localizations.divisions)),
                Tab(child: HeadingText(localizations.clubs)),
                Tab(child: HeadingText(localizations.competitions)),
                Tab(child: HeadingText(localizations.ageCategories)),
                Tab(child: HeadingText(localizations.persons)),
                Tab(child: HeadingText('${localizations.sub}-${localizations.organizations}')),
              ],
              body: TabGroup(
                items: [
                  description,
                  FilterableManyConsumer<Division, Organization>.edit(
                    context: context,
                    filterObject: data,
                    editPageBuilder: (context) => DivisionEdit(initialOrganization: data),
                    mapData:
                        (divisions) =>
                            divisions..sort((a, b) {
                              final comparison = b.startDate.compareTo(a.startDate);
                              if (comparison != 0) return comparison;
                              return a.name.compareTo(b.name);
                            }),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: '${item.fullname}, ${item.startDate.year}',
                          icon: Icons.inventory,
                          onTap: () => DivisionOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Club, Organization>.edit(
                    context: context,
                    filterObject: data,
                    mapData: (List<Club> clubs) => clubs..sort((a, b) => a.name.compareTo(b.name)),
                    editPageBuilder: (context) => ClubEdit(initialOrganization: data),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.name,
                          icon: Icons.foundation,
                          onTap: () => ClubOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Competition, Organization>.edit(
                    context: context,
                    filterObject: data,
                    editPageBuilder: (context) => CompetitionEdit(initialOrganization: data),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.name,
                          icon: Icons.leaderboard,
                          onTap: () => CompetitionOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<AgeCategory, Organization>.edit(
                    context: context,
                    filterObject: data,
                    editPageBuilder: (context) => AgeCategoryEdit(initialOrganization: data),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: '${item.name} (${item.minAge} - ${item.maxAge})',
                          icon: Icons.school,
                          onTap: () => AgeCategoryOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Person, Organization>.edit(
                    context: context,
                    filterObject: data,
                    editPageBuilder: (context) => PersonEdit(initialOrganization: data),
                    mapData: (persons) => persons..sort((a, b) => a.fullName.compareTo(b.fullName)),
                    prependBuilder: (context, persons) {
                      final duplicatePersons = persons
                          .groupListsBy((element) => element.fullName)
                          .entries
                          .where((entry) => entry.value.length > 1);
                      return duplicatePersons.isEmpty
                          ? null
                          : Restricted(
                            privilege: UserPrivilege.admin,
                            child: PaddedCard(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning),
                                  const Text('Following persons have the same name, are they duplicates?'),
                                  ...duplicatePersons.map(
                                    (similarPersons) => ListTile(
                                      title: Text('${similarPersons.key} (${similarPersons.value.length})'),
                                      trailing: IconButton(
                                        tooltip: localizations.mergeObjectData,
                                        onPressed:
                                            () => mergePersonsDialog(context, ref, persons: similarPersons.value),
                                        icon: const Icon(Icons.merge),
                                      ),
                                      // Use most up to date entry (last) as base merge object
                                      onTap: () => PersonOverview.navigateTo(context, similarPersons.value.last),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed:
                                        () => mergeAllPersonsDialog(
                                          context,
                                          ref,
                                          allPersons: duplicatePersons.map((e) => e.value),
                                        ),
                                    icon: const Icon(Icons.merge),
                                    label: const Text('Merge ALL'),
                                  ),
                                ],
                              ),
                            ),
                          );
                    },
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.fullName,
                          icon: Icons.person,
                          onTap: () => PersonOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Organization, Organization>.edit(
                    context: context,
                    editPageBuilder: (context) => OrganizationEdit(initialParent: data),
                    filterObject: data,
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.fullname,
                          icon: Icons.inventory,
                          onTap: () => OrganizationOverview.navigateTo(context, item),
                        ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
