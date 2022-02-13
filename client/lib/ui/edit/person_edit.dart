import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/gender.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/ui/edit/common.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

abstract class PersonEdit extends StatefulWidget {
  final Person? person;

  const PersonEdit({this.person, Key? key}) : super(key: key);
}

abstract class PersonEditState<T extends PersonEdit> extends State<T> implements AbstractEditState<Person> {
  final _formKey = GlobalKey<FormState>();

  String? _prename;
  String? _surname;
  DateTime? _dateOfBirth;
  Gender? _gender;

  @override
  void initState() {
    _dateOfBirth = widget.person?.birthDate;
    _gender = widget.person?.gender;
    super.initState();
  }

  @override
  Widget buildEdit(BuildContext context, {required String? classLocale, required List<Widget> fields}) {
    final localizations = AppLocalizations.of(context)!;

    final items = [
      ...fields,
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.prename,
            icon: const Icon(Icons.person),
          ),
          initialValue: widget.person?.prename,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
          },
          onSaved: (newValue) => _prename = newValue,
        ),
      ),
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.surname,
            icon: const SizedBox(),
          ),
          initialValue: widget.person?.surname,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
          },
          onSaved: (newValue) => _surname = newValue,
        ),
      ),
      ListTile(
        title: TextFormField(
          key: ValueKey(_dateOfBirth),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
            icon: const Icon(Icons.date_range),
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
          child: DropdownButton<Gender>(
            hint: Text(localizations.gender),
            isExpanded: true,
            items: Gender.values.map((Gender value) {
              return DropdownMenuItem<Gender>(
                value: value,
                child: Text(genderToString(value, context)),
              );
            }).toList(),
            value: _gender,
            onChanged: (newValue) => setState(() {
              _gender = newValue!;
            }),
          ),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: classLocale ?? localizations.person,
        id: widget.person?.id,
        onSubmit: () => handleSubmit(context),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final person = Person(
        id: widget.person?.id,
        prename: _prename!,
        surname: _surname!,
        birthDate: _dateOfBirth,
        gender: _gender,
      );
      person.id = await dataProvider.createOrUpdateSingle(person);
      await handleNested(person);
      Navigator.of(context).pop();
    }
  }
}
