import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

class OkDialog extends StatelessWidget {
  final Widget child;

  const OkDialog({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      content: SizedBox(
        width: 300,
        child: child,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.ok),
        ),
      ],
    );
  }
}

class OkCancelDialog<T extends Object?> extends StatelessWidget {
  final Widget child;
  final T Function() getResult;

  const OkCancelDialog({required this.child, required this.getResult, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, getResult()),
          child: Text(localizations.ok),
        ),
      ],
    );
  }
}

Future<void> showExceptionDialog({required BuildContext context, required Exception exception}) async {
  final localizations = AppLocalizations.of(context)!;
  await showDialog(
    context: context,
    builder: (context) => OkDialog(
      child: Column(
        children: [
          if (exception is RestException) SelectableText(localizations.invalidParameterException),
          SelectableText(
            exception.toString(),
            style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

class TextInputDialog extends StatelessWidget {
  final String? initialValue;

  const TextInputDialog({required this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    String? result;
    return OkCancelDialog(
        child: TextFormField(
          initialValue: initialValue,
          onChanged: (value) => result = value,
        ),
        getResult: () => result);
  }
}

class DurationDialog extends StatelessWidget {
  final Duration initialValue;
  final Duration minValue;
  final Duration maxValue;

  const DurationDialog({this.initialValue = Duration.zero, super.key, required this.minValue, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    Duration? result;
    return OkCancelDialog<Duration?>(
        child: isMobile
            ? CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.ms,
                initialTimerDuration: initialValue,
                onTimerDurationChanged: (value) => result = value,
              )
            : _DurationPicker(
                minValue: minValue,
                maxValue: maxValue,
                initialValue: initialValue,
                onChange: (value) => result = value,
              ),
        getResult: () => result);
  }
}

class _DurationPicker extends StatefulWidget {
  final Duration initialValue;
  final Duration minValue;
  final Duration maxValue;
  final void Function(Duration?) onChange;

  const _DurationPicker({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChange,
  });

  @override
  State<_DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<_DurationPicker> {
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    _minutes = widget.initialValue.inMinutes;
    _seconds = widget.initialValue.inSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextFormField(
            initialValue: widget.initialValue.inMinutes.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.minutes,
            ),
            inputFormatters: <TextInputFormatter>[
              _NumericalRangeFormatter(
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
            initialValue: widget.initialValue.inSeconds.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: localizations.seconds,
            ),
            inputFormatters: <TextInputFormatter>[_NumericalRangeFormatter(min: 0, max: 59)],
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

class _NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  _NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}

class RadioDialog<T> extends StatefulWidget {
  final List<MapEntry<T?, String>> values;
  final T? initialValue;
  final void Function(T? value)? onChanged;

  const RadioDialog({
    super.key,
    required this.values,
    required this.initialValue,
    this.onChanged,
  });

  @override
  State<RadioDialog<T>> createState() => _RadioDialogState<T>();
}

class _RadioDialogState<T> extends State<RadioDialog<T>> {
  T? result;

  @override
  void initState() {
    result = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OkCancelDialog<T?>(
        child: ListView.builder(
          key: Key(result.toString()),
          shrinkWrap: true,
          itemCount: widget.values.length,
          itemBuilder: (context, index) {
            final entry = widget.values[index];
            return RadioListTile<T?>(
              value: entry.key,
              groupValue: result,
              onChanged: (v) {
                if (widget.onChanged != null) widget.onChanged!(v);
                setState(() {
                  result = v;
                });
              },
              title: Text(entry.value),
            );
          },
        ),
        getResult: () => result);
  }
}
