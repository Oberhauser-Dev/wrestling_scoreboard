import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/gender.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/components/info.dart';
import 'package:wrestling_scoreboard/ui/overview/common.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

abstract class PersonOverview extends StatelessWidget implements AbstractOverview {
  final Person _filterObject;

  const PersonOverview({Key? key, required Person filterObject})
      : _filterObject = filterObject,
        super(key: key);

  @override
  Widget buildOverview(
    BuildContext context, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return SingleConsumer<Person>(
      id: _filterObject.id!,
      initialData: _filterObject,
      builder: (context, person) {
        final description = InfoWidget(
          obj: person!,
          editPage: editPage,
          onDelete: () {
            onDelete();
            dataProvider.deleteSingle(person);
          },
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
          classLocale: classLocale,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(person.fullName),
          ),
          body: GroupedList(items: [
            description,
          ]),
        );
      },
    );
  }
}
