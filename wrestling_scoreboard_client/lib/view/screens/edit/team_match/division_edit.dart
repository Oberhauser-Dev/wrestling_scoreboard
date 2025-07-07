import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionEdit extends ConsumerStatefulWidget {
  final Division? division;
  final Organization? initialOrganization;
  final Division? initialParent;

  const DivisionEdit({this.division, this.initialOrganization, this.initialParent, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DivisionEditState();
}

class DivisionEditState extends ConsumerState<DivisionEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Organization>? _availableOrganizations;
  Iterable<Division>? _availableDivisions;

  String? _name;
  late int _seasonPartitions;
  late DateTime _startDate;
  late DateTime _endDate;
  late Organization? _organization;
  late Division? _parentDivision;

  @override
  void initState() {
    _startDate = widget.division?.startDate ?? DateTime.now();
    _endDate = widget.division?.endDate ?? DateTime.now().add(const Duration(days: 365));
    _seasonPartitions = widget.division?.seasonPartitions ?? 1;
    _organization = widget.division?.organization ?? widget.initialOrganization;
    _parentDivision = widget.division?.parent ?? widget.initialParent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      CustomTextInput(
        iconData: Icons.description,
        label: localizations.name,
        initialValue: widget.division?.name,
        isMandatory: true,
        onSaved: (value) => _name = value,
      ),
      ListTile(
        leading: const Icon(Icons.event),
        title: TextFormField(
          key: ValueKey(_startDate),
          readOnly: true,
          decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: localizations.startDate),
          onTap:
              () => showDatePicker(
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
        leading: const Icon(Icons.event),
        title: TextFormField(
          key: ValueKey(_endDate),
          readOnly: true,
          decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: localizations.endDate),
          onTap:
              () => showDatePicker(
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
      NumericalInput(
        iconData: Icons.sunny_snowing,
        initialValue: widget.division?.seasonPartitions,
        label: localizations.seasonPartitions,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 10),
        isMandatory: true,
        onSaved: (int? value) => _seasonPartitions = value ?? 1,
      ),
      ListTile(
        title: SearchableDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _organization,
          label: localizations.organization,
          context: context,
          onSaved:
              (Organization? value) => setState(() {
                _organization = value;
              }),
          allowEmpty: false,
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableOrganizations ??=
                await (await ref.read(dataManagerNotifierProvider)).readMany<Organization, Null>();
            return _availableOrganizations!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Division>(
          icon: const Icon(Icons.inventory),
          selectedItem: _parentDivision,
          label: localizations.division,
          context: context,
          onSaved:
              (Division? value) => setState(() {
                _parentDivision = value;
              }),
          itemAsString: (u) => u.fullname,
          asyncItems: (String filter) async {
            _availableDivisions ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Division, Null>();
            return _availableDivisions!.toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.division,
        id: widget.division?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BoutConfig? boutConfig = widget.division?.boutConfig;
      if (boutConfig == null) {
        boutConfig = TeamMatch.defaultBoutConfig;
        boutConfig = boutConfig.copyWithId(
          await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(boutConfig),
        );
      }
      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
        Division(
          id: widget.division?.id,
          name: _name!,
          startDate: _startDate,
          endDate: _endDate,
          boutConfig: boutConfig,
          seasonPartitions: _seasonPartitions,
          organization: _organization!,
          parent: _parentDivision,
          orgSyncId: widget.division?.orgSyncId,
        ),
      );
      navigator.pop();
    }
  }
}
