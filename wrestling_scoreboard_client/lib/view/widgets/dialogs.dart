import 'package:flutter/material.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class SizedDialog extends StatelessWidget {
  /// Do not wrap this into a column with shrinkwrap, so that ListViews act dynamically.
  const SizedDialog({super.key, required this.actions, required this.child, this.isScrollable = true});

  final List<Widget> actions;
  final Widget child;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(width: 300, child: isScrollable ? SingleChildScrollView(child: child) : child),
      actions: actions,
    );
  }
}

class OkDialog extends StatelessWidget {
  final Widget child;

  const OkDialog({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SizedDialog(
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(localizations.ok))],
      child: child,
    );
  }
}

class CancelDialog extends StatelessWidget {
  final Widget child;

  const CancelDialog({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SizedDialog(
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(localizations.cancel))],
      child: child,
    );
  }
}

Future<void> showOkDialog({required BuildContext context, required Widget child}) async {
  await showDialog(context: context, builder: (context) => OkDialog(child: child));
}

class OkCancelDialog<T extends Object?> extends StatelessWidget {
  final Widget child;
  final String? okText;
  final T Function() getResult;
  final bool isScrollable;

  const OkCancelDialog({
    required this.child,
    required this.getResult,
    this.okText,
    super.key,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SizedDialog(
      isScrollable: isScrollable,
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.pop(context), child: Text(localizations.cancel)),
        TextButton(onPressed: () => Navigator.pop(context, getResult()), child: Text(okText ?? localizations.ok)),
      ],
      child: child,
    );
  }
}

Future<bool> showOkCancelDialog({required BuildContext context, required Widget child, String? okText}) async {
  return (await showDialog<bool>(
        context: context,
        builder: (context) => OkCancelDialog<bool>(getResult: () => true, okText: okText, child: child),
      )) ??
      false;
}

Future<void> showExceptionDialog({
  required BuildContext context,
  required Object exception,
  required StackTrace? stackTrace,
  void Function()? onRetry,
}) async {
  if (onRetry == null) {
    return await showOkDialog(context: context, child: ExceptionInfo(exception, stackTrace: stackTrace));
  }
  await showDialog(
    context: context,
    builder:
        (context) => OkCancelDialog<bool>(
          getResult: () {
            onRetry();
            return true;
          },
          okText: context.l10n.retry,
          child: ExceptionInfo(exception, stackTrace: stackTrace),
        ),
  );
}

Future<void> showLoadingDialog({
  required BuildContext context,
  required Future<void> Function(BuildContext context) runAsync,
  required String label,
}) async {
  showDialog(
    useRootNavigator: false, // Pop from outside of this dialog.
    context: context,
    barrierDismissible: false,
    builder:
        (context) => ResponsiveContainer(
          child: CancelDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator())),
              ],
            ),
          ),
        ),
  );
  try {
    await runAsync(context);
  } finally {
    if (context.mounted) {
      // Pop loading dialog
      Navigator.of(context).pop();
    }
  }
}

Future<void> catchAsync(BuildContext context, Future<void> Function() doAsync, {void Function()? onRetry}) async {
  try {
    await doAsync();
  } catch (exception, stackTrace) {
    if (context.mounted) {
      await showExceptionDialog(context: context, exception: exception, stackTrace: stackTrace, onRetry: onRetry);
    }
    rethrow;
  }
}

class TextInputDialog extends StatelessWidget {
  final String? initialValue;

  const TextInputDialog({required this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    String? result;
    return OkCancelDialog(
      child: TextFormField(initialValue: initialValue, onChanged: (value) => result = value),
      getResult: () => result,
    );
  }
}

Future<Duration?> showDurationDialog({
  required BuildContext context,
  Duration initialDuration = Duration.zero,
  DurationPickerMode mode = DurationPickerMode.ms,
  Duration minValue = Duration.zero,
  required Duration maxValue,
}) async {
  final res = await showDurationPicker(
    context: context,
    initialDuration: initialDuration,
    initialEntryMode: isMobile ? DurationPickerEntryMode.dial : DurationPickerEntryMode.input,
    durationPickerMode: mode,
  );
  if (res == null) return res;
  return (res < minValue) ? minValue : ((res > maxValue) ? maxValue : res);
}

class RadioDialog<T> extends StatefulWidget {
  final List<MapEntry<T?, String>>? values;
  final (T?, Widget) Function(int index)? builder;
  final T? initialValue;
  final int? itemCount;
  final void Function(T? value)? onChanged;
  final bool shrinkWrap;

  const RadioDialog({
    super.key,
    this.values,
    this.builder,
    required this.initialValue,
    this.onChanged,
    this.itemCount,
    this.shrinkWrap = true,
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
      isScrollable: widget.shrinkWrap,
      child: ListView.builder(
        // key: Key(result.toString()), // Specifying a key will reset the list position, so try to avoid it.
        shrinkWrap: widget.shrinkWrap,
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
      getResult: () => result,
    );
  }
}
