import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
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
  late int _boutDays;

  @override
  void initState() {
    _startDate = widget.league?.startDate ?? DateTime.now();
    _endDate = widget.league?.endDate ?? DateTime.now();
    _division = widget.league?.division ?? widget.initialDivision;
    _boutDays = widget.league?.boutDays ?? 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<Division>(
          icon: const Icon(Icons.inventory),
          selectedItem: _division,
          label: localizations.division,
          context: context,
          onSaved:
              (Division? value) => setState(() {
                _division = value;
              }),
          itemAsString: (u) => u.fullname,
          allowEmpty: false,
          asyncItems: (String filter) async {
            _availableDivisions ??= await (await ref.read(dataManagerProvider)).readMany<Division, Null>();
            return _availableDivisions!.toList();
          },
        ),
      ),
      CustomTextInput.icon(
        iconData: Icons.description,
        label: localizations.name,
        initialValue: widget.league?.name,
        isMandatory: true,
        onSaved: (value) => _name = value,
      ),
      DateInput(
        iconData: Icons.event,
        label: localizations.startDate,
        initialValue: _startDate,
        initialDatePickerMode: DatePickerMode.year,
        isMandatory: true,
        minValue: DateTime.now().subtract(const Duration(days: 365 * 5)),
        maxValue: DateTime.now().add(const Duration(days: 365 * 3)),
        onSaved: (newValue) {
          if (newValue != null) {
            _startDate = newValue;
          }
        },
      ),
      DateInput(
        iconData: Icons.event,
        label: localizations.endDate,
        initialValue: _endDate,
        initialDatePickerMode: DatePickerMode.year,
        isMandatory: true,
        minValue: DateTime.now().subtract(const Duration(days: 365 * 5)),
        maxValue: DateTime.now().add(const Duration(days: 365 * 3)),
        onSaved: (newValue) {
          if (newValue != null) {
            _endDate = newValue;
          }
        },
      ),
      NumericalInput(
        iconData: Icons.calendar_month,
        initialValue: (widget.league?.boutDays ?? 0),
        label: localizations.boutDays,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 100),
        isMandatory: true,
        onSaved: (int? value) => _boutDays = value ?? 1,
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
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(
        League(
          id: widget.league?.id,
          organization: widget.league?.organization ?? widget.initialDivision?.organization,
          orgSyncId: widget.league?.orgSyncId,
          name: _name!,
          startDate: _startDate,
          endDate: _endDate,
          division: _division!,
          boutDays: _boutDays,
        ),
      );
      navigator.pop();
    }
  }
}
