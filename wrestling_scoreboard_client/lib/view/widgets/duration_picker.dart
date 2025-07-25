import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';

class DurationFormField extends FormField<Duration> {
  final Duration minValue;
  final Duration maxValue;
  final void Function(Duration?)? onChange;
  final bool showSeconds;
  final bool showMinutes;
  final bool showHours;
  final bool showDays;

  DurationFormField({
    super.key,
    required super.initialValue,
    this.minValue = Duration.zero,
    required this.maxValue,
    this.onChange,
    super.onSaved,
    this.showSeconds = true,
    this.showMinutes = true,
    this.showHours = false,
    this.showDays = false,
  }) : super(
         builder: (FormFieldState<Duration?> state) {
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
             showDays: showDays,
             showHours: showHours,
             showMinutes: showMinutes,
             showSeconds: showSeconds,
           );
         },
       );
}

class DurationPicker extends StatefulWidget {
  final Duration? initialValue;
  final Duration minValue;
  final Duration maxValue;
  final void Function(Duration?) onChange;
  final bool showSeconds;
  final bool showMinutes;
  final bool showHours;
  final bool showDays;

  const DurationPicker({
    super.key,
    required this.initialValue,
    this.minValue = Duration.zero,
    required this.maxValue,
    required this.onChange,
    this.showSeconds = true,
    this.showMinutes = true,
    this.showHours = false,
    this.showDays = false,
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late int _days;
  late int _hours;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    _days = widget.initialValue?.inDays ?? 0;
    _hours = widget.initialValue?.inHours.remainder(24) ?? 0;
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
        if (widget.showDays)
          Expanded(
            child: TextFormField(
              initialValue: _days.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localizations.days),
              inputFormatters: <TextInputFormatter>[
                NumericalRangeFormatter(min: widget.minValue.inDays.toDouble(), max: widget.maxValue.inDays.toDouble()),
              ],
              onChanged: (String? value) {
                _days = int.tryParse(value ?? '') ?? 0;
                widget.onChange(Duration(days: _days, hours: _hours, minutes: _minutes, seconds: _seconds));
              },
            ),
          ),
        if (widget.showDays && widget.showHours) const SizedBox(width: 16),
        if (widget.showHours)
          Expanded(
            child: TextFormField(
              initialValue: _hours.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localizations.hours),
              inputFormatters: <TextInputFormatter>[
                NumericalRangeFormatter(
                  min: widget.minValue.inHours.toDouble(),
                  max: widget.maxValue.inHours.toDouble(),
                ),
              ],
              onChanged: (String? value) {
                _hours = int.tryParse(value ?? '') ?? 0;
                widget.onChange(Duration(days: _days, hours: _hours, minutes: _minutes, seconds: _seconds));
              },
            ),
          ),
        if (widget.showHours && widget.showMinutes) const SizedBox(width: 16),
        if (widget.showMinutes)
          Expanded(
            child: TextFormField(
              initialValue: _minutes.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localizations.minutes),
              inputFormatters: <TextInputFormatter>[
                NumericalRangeFormatter(
                  min: widget.minValue.inMinutes.toDouble(),
                  max: widget.maxValue.inMinutes.toDouble(),
                ),
              ],
              onChanged: (String? value) {
                _minutes = int.tryParse(value ?? '') ?? 0;
                widget.onChange(Duration(days: _days, hours: _hours, minutes: _minutes, seconds: _seconds));
              },
            ),
          ),
        if (widget.showMinutes && widget.showSeconds) const SizedBox(width: 16),
        if (widget.showSeconds)
          Expanded(
            child: TextFormField(
              initialValue: _seconds.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localizations.seconds),
              inputFormatters: <TextInputFormatter>[
                NumericalRangeFormatter(
                  min: widget.minValue.inSeconds.toDouble(),
                  max: widget.maxValue.inSeconds.toDouble(),
                ),
              ],
              onChanged: (String? value) {
                _seconds = int.tryParse(value ?? '') ?? 0;
                widget.onChange(Duration(days: _days, hours: _hours, minutes: _minutes, seconds: _seconds));
              },
            ),
          ),
      ],
    );
  }
}
