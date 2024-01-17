import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/common.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutConfigEdit extends ConsumerStatefulWidget {
  final BoutConfig? boutConfig;

  const BoutConfigEdit({this.boutConfig, super.key});
}

abstract class BoutConfigEditState<T extends BoutConfigEdit> extends ConsumerState<T>
    implements AbstractEditState<BoutConfig> {
  final _formKey = GlobalKey<FormState>();

  int? _periodDurationInSecs;
  int? _breakDurationInSecs;
  int? _activityDurationInSecs;
  int? _injuryDurationInSecs;
  int? _periodCount;

  @override
  Widget buildEdit(
    BuildContext context, {
    required String classLocale,
    required int? id,
    required List<Widget> fields,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      ListTile(
        leading: const Icon(Icons.timer),
        title: TextFormField(
          initialValue: (widget.boutConfig?.periodDuration ?? BoutConfig.defaultPeriodDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.periodDurationInSecs,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _periodDurationInSecs = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timer),
        title: TextFormField(
          initialValue: (widget.boutConfig?.breakDuration ?? BoutConfig.defaultBreakDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.breakDurationInSecs,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _breakDurationInSecs = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timer),
        title: TextFormField(
          initialValue:
              (widget.boutConfig?.activityDuration ?? BoutConfig.defaultActivityDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.activityDurationInSecs,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _activityDurationInSecs = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timer),
        title: TextFormField(
          initialValue: (widget.boutConfig?.injuryDuration ?? BoutConfig.defaultInjuryDuration).inSeconds.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.injuryDurationInSecs,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,4}'))],
          onSaved: (String? value) {
            _injuryDurationInSecs = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.repeat),
        title: TextFormField(
          initialValue: (widget.boutConfig?.periodCount ?? BoutConfig.defaultPeriodCount).toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.periodCount,
          ),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,2}'))],
          onSaved: (String? value) {
            _periodCount = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: classLocale,
        id: id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var boutConfig = BoutConfig(
        id: widget.boutConfig?.id,
        periodDuration: Duration(seconds: _periodDurationInSecs!),
        breakDuration: Duration(seconds: _breakDurationInSecs!),
        activityDuration: Duration(seconds: _activityDurationInSecs!),
        injuryDuration: Duration(seconds: _injuryDurationInSecs!),
        periodCount: _periodCount!,
      );
      boutConfig = boutConfig.copyWithId(await ref.read(dataManagerProvider).createOrUpdateSingle(boutConfig));
      await handleNested(boutConfig);
      navigator.pop();
    }
  }
}
