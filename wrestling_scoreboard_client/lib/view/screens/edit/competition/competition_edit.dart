import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionEdit extends ConsumerStatefulWidget {
  final Competition? competition;
  final Organization? initialOrganization;

  const CompetitionEdit({this.competition, this.initialOrganization, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionEditState();
}

class CompetitionEditState extends ConsumerState<CompetitionEdit> {
  final _formKey = GlobalKey<FormState>();

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
    final navigator = Navigator.of(context);

    final items = [
      CustomTextInput(
        onSaved: (String? value) => _name = value,
        label: localizations.name,
        isMandatory: true,
        iconData: Icons.short_text,
        initialValue: widget.competition?.name,
      ),
      CustomTextInput(
        iconData: Icons.tag,
        label: localizations.competitionNumber,
        initialValue: widget.competition?.no,
        isMandatory: false,
        onSaved: (value) => _no = value,
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
          decoration: CustomInputDecoration(isMandatory: true, label: localizations.date, localizations: localizations),
          onTap:
              () => showDatePicker(
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
      NumericalInput(
        iconData: Icons.adjust,
        // Replace with square_dot
        initialValue: widget.competition?.matCount,
        label: localizations.mats,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _matCount = value,
      ),
      NumericalInput(
        iconData: Icons.confirmation_number,
        initialValue: widget.competition?.visitorsCount,
        label: localizations.visitors,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 9223372036854775808),
        isMandatory: false,
        onSaved: (int? value) => _visitorsCount = value,
      ),
      CustomTextInput(
        iconData: Icons.comment,
        label: localizations.comment,
        initialValue: widget.competition?.comment,
        isMandatory: false,
        onSaved: (value) => _comment = value,
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.competition,
        id: widget.competition?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BoutConfig? boutConfig = widget.competition?.boutConfig;
      if (boutConfig == null) {
        boutConfig = Competition.defaultBoutConfig;
        boutConfig = boutConfig.copyWithId(
          await (await ref.read(dataManagerProvider)).createOrUpdateSingle(boutConfig),
        );
      }
      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(
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
      navigator.pop();
    }
  }
}
