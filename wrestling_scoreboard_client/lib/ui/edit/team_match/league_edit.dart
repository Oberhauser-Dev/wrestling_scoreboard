import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/ui/edit/bout_config_edit.dart';
import 'package:wrestling_scoreboard_client/util/date_time.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueEdit extends BoutConfigEdit {
  final League? league;

  LeagueEdit({this.league, super.key}) : super(boutConfig: league?.boutConfig);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LeagueEditState();
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

    return buildEdit(context, id: widget.league?.id, classLocale: localizations.league, fields: [
      ListTile(
        leading: const Icon(Icons.description),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
          ),
          initialValue: widget.league?.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            return null;
          },
          onSaved: (newValue) => _name = newValue,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.date_range),
        title: TextFormField(
          key: ValueKey(_startDate),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
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
    await ref.read(dataManagerProvider).createOrUpdateSingle(
        League(id: widget.league?.id, name: _name!, startDate: _startDate, boutConfig: dataObject));
  }
}
