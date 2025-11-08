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
    final today = MockableDateTime.now().copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);
    return SingleConsumer<Organization>(
      id: id,
      initialData: organization,
      builder: (context, organization) {
        final description = InfoWidget(
          obj: organization,
          editPage: OrganizationEdit(organization: organization),
          onDelete: () async => (await ref.read(dataManagerProvider)).deleteSingle<Organization>(organization),
          classLocale: localizations.organization,
          children: [
            ContentItem(title: organization.name, subtitle: localizations.name, icon: Icons.description),
            ContentItem(
              title: organization.abbreviation ?? '-',
              subtitle: localizations.abbreviation,
              icon: Icons.short_text,
            ),
            ContentItem(
              title: organization.parent?.name ?? '-',
              subtitle: localizations.umbrellaOrganization,
              icon: Icons.corporate_fare,
              onTap:
                  organization.parent == null
                      ? null
                      : () => OrganizationOverview.navigateTo(context, organization.parent!),
            ),
            ContentItem(
              title: organization.apiProvider?.name ?? '-',
              subtitle: localizations.apiProvider,
              icon: Icons.api,
            ),
            ContentItem(
              title: organization.reportProvider?.name ?? '-',
              subtitle: localizations.reportProvider,
              icon: Icons.description,
            ),
          ],
        );
        return ConditionalOrganizationImportActionBuilder(
          id: id,
          organization: organization,
          importType: OrganizationImportType.organization,
          builder: (context, importAction) {
            return FavoriteScaffold<Organization>(
              dataObject: organization,
              label: localizations.organization,
              details: organization.name,
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
                  FilterableManyConsumer<Division, Organization>.add(
                    context: context,
                    filterObject: organization,
                    addPageBuilder: (context) => DivisionEdit(initialOrganization: organization),
                    getInitialIndex: (data) => data.indexWhere((division) => division.endDate.compareTo(today) >= 0),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: '${item.fullname}, ${item.startDate.year}',
                          icon: Icons.inventory,
                          isDisabled: item.endDate.isBefore(today),
                          onTap: () => DivisionOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Club, Organization>.add(
                    context: context,
                    filterObject: organization,
                    addPageBuilder: (context) => ClubEdit(initialOrganization: organization),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.name,
                          icon: Icons.foundation,
                          onTap: () => ClubOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Competition, Organization>.add(
                    context: context,
                    filterObject: organization,
                    addPageBuilder: (context) => CompetitionEdit(initialOrganization: organization),
                    getInitialIndex: (data) => data.indexWhere((competition) => competition.date.compareTo(today) >= 0),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.name,
                          icon: Icons.leaderboard,
                          isDisabled: item.date.isBefore(today),
                          onTap: () => CompetitionOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<AgeCategory, Organization>.add(
                    context: context,
                    filterObject: organization,
                    addPageBuilder: (context) => AgeCategoryEdit(initialOrganization: organization),
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: '${item.name} (${item.minAge} - ${item.maxAge})',
                          icon: Icons.school,
                          onTap: () => AgeCategoryOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Person, Organization>.add(
                    context: context,
                    filterObject: organization,
                    addPageBuilder: (context) => PersonEdit(initialOrganization: organization),
                    prependBuilder: (context, persons) {
                      final duplicatePersons =
                          persons
                              .groupListsBy((element) => element.fullName)
                              .entries
                              .where((entry) => entry.value.length > 1)
                              .toList();
                      // Remove entries which all have a different birthdate.
                      duplicatePersons.removeWhere(
                        // nonNulls: ensures that persons with `null` birthdate can be merged
                        // toSet: ensures that the birth dates are distinct
                        (entry) => entry.value.map((p) => p.birthDate).nonNulls.toSet().length == entry.value.length,
                      );
                      return duplicatePersons.isEmpty ? null : PersonsMergeCard(duplicatePersonsMap: duplicatePersons);
                    },
                    itemBuilder:
                        (context, item) => ContentItem(
                          title: item.fullName,
                          icon: Icons.person,
                          onTap: () => PersonOverview.navigateTo(context, item),
                        ),
                  ),
                  FilterableManyConsumer<Organization, Organization>.add(
                    context: context,
                    addPageBuilder: (context) => OrganizationEdit(initialParent: organization),
                    filterObject: organization,
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
