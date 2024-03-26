import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class PersonEdit extends ConsumerStatefulWidget {
  final Organization initialOrganization;
  final Person? person;

  const PersonEdit({this.person, required this.initialOrganization, super.key});
}

abstract class PersonEditState<T extends PersonEdit> extends ConsumerState<T> implements AbstractEditState<Person> {
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
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      ListTile(
        leading: const Icon(Icons.person),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.prename,
          ),
          initialValue: widget.person?.prename,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            return null;
          },
          onSaved: (newValue) => _prename = newValue,
        ),
      ),
      ListTile(
        leading: const SizedBox(),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.surname,
          ),
          initialValue: widget.person?.surname,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            return null;
          },
          onSaved: (newValue) => _surname = newValue,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.date_range),
        title: TextFormField(
          key: ValueKey(_dateOfBirth),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
          ),
          onTap: () => showDatePicker(
            initialDatePickerMode: DatePickerMode.year,
            context: context,
            initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
            lastDate: DateTime.now(),
          ).then((value) {
            if (value != null) {
              setState(() => _dateOfBirth = value);
            }
          }),
          initialValue: _dateOfBirth?.toDateString(context),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.transgender),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<Gender>(
            isNullable: true,
            hint: localizations.gender,
            isExpanded: true,
            options: Gender.values.map((Gender value) => MapEntry(
                  value,
                  Text(value.localize(context)),
                )),
            selected: _gender,
            onChange: (newValue) => setState(() {
              _gender = newValue;
            }),
          ),
        ),
      ),
      ListTile(
        title: getDropdown<Country>(
          // TODO: replace icon with home_pin when available, also in overview
          //  https://github.com/flutter/flutter/issues/102560
          icon: const Icon(Icons.location_on),
          selectedItem: _nationality,
          label: localizations.nationality,
          context: context,
          onSaved: (Country? value) => setState(() {
            _nationality = value;
          }),
          itemAsString: (u) => '${u.nationality} (${u.isoShortName})',
          onFind: (String? filter) async {
            return (filter == null
                    ? Countries.values
                    : Countries.values.where((element) => element.nationality.contains(filter)))
                .toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: classLocale,
        id: id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
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
      person = person.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(person));
      await handleNested(person);
      navigator.pop();
    }
  }
}
