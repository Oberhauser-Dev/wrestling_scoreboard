import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_config_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionEdit extends BoutConfigEdit {
  final Competition? competition;
  final Organization? initialOrganization;

  const CompetitionEdit({this.competition, this.initialOrganization, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionEditState();
}

class CompetitionEditState extends BoutConfigEditState<CompetitionEdit> {
  String? _location;
  String? _no;
  late DateTime _date;
  String? _comment;
  String? _name;
  int? _visitorsCount;
  int? _matCount;

  @override
  void initState() {
    super.initState();
    _date = widget.competition?.date ?? DateTime.now();
    _comment = widget.competition?.comment;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return buildEdit(context, id: widget.competition?.id, classLocale: localizations.competition, fields: [
      CustomTextInput(
        onSaved: (String? value) => _name = value,
        label: localizations.name,
        isMandatory: true,
        iconData: Icons.short_text,
        initialValue: widget.competition?.name,
      ),
      ListTile(
        leading: const Icon(Icons.tag),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.competitionNumber,
          ),
          initialValue: widget.competition?.no,
          onSaved: (newValue) => _no = newValue,
        ),
      ),
      CustomTextInput(
        onSaved: (String? value) => _location = value,
        label: localizations.place,
        isMandatory: true,
        iconData: Icons.place,
        initialValue: widget.competition?.location,
      ),
      ListTile(
        leading: const Icon(Icons.date_range),
        title: TextFormField(
          key: ValueKey(_date),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
          ),
          onTap: () => showDatePicker(
            initialDatePickerMode: DatePickerMode.day,
            context: context,
            initialDate: _date,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
          ).then((value) {
            if (value != null) {
              setState(() => _date = value);
            }
          }),
          initialValue: _date.toDateTimeString(context),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.adjust), // Replace with square_dot
        title: TextFormField(
          initialValue: widget.competition?.matCount.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.mats,
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
          onSaved: (String? value) {
            _matCount = int.tryParse(value ?? '') ?? 1;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.confirmation_number),
        title: TextFormField(
          initialValue: widget.competition?.visitorsCount.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.visitors,
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 9223372036854775808)],
          onSaved: (String? value) {
            _visitorsCount = int.tryParse(value ?? '');
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.comment),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.comment,
          ),
          initialValue: widget.competition?.comment,
          onSaved: (newValue) => _comment = newValue,
        ),
      ),
    ]);
  }

  @override
  Future<void> handleNested(BoutConfig boutConfig) async {
    await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
      Competition(
        id: widget.competition?.id,
        organization: widget.competition?.organization ?? widget.initialOrganization,
        orgSyncId: widget.competition?.orgSyncId,
        location: _location!,
        no: _no,
        date: _date,
        comment: _comment,
        name: _name!,
        boutConfig: boutConfig,
        visitorsCount: _visitorsCount,
        matCount: _matCount!,
      ),
    );
  }
}
