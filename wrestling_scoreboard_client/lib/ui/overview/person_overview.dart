import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/data/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/info.dart';
import 'package:wrestling_scoreboard_client/ui/overview/common.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class PersonOverview extends ConsumerWidget implements AbstractOverview<Person> {
  static const route = 'person';

  const PersonOverview({super.key});

  @override
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
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
          onDelete: () {
            onDelete();
            ref.read(dataManagerProvider).deleteSingle<Person>(person);
          },
          classLocale: classLocale,
          children: [
            ...tiles,
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
              title: genderToString(person.gender, context),
              subtitle: localizations.gender,
              icon: Icons.description,
            ),
          ],
        );
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(label: classLocale, details: person.fullName),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
