import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class AbstractPersonEdit extends ConsumerStatefulWidget {
  final Organization? initialOrganization;
  final Person? person;
  final Future<void> Function(Person person)? onCreated;

  const AbstractPersonEdit({this.person, required this.initialOrganization, this.onCreated, super.key});
}

abstract class AbstractPersonEditState<T extends AbstractPersonEdit> extends ConsumerState<T>
    implements AbstractEditState<Person> {
  final _formKey = GlobalKey<FormState>();

  String? _prename;
  String? _surname;
  DateTime? _dateOfBirth;
  Gender? _gender;
  Country? _nationality;

  @override
  void initState() {
    _dateOfBirth = widget.person?.birthDate;
    _gender = widget.person?.gender;
    _nationality = widget.person?.nationality;
    super.initState();
  }

  @override
  Widget buildEdit(
    BuildContext context, {
    required String classLocale,
    required int? id,
    required List<Widget> fields,
  }) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      CustomTextInput(
        iconData: Icons.person,
        label: localizations.prename,
        initialValue: widget.person?.prename,
        isMandatory: true,
        onSaved: (value) => _prename = value,
      ),
      CustomTextInput(
        label: localizations.surname,
        initialValue: widget.person?.surname,
        isMandatory: true,
        onSaved: (value) => _surname = value,
      ),
      DateInput(
        iconData: Icons.event,
        label: localizations.date,
        initialValue: _dateOfBirth,
        initialDatePickerMode: DatePickerMode.year,
        isMandatory: false,
        minValue: DateTime.now().subtract(const Duration(days: 365 * 100)),
        maxValue: DateTime.now(),
        onSaved: (newValue) {
          _dateOfBirth = newValue;
        },
      ),
      ListTile(
        leading: const Icon(Icons.transgender),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<Gender>(
            isNullable: true,
            label: localizations.gender,
            isExpanded: true,
            options: Gender.values.map((Gender value) => MapEntry(value, Text(value.localize(context)))),
            selected: _gender,
            onSaved: (newValue) => _gender = newValue,
          ),
        ),
      ),
      ListTile(
        title: SearchableDropdown<Country>(
          // TODO: replace icon with home_pin when available, also in overview
          //  https://github.com/flutter/flutter/issues/102560
          icon: const Icon(Icons.location_on),
          selectedItem: _nationality,
          label: localizations.nationality,
          context: context,
          onSaved:
              (Country? value) => setState(() {
                _nationality = value;
              }),
          itemAsString: (u) => '${u.nationality} (${u.isoShortName})',
          asyncItems: (String filter) async {
            return Countries.values;
          },
          onFilter: (Country item, String filter) {
            return (item.nationality ?? '').toLowerCase().contains(filter);
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(typeLocalization: classLocale, id: id, onSubmit: () => handleSubmit(navigator), items: items),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var person = Person(
        id: widget.person?.id,
        orgSyncId: widget.person?.orgSyncId,
        organization: widget.person?.organization ?? widget.initialOrganization,
        prename: _prename!,
        surname: _surname!,
        birthDate: _dateOfBirth,
        gender: _gender,
        nationality: _nationality,
      );
      person = person.copyWithId(await (await ref.read(dataManagerProvider)).createOrUpdateSingle(person));
      await handleNested(person);
      await widget.onCreated?.call(person);
      navigator.pop();
    }
  }
}

class PersonEdit extends AbstractPersonEdit {
  const PersonEdit({super.person, super.key, required super.initialOrganization, super.onCreated});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PersonEditState();
}

class PersonEditState extends AbstractPersonEditState<PersonEdit> {
  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(context, id: widget.person?.id, classLocale: localizations.person, fields: []);
  }

  @override
  Future<void> handleNested(person) async {}
}
