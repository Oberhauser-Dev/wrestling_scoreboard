import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_config_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class DivisionEdit extends BoutConfigEdit {
  final Division? division;
  final Organization? initialOrganization;
  final Division? initialParent;

  DivisionEdit({this.division, this.initialOrganization, this.initialParent, super.key})
      : super(boutConfig: division?.boutConfig);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DevisionEditState();
}

class DevisionEditState extends BoutConfigEditState<DivisionEdit> {
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
    final localizations = AppLocalizations.of(context)!;

    return buildEdit(context, id: widget.division?.id, classLocale: localizations.division, fields: [
      ListTile(
        leading: const Icon(Icons.description),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.name,
          ),
          initialValue: widget.division?.name,
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
        leading: const Icon(Icons.sunny_snowing),
        title: TextFormField(
          initialValue: widget.division?.seasonPartitions.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.seasonPartitions,
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 10)],
          onSaved: (String? value) {
            _seasonPartitions = int.tryParse(value ?? '') ?? 1;
            if (_seasonPartitions < 1) _seasonPartitions = 1;
          },
        ),
      ),
      ListTile(
        title: getDropdown<Organization>(
          icon: const Icon(Icons.corporate_fare),
          selectedItem: _organization,
          label: localizations.organization,
          context: context,
          onSaved: (Organization? value) => setState(() {
            _organization = value;
          }),
          allowEmpty: false,
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            _availableOrganizations ??=
                await (await ref.read(dataManagerNotifierProvider)).readMany<Organization, Null>();
            return (filter == null
                    ? _availableOrganizations!
                    : _availableOrganizations!.where((element) => element.name.contains(filter)))
                .toList();
          },
        ),
      ),
      ListTile(
        title: getDropdown<Division>(
          icon: const Icon(Icons.inventory),
          selectedItem: _parentDivision,
          label: localizations.division,
          context: context,
          onSaved: (Division? value) => setState(() {
            _parentDivision = value;
          }),
          itemAsString: (u) => u.fullname,
          onFind: (String? filter) async {
            _availableDivisions ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Division, Null>();
            return (filter == null
                    ? _availableDivisions!
                    : _availableDivisions!.where((element) => element.fullname.contains(filter)))
                .toList();
          },
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(BoutConfig dataObject) async {
    await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Division(
      id: widget.division?.id,
      name: _name!,
      startDate: _startDate,
      endDate: _endDate,
      boutConfig: dataObject,
      seasonPartitions: _seasonPartitions,
      organization: _organization!,
      parent: _parentDivision,
      orgSyncId: widget.division?.orgSyncId,
    ));
  }
}
