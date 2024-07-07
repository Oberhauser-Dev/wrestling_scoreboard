import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/duration_picker.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class SizedDialog extends StatelessWidget {
  /// Do not wrap this into a column with shrinkwrap, so that ListViews act dynamically.
  const SizedDialog({
    super.key,
    required this.actions,
    required this.child,
    this.isScrollable = true,
  });

  final List<Widget> actions;
  final Widget child;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        child: isScrollable ? SingleChildScrollView(child: child) : child,
      ),
      actions: actions,
    );
  }
}

class OkDialog extends StatelessWidget {
  final Widget child;

  const OkDialog({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SizedDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.ok),
        ),
      ],
      child: child,
    );
  }
}

Future<void> showOkDialog({required BuildContext context, required Widget child}) async {
  await showDialog(
    context: context,
    builder: (context) => OkDialog(
      child: child,
    ),
  );
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
    final localizations = AppLocalizations.of(context)!;
    return SizedDialog(
      isScrollable: isScrollable,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, getResult()),
          child: Text(okText ?? localizations.ok),
        ),
      ],
      child: child,
    );
  }
}

Future<T?> showOkCancelDialog<T>({
  required BuildContext context,
  required Widget child,
  required T Function() getResult,
  String? okText,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (context) => OkCancelDialog<T>(
      getResult: getResult,
      okText: okText,
      child: child,
    ),
  );
}

Future<void> showExceptionDialog({
  required BuildContext context,
  required Object exception,
  required StackTrace? stackTrace,
  Function()? onRetry,
}) async {
  if (onRetry == null) {
    return await showOkDialog(
      context: context,
      child: ExceptionInfo(
        exception,
        stackTrace: stackTrace,
      ),
    );
  }
  await showOkCancelDialog(
    context: context,
    getResult: onRetry,
    okText: AppLocalizations.of(context)!.retry,
    child: ExceptionInfo(
      exception,
      stackTrace: stackTrace,
    ),
  );
}

Future<void> showLoadingDialog({
  required BuildContext context,
  required Future<void> Function(BuildContext context) runAsync,
}) async {
  showDialog(
    useRootNavigator: false, // Pop from outside of this dialog.
    context: context,
    barrierDismissible: false,
    builder: (context) => ResponsiveContainer(
      child: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.syncWithApiProvider),
            const Center(child: CircularProgressIndicator()),
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

Future<void> catchAsync(
  BuildContext context,
  Future<void> Function() doAsync, {
  Function()? onRetry,
}) async {
  try {
    await doAsync();
  } catch (exception, stackTrace) {
    if (context.mounted) {
      await showExceptionDialog(context: context, exception: exception, stackTrace: stackTrace, onRetry: onRetry);
    }
  }
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
      getResult: () => result,
    );
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
        getResult: () => result);
  }
}
