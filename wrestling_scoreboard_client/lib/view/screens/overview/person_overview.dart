import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class AbstractPersonOverview extends ConsumerWidget implements AbstractOverview<Person> {
  const AbstractPersonOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    List<Widget>? tiles,
    List<Widget> actions = const [],
    Map<Tab, Widget> Function(Person data)? buildRelations,
    required int dataId,
    Person? initialData,
  }) {
    final localizations = AppLocalizations.of(context)!;
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
        return OverviewScaffold<Person>(
          dataObject: person,
          label: classLocale,
          details: person.fullName,
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

class PersonOverview extends AbstractPersonOverview {
  static const route = 'person';

  final int id;
  final Person? person;
  final Organization? initialOrganization;

  const PersonOverview({required this.id, this.initialOrganization, this.person, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return buildOverview(
      context,
      ref,
      dataId: id,
      initialData: person,
      classLocale: localizations.person,
      editPage: PersonEdit(
        person: person,
        initialOrganization: person?.organization ?? initialOrganization,
      ),
      onDelete: () async {},
      buildRelations: (Person person) => {
        Tab(child: HeadingText(localizations.memberships)): ManyConsumer<Membership, Person>(
          filterObject: person,
          builder: (BuildContext context, List<Membership> memberships) {
            return GroupedList(
              header: HeadingItem(
                trailing: RestrictedAddButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembershipEdit(
                        initialPerson: person,
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
      },
    );
  }

  handleSelectedMembership(Membership membership, BuildContext context) {
    context.push('/${MembershipOverview.route}/${membership.id}');
  }
}
