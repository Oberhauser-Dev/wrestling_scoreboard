import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class LeagueEdit extends StatefulWidget {
  final League? league;

  const LeagueEdit({this.league, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LeagueEditState();
}

class LeagueEditState extends State<LeagueEdit> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.league?.startDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final items = [
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
            icon: const Icon(Icons.description),
          ),
          initialValue: widget.league?.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
          },
          onSaved: (newValue) => _name = newValue,
        ),
      ),
      ListTile(
        title: TextFormField(
          key: ValueKey(_startDate),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
            icon: const Icon(Icons.date_range),
          ),
          onTap: () => showDatePicker(
            initialDatePickerMode: DatePickerMode.year,
            context: context,
            initialDate: _startDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
          ).then((value) {
            if (value != null) {
              setState(() => _startDate = value);
            }
          }),
          initialValue: _startDate.toIso8601String(),
        ),
      ),
    ];

    return Form(
        key: _formKey,
        child: EditWidget(
            typeLocalization: localizations.league,
            id: widget.league?.id,
            onSubmit: () => handleSubmit(context),
            items: items));
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dataProvider.createOrUpdateSingle(League(id: widget.league?.id, name: _name!, startDate: _startDate));
      Navigator.of(context).pop();
    }
  }
}
