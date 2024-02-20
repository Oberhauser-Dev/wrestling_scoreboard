import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/gender.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class PersonEdit extends ConsumerStatefulWidget {
  final Person? person;

  const PersonEdit({this.person, super.key});
}

abstract class PersonEditState<T extends PersonEdit> extends ConsumerState<T> implements AbstractEditState<Person> {
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
          child: DropdownButton<Gender>(
            hint: Text(localizations.gender),
            isExpanded: true,
            items: Gender.values.map((Gender value) {
              return DropdownMenuItem<Gender>(
                value: value,
                child: Text(value.localize(context)),
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
        prename: _prename!,
        surname: _surname!,
        birthDate: _dateOfBirth,
        gender: _gender,
      );
      person = person.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(person));
      await handleNested(person);
      navigator.pop();
    }
  }
}
