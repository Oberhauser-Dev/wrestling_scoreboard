import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/edit/bout_config_edit.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class LeagueEdit extends BoutConfigEdit {
  final League? league;

  const LeagueEdit({this.league, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LeagueEditState();
}

class LeagueEditState extends BoutConfigEditState<LeagueEdit> {
  String? _name;
  late DateTime _startDate;

  @override
  void initState() {
    _startDate = widget.league?.startDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return buildEdit(context, classLocale: localizations.league, fields: [
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
          initialValue: _startDate.toDateString(context),
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(BoutConfig dataObject) async {
    await dataProvider.createOrUpdateSingle(
        League(id: widget.league?.id, name: _name!, startDate: _startDate, boutConfig: dataObject));
  }
}
