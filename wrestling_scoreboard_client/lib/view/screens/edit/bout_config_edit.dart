import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class BoutConfigEdit extends ConsumerStatefulWidget {
  final BoutConfig? boutConfig;

  const BoutConfigEdit({this.boutConfig, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoutConfigEditState();
}

class BoutConfigEditState extends ConsumerState<BoutConfigEdit> {
  final _formKey = GlobalKey<FormState>();

  Duration? _periodDuration;
  Duration? _breakDuration;
  Duration? _activityDuration;
  Duration? _injuryDuration;
  Duration? _bleedingInjuryDuration;
  int? _periodCount;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
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
      NumericalInput(
        iconData: Icons.repeat,
        initialValue: widget.boutConfig?.periodCount ?? BoutConfig.defaultPeriodCount,
        label: localizations.periodCount,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 10),
        isMandatory: true,
        onSaved: (int? value) => _periodCount = value,
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.boutConfig,
        id: widget.boutConfig?.id,
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
      boutConfig = boutConfig.copyWithId(await (await ref.read(dataManagerProvider)).createOrUpdateSingle(boutConfig));
      navigator.pop();
    }
  }
}
