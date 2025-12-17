import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/localization/person_role.dart';
import 'package:wrestling_scoreboard_client/localization/team_match.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_person_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/team_match/team_match_person_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/image.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

mixin AbstractPersonOverview<T extends DataObject> implements AbstractOverview<Person, T> {
  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    String? details,
    required Widget editPage,
    required VoidCallback? onDelete,
    List<Widget>? tiles,
    List<DefaultResponsiveScaffoldActionItem> actions = const [],
    Map<Tab, Widget> Function(Person data)? buildRelations,
    required int dataId,
    Person? initialData,
    required T subClassData,
  }) {
    final localizations = context.l10n;
    return SingleConsumer<Person>(
      id: dataId,
      initialData: initialData,
      builder: (context, person) {
        final description = InfoWidget(
          obj: person,
          editPage: editPage,
          onDelete: () async {
            if (onDelete != null) onDelete();
            (await ref.read(dataManagerProvider)).deleteSingle<Person>(person);
          },
          classLocale: classLocale,
          actions: [
            Restricted(
              privilege: UserPrivilege.admin,
              child: IconButton(
                tooltip: localizations.mergeObjectData,
                onPressed: () => mergePersonDialog(context, ref, person: person),
                icon: const Icon(Icons.merge),
              ),
            ),
          ],
          children: [
            ...?tiles,
            if (person.imageUri != null)
              ContentItem(
                title: person.imageUri!,
                subtitle: localizations.image,
                icon: CircularImage(imageUri: person.imageUri!),
              ),
            ContentItem(
              title: person.fullName,
              subtitle: localizations.name,
              icon: person.imageUri == null ? Icon(Icons.person) : CircularImage(imageUri: person.imageUri!),
            ),
            ContentItem.icon(title: person.age?.toString() ?? '-', subtitle: localizations.age, iconData: Icons.event),
            ContentItem.icon(
              title: person.birthDate?.toDateString(context) ?? '-',
              subtitle: localizations.dateOfBirth,
              iconData: Icons.cake,
            ),
            ContentItem.icon(
              title: person.gender?.localize(context) ?? '-',
              subtitle: localizations.gender,
              iconData: Icons.description,
            ),
            ContentItem.icon(
              title:
                  person.nationality == null
                      ? '-'
                      : '${person.nationality?.nationality} (${person.nationality?.isoShortName})',
              subtitle: localizations.nationality,
              iconData: Icons.location_on,
            ),
          ],
        );
        final relations = buildRelations != null ? buildRelations(person) : {};
        return FavoriteScaffold<T>(
          dataObject: subClassData,
          label: classLocale,
          details: details ?? person.fullName,
          tabs: [Tab(child: HeadingText(localizations.info)), ...relations.keys],
          actions: actions,
          body: TabGroup(items: [description, ...relations.values]),
        );
      },
    );
  }
}

class PersonOverview extends ConsumerWidget with AbstractPersonOverview<Person> {
  static const route = 'person';

  static void navigateTo(BuildContext context, Person dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final Person? person;
  final Organization? initialOrganization;

  const PersonOverview({required this.id, this.initialOrganization, this.person, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<Person>(
      id: id,
      initialData: person,
      builder: (context, person) {
        return buildOverview(
          context,
          ref,
          dataId: id,
          initialData: person,
          subClassData: person,
          classLocale: localizations.person,
          editPage: PersonEdit(person: person, initialOrganization: person.organization ?? initialOrganization),
          // Already covered in parent
          onDelete: null,
          buildRelations:
              (Person person) => {
                Tab(child: HeadingText(localizations.memberships)): FilterableManyConsumer<Membership, Person>.add(
                  context: context,
                  addPageBuilder:
                      (context) => MembershipEdit(initialOrganization: person.organization!, initialPerson: person),
                  filterObject: person,
                  itemBuilder:
                      (context, membership) => ContentItem(
                        title: '${membership.info},\t${membership.person.gender?.localize(context)}',
                        icon: person.imageUri == null ? Icon(Icons.person) : CircularImage(imageUri: person.imageUri!),
                        onTap: () => MembershipOverview.navigateTo(context, membership),
                      ),
                ),
                Tab(
                  child: HeadingText('${localizations.officials} (${localizations.competition})'),
                ): FilterableManyConsumer<CompetitionPerson, Person>(
                  filterObject: person,
                  itemBuilder:
                      (context, competitionPerson) => ContentItem.icon(
                        title: '${competitionPerson.competition.name} | ${competitionPerson.role.localize(context)}',
                        iconData: competitionPerson.role.icon,
                        onTap: () => CompetitionPersonOverview.navigateTo(context, competitionPerson),
                      ),
                ),
                Tab(
                  child: HeadingText('${localizations.officials} (${localizations.match})'),
                ): FilterableManyConsumer<TeamMatchPerson, Person>(
                  filterObject: person,
                  itemBuilder:
                      (context, teamMatchPerson) => ContentItem.icon(
                        title:
                            '${teamMatchPerson.teamMatch.localize(context)} | ${teamMatchPerson.role.localize(context)}',
                        iconData: teamMatchPerson.role.icon,
                        onTap: () => TeamMatchPersonOverview.navigateTo(context, teamMatchPerson),
                      ),
                ),
              },
        );
      },
    );
  }
}

Future<void> mergePersonDialog(BuildContext context, WidgetRef ref, {required Person person}) async {
  await catchAsync(context, () async {
    final personToMergeWith = await showDialog(
      context: context,
      builder: (context) => _MergePersonDialog(organization: person.organization!, pivotPerson: person),
    );
    if (personToMergeWith != null && context.mounted) {
      final dataManager = await ref.read(dataManagerProvider);
      // Use current person as first item, so it will be kept, as the current route needs to stay consistent
      await dataManager.mergeObjects<Person>([person, personToMergeWith]);
    }
  });
}

Future<void> mergePersonsDialog(BuildContext context, WidgetRef ref, {required List<Person> persons}) async {
  await catchAsync(context, () async {
    final confirmed = await showOkCancelDialog(
      context: context,
      child: Text(
        'Are you sure to merge instances of "${persons.first.fullName}" (pivot: ${persons.first.id})?\n'
        'This action changes all dependent data, such as Memberships.',
      ),
    );
    if (confirmed && context.mounted) {
      final dataManager = await ref.read(dataManagerProvider);
      await dataManager.mergeObjects<Person>(persons);
    }
  });
}

Future<void> mergeAllPersonsDialog(
  BuildContext context,
  WidgetRef ref, {
  required Iterable<List<Person>> allPersons,
}) async {
  final confirmed = await showOkCancelDialog(
    context: context,
    child: const Text(
      'Are you sure to merge instances of ALL persons?\n'
      'This action changes all dependent dependent data, such as Memberships.',
    ),
  );
  if (confirmed) {
    final dataManager = await ref.read(dataManagerProvider);
    for (final persons in allPersons) {
      if (context.mounted) {
        await catchAsync(context, () async {
          await dataManager.mergeObjects<Person>(persons);
        });
      }
    }
  }
}

class _MergePersonDialog extends ConsumerStatefulWidget {
  final Organization organization;
  final Person pivotPerson;

  const _MergePersonDialog({required this.organization, required this.pivotPerson});

  @override
  ConsumerState<_MergePersonDialog> createState() => _MergePersonDialogState();
}

class _MergePersonDialogState extends ConsumerState<_MergePersonDialog> {
  late Future<List<Person>> _availablePersonsFuture;
  Person? _mergePerson;

  @override
  void initState() {
    _availablePersonsFuture =
        (() async {
          final availablePersons = await (await ref.read(
            dataManagerProvider,
          )).readMany<Person, Organization>(filterObject: widget.organization);
          availablePersons.remove(widget.pivotPerson);
          setState(() {
            _mergePerson ??= availablePersons.where((ap) => ap.fullName == widget.pivotPerson.fullName).firstOrNull;
          });
          return availablePersons;
        })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return OkCancelDialog<Person?>(
      getResult: () => _mergePerson,
      child: LoadingBuilder(
        future: _availablePersonsFuture,
        builder: (context, data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.mergeObjectData),
              SearchableDropdown<Person>(
                icon: const Icon(Icons.person),
                selectedItem: _mergePerson,
                label: localizations.person,
                context: context,
                onChanged:
                    (Person? value) => setState(() {
                      _mergePerson = value;
                    }),
                itemAsString: (u) => '${u.fullName}, ${u.birthDate?.toDateString(context)}',
                asyncItems: (String filter) async {
                  return data;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class PersonsMergeCard extends ConsumerWidget {
  final Iterable<MapEntry<String, List<Person>>> duplicatePersonsMap;

  const PersonsMergeCard({super.key, required this.duplicatePersonsMap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Restricted(
      privilege: UserPrivilege.admin,
      child: PaddedCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning),
            const Text(
              'Following persons have the same name, are they duplicates?\n'
              'You can reorder the persons before merging, so the person on the top is kept and missing attributes are taken from the ones below.',
            ),
            ...duplicatePersonsMap.map(
              (similarPersons) => ReorderablePersonExpansionTile(
                // Key is needed to ensure the tile is updated when the list shortens
                key: ValueKey(similarPersons.key),
                title: similarPersons.key,
                persons: similarPersons.value,
              ),
            ),
            // Disable merge all dialog for now, as the order is not considered from the expandable tile.
            // Also it might is unsage to just merge all without reviewing individually.
            // TextButton.icon(
            //   onPressed: () => mergeAllPersonsDialog(context, ref, allPersons: duplicatePersonsMap.map((e) => e.value)),
            //   icon: const Icon(Icons.merge),
            //   label: const Text('Merge ALL'),
            // ),
          ],
        ),
      ),
    );
  }
}

class ReorderablePersonExpansionTile extends ConsumerStatefulWidget {
  final String title;
  final List<Person> persons;

  const ReorderablePersonExpansionTile({super.key, required this.title, required this.persons});

  @override
  ConsumerState<ReorderablePersonExpansionTile> createState() => _ReorderablePersonExpansionTileState();
}

class _ReorderablePersonExpansionTileState extends ConsumerState<ReorderablePersonExpansionTile> {
  late List<Person> persons = widget.persons;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return ExpansionTile(
      title: Text('${widget.title} (${persons.length})'),
      trailing: IconButton(
        tooltip: localizations.mergeObjectData,
        onPressed: () => mergePersonsDialog(context, ref, persons: persons),
        icon: const Icon(Icons.merge),
      ),
      children: [
        ReorderableListView(
          shrinkWrap: true,
          children:
              persons
                  .map(
                    (person) => ListTile(
                      key: ValueKey(person.id),
                      title: Text(
                        '${person.fullName}, '
                        '${person.birthDate?.toDateString(context)}, '
                        '${person.gender?.localize(context)}, '
                        '(ID: ${person.id}, '
                        'orgID: ${person.orgSyncId})',
                      ),
                      onTap: () => PersonOverview.navigateTo(context, person),
                    ),
                  )
                  .toList(),
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            setState(() {
              final item = persons.removeAt(oldIndex);
              persons.insert(newIndex, item);
            });
          },
        ),
      ],
    );
  }
}
