import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/ui/edit/common.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

abstract class BoutConfigEdit extends StatefulWidget {
  final BoutConfig? boutConfig;

  const BoutConfigEdit({this.boutConfig, Key? key}) : super(key: key);
}

abstract class BoutConfigEditState<T extends BoutConfigEdit> extends State<T> implements AbstractEditState<BoutConfig> {
  final _formKey = GlobalKey<FormState>();

  int? _periodDurationInSecs;
  int? _breakDurationInSecs;
  int? _activityDurationInSecs;
  int? _injuryDurationInSecs;
  int? _periodCount;

  @override
  Widget buildEdit(BuildContext context, {required String? classLocale, required List<Widget> fields}) {
    final localizations = AppLocalizations.of(context)!;

    final items = [
      ...fields,
      ListTile(
        title: TextFormField(
          initialValue: (widget.boutConfig?.periodDuration ?? BoutConfig.defaultPeriodDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.timer),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.periodDurationInSecs),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _periodDurationInSecs = value != null ? int.parse(value) : 0;
          },
        ),
      ),
      ListTile(
        title: TextFormField(
          initialValue: (widget.boutConfig?.breakDuration ?? BoutConfig.defaultBreakDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.timer),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.breakDurationInSecs),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _breakDurationInSecs = value != null ? int.parse(value) : 0;
          },
        ),
      ),
      ListTile(
        title: TextFormField(
          initialValue:
              (widget.boutConfig?.activityDuration ?? BoutConfig.defaultActivityDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.timer),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.activityDurationInSecs),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _activityDurationInSecs = value != null ? int.parse(value) : 0;
          },
        ),
      ),
      ListTile(
        title: TextFormField(
          initialValue:
              (widget.boutConfig?.injuryDuration ?? BoutConfig.defaultInjuryDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.timer),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.injuryDurationInSecs),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _injuryDurationInSecs = value != null ? int.parse(value) : 0;
          },
        ),
      ),
      ListTile(
        title: TextFormField(
          initialValue: (widget.boutConfig?.periodCount ?? BoutConfig.defaultPeriodCount).toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.repeat),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.periodCount),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,2}'))],
          onSaved: (String? value) {
            _periodCount = value != null ? int.parse(value) : 0;
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: classLocale ?? 'Bout config',
        id: widget.boutConfig?.id,
        onSubmit: () => handleSubmit(context),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final boutConfig = BoutConfig(
        id: widget.boutConfig?.id,
        periodDuration: Duration(seconds: _periodDurationInSecs!),
        breakDuration: Duration(seconds: _breakDurationInSecs!),
        activityDuration: Duration(seconds: _activityDurationInSecs!),
        injuryDuration: Duration(seconds: _injuryDurationInSecs!),
        periodCount: _periodCount!,
      );
      boutConfig.id = await dataProvider.createOrUpdateSingle(boutConfig);
      await handleNested(boutConfig);
      Navigator.of(context).pop();
    }
  }
}
