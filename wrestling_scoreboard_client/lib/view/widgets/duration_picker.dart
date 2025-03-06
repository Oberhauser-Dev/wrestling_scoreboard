import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';

class DurationFormField extends FormField<Duration> {
  final Duration minValue;
  final Duration maxValue;
  final void Function(Duration?)? onChange;

  DurationFormField({
    super.key,
    required super.initialValue,
    this.minValue = Duration.zero,
    required this.maxValue,
    this.onChange,
    super.onSaved,
  }) : super(builder: (FormFieldState<Duration?> state) {
          return DurationPicker(
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            onChange: (Duration? duration) {
              state.didChange(duration);
              if (onChange != null) {
                onChange(duration);
              }
            },
          );
        });
}

class DurationPicker extends StatefulWidget {
  final Duration? initialValue;
  final Duration minValue;
  final Duration maxValue;
  final void Function(Duration?) onChange;

  const DurationPicker({
    super.key,
    required this.initialValue,
    this.minValue = Duration.zero,
    required this.maxValue,
    required this.onChange,
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    _minutes = widget.initialValue?.inMinutes.remainder(60) ?? 0;
    _seconds = widget.initialValue?.inSeconds.remainder(60) ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _minutes.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.minutes,
            ),
            inputFormatters: <TextInputFormatter>[
              NumericalRangeFormatter(
                  min: widget.minValue.inMinutes.toDouble(), max: widget.maxValue.inMinutes.toDouble())
            ],
            onChanged: (String? value) {
              _minutes = int.tryParse(value ?? '') ?? 0;
              widget.onChange(Duration(minutes: _minutes, seconds: _seconds));
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            initialValue: _seconds.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.seconds,
            ),
            inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 0, max: 59)],
            onChanged: (String? value) {
              _seconds = int.tryParse(value ?? '') ?? 0;
              widget.onChange(Duration(minutes: _minutes, seconds: _seconds));
            },
          ),
        ),
      ],
    );
  }
}
