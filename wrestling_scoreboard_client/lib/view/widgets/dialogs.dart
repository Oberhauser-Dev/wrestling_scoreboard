import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';

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
