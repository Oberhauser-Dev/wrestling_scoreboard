import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/membership_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/membership_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class AbstractPersonOverview<T extends DataObject> extends ConsumerWidget
    implements AbstractOverview<Person, T> {
  const AbstractPersonOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    String? details,
    required Widget editPage,
    required VoidCallback onDelete,
    List<Widget>? tiles,
    List<Widget> actions = const [],
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
            onDelete();
            (await ref.read(dataManagerNotifierProvider)).deleteSingle<Person>(person);
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
            ContentItem(
              title: person.fullName,
              subtitle: localizations.name,
              icon: Icons.person,
            ),
            ContentItem(
              title: person.age?.toString() ?? '-',
              subtitle: localizations.age,
              icon: Icons.event,
            ),
            ContentItem(
              title: person.birthDate?.toDateString(context) ?? '-',
              subtitle: localizations.dateOfBirth,
              icon: Icons.cake,
            ),
            ContentItem(
              title: person.gender?.localize(context) ?? '-',
              subtitle: localizations.gender,
              icon: Icons.description,
            ),
            ContentItem(
              title: person.nationality == null
                  ? '-'
                  : '${person.nationality?.nationality} (${person.nationality?.isoShortName})',
              subtitle: localizations.nationality,
              icon: Icons.location_on,
            ),
          ],
        );
        final relations = buildRelations != null ? buildRelations(person) : {};
        return FavoriteScaffold<T>(
          dataObject: subClassData,
          label: classLocale,
          details: details ?? person.fullName,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
            ...relations.keys,
          ],
          actions: actions,
          body: TabGroup(items: [
            description,
            ...relations.values,
          ]),
        );
      },
    );
  }
}

class PersonOverview extends AbstractPersonOverview<Person> {
  static const route = 'person';

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
            editPage: PersonEdit(
              person: person,
              initialOrganization: person.organization ?? initialOrganization,
            ),
            onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<Person>(person),
            buildRelations: (Person person) => {
              Tab(child: HeadingText(localizations.memberships)): FilterableManyConsumer<Membership, Person>.edit(
                context: context,
                editPageBuilder: (context) => MembershipEdit(initialPerson: person),
                filterObject: person,
                itemBuilder: (context, membership) => ContentItem(
                  title: '${membership.info},\t${membership.person.gender?.localize(context)}',
                  icon: Icons.person,
                  onTap: () => handleSelectedMembership(membership, context),
                ),
              ),
            },
          );
        });
  }

  handleSelectedMembership(Membership membership, BuildContext context) {
    context.push('/${MembershipOverview.route}/${membership.id}');
  }
}

Future<void> mergePersonDialog(BuildContext context, WidgetRef ref, {required Person person}) async {
  await catchAsync(context, () async {
    final personToMergeWith = await showDialog(
      context: context,
      builder: (context) => _MergePersonDialog(organization: person.organization!, pivotPerson: person),
    );
    if (personToMergeWith != null && context.mounted) {
      final dataManager = await ref.read(dataManagerNotifierProvider);
      // Use current person as first item, so it will be kept, as the current route needs to stay consistent
      await dataManager.mergeObjects<Person>([person, personToMergeWith]);
    }
  });
}

Future<void> mergePersonsDialog(BuildContext context, WidgetRef ref, {required List<Person> persons}) async {
  await catchAsync(context, () async {
    final confirmed = await showOkCancelDialog(
      context: context,
      child: Text('Are you sure to merge instances of "${persons.first.fullName}"?\n'
          'This action changes all dependent dependent data, such as Memberships.'),
    );
    if (confirmed && context.mounted) {
      final dataManager = await ref.read(dataManagerNotifierProvider);
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
    child: const Text('Are you sure to merge instances of ALL persons?\n'
        'This action changes all dependent dependent data, such as Memberships.'),
  );
  if (confirmed) {
    final dataManager = await ref.read(dataManagerNotifierProvider);
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
    _availablePersonsFuture = (() async {
      final availablePersons = await (await ref.read(dataManagerNotifierProvider)).readMany<Person, Organization>(
        filterObject: widget.organization,
      );
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
                  onChanged: (Person? value) => setState(() {
                    _mergePerson = value;
                  }),
                  itemAsString: (u) => '${u.fullName}, ${u.birthDate?.toDateString(context)}',
                  asyncItems: (String filter) async {
                    return data;
                  },
                ),
              ],
            );
          }),
    );
  }
}
