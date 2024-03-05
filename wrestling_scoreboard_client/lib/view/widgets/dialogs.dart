import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';

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
      // Do not wrap this into a column with shrinkwrap, so that ListViews act dynamically.
      content: SizedBox(
        width: 300,
        child: child,
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

  const DurationDialog({
    this.initialValue = Duration.zero,
    super.key,
    this.minValue = Duration.zero,
    required this.maxValue,
  });

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
            : DurationPicker(
                minValue: minValue,
                maxValue: maxValue,
                initialValue: initialValue,
                onChange: (value) => result = value,
              ),
        getResult: () => result);
  }
}

class RadioDialog<T> extends StatefulWidget {
  final List<MapEntry<T?, String>>? values;
  final (T?, Widget) Function(int index)? builder;
  final T? initialValue;
  final int? itemCount;
  final void Function(T? value)? onChanged;

  const RadioDialog({
    super.key,
    this.values,
    this.builder,
    required this.initialValue,
    this.onChanged,
    this.itemCount,
  }) : assert(values != null || builder != null);

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
          itemCount: widget.itemCount ?? widget.values?.length,
          itemBuilder: (context, index) {
            final T? key;
            final Widget child;
            if (widget.values != null) {
              final entry = widget.values![index];
              key = entry.key;
              child = Text(entry.value);
            } else {
              (key, child) = widget.builder!(index);
            }
            return RadioListTile<T?>(
              value: key,
              groupValue: result,
              onChanged: (v) {
                if (widget.onChanged != null) widget.onChanged!(v);
                setState(() {
                  result = v;
                });
              },
              title: child,
            );
          },
        ),
        getResult: () => result);
  }
}
