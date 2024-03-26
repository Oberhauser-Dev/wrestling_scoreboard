import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class LeagueEdit extends ConsumerStatefulWidget {
  final League? league;
  final Division? initialDivision;

  const LeagueEdit({this.league, this.initialDivision, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LeagueEditState();
}

class LeagueEditState extends ConsumerState<LeagueEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Division>? _availableDivisions;

  String? _name;
  late DateTime _startDate;
  late DateTime _endDate;
  Division? _division;

  @override
  void initState() {
    _startDate = widget.league?.startDate ?? DateTime.now();
    _endDate = widget.league?.endDate ?? DateTime.now();
    _division = widget.league?.division ?? widget.initialDivision;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    final items = [
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
            labelText: localizations.startDate,
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
      ListTile(
        leading: const Icon(Icons.date_range),
        title: TextFormField(
          key: ValueKey(_endDate),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.endDate,
          ),
          onTap: () => showDatePicker(
            initialDatePickerMode: DatePickerMode.year,
            context: context,
            initialDate: _endDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
          ).then((value) {
            if (value != null) {
              setState(() => _endDate = value);
            }
          }),
          initialValue: _endDate.toDateString(context),
        ),
      ),
      ListTile(
        title: getDropdown<Division>(
          icon: const Icon(Icons.inventory),
          selectedItem: _division,
          label: localizations.division,
          context: context,
          onSaved: (Division? value) => setState(() {
            _division = value;
          }),
          itemAsString: (u) => u.fullname,
          allowEmpty: false,
          onFind: (String? filter) async {
            _availableDivisions ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Division, Null>();
            return (filter == null
                    ? _availableDivisions!
                    : _availableDivisions!.where((element) => element.fullname.contains(filter)))
                .toList();
          },
        ),
      ),
    ];
    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.league,
        id: widget.league?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(League(
        id: widget.league?.id,
        organization: widget.league?.organization ?? widget.initialDivision?.organization,
        orgSyncId: widget.league?.orgSyncId,
        name: _name!,
        startDate: _startDate,
        endDate: _endDate,
        division: _division!,
      ));
      navigator.pop();
    }
  }
}
