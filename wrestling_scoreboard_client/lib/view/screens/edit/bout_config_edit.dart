import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class BoutConfigEdit extends ConsumerStatefulWidget {
  final BoutConfig? boutConfig;

  const BoutConfigEdit({this.boutConfig, super.key});
}

abstract class BoutConfigEditState<T extends BoutConfigEdit> extends ConsumerState<T>
    implements AbstractEditState<BoutConfig> {
  final _formKey = GlobalKey<FormState>();

  Duration? _periodDuration;
  Duration? _breakDuration;
  Duration? _activityDuration;
  Duration? _injuryDuration;
  Duration? _bleedingInjuryDuration;
  int? _periodCount;

  @override
  Widget buildEdit(
    BuildContext context, {
    required String classLocale,
    required int? id,
    required List<Widget> fields,
  }) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      ListTile(
        leading: const Icon(Icons.timelapse),
        subtitle: Text(localizations.periodDuration),
        title: DurationFormField(
          initialValue: widget.boutConfig?.periodDuration ?? BoutConfig.defaultPeriodDuration,
          maxValue: const Duration(hours: 1),
          onSaved: (Duration? value) {
            _periodDuration = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timelapse),
        subtitle: Text(localizations.breakDuration),
        title: DurationFormField(
          initialValue: widget.boutConfig?.breakDuration ?? BoutConfig.defaultBreakDuration,
          maxValue: const Duration(hours: 1),
          onSaved: (Duration? value) {
            _breakDuration = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timelapse),
        subtitle: Text(localizations.activityDuration),
        title: DurationFormField(
          initialValue: widget.boutConfig?.activityDuration,
          maxValue: const Duration(hours: 1),
          onSaved: (Duration? value) {
            _activityDuration = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timelapse),
        subtitle: Text(localizations.injuryDuration),
        title: DurationFormField(
          initialValue: widget.boutConfig?.injuryDuration,
          maxValue: const Duration(hours: 1),
          onSaved: (Duration? value) {
            _injuryDuration = value;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.timelapse),
        subtitle: Text(localizations.bleedingInjuryDuration),
        title: DurationFormField(
          initialValue: widget.boutConfig?.bleedingInjuryDuration,
          maxValue: const Duration(hours: 1),
          onSaved: (Duration? value) {
            _bleedingInjuryDuration = value;
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
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 10)],
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
      BoutConfig boutConfig = BoutConfig(
        id: widget.boutConfig?.id,
        periodDuration: _periodDuration!,
        breakDuration: _breakDuration!,
        activityDuration: _activityDuration,
        injuryDuration: _injuryDuration,
        bleedingInjuryDuration: _bleedingInjuryDuration,
        periodCount: _periodCount!,
      );
      boutConfig =
          boutConfig.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(boutConfig));
      await handleNested(boutConfig);
      navigator.pop();
    }
  }
}
