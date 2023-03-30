import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OkDialog<T extends Object?> extends StatelessWidget {
  final Widget child;
  final T Function() getResult;

  const OkDialog({required this.child, required this.getResult, Key? key}) : super(key: key);

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
          onPressed: () {
            Navigator.pop(context, getResult());
          },
          child: Text(localizations.ok),
        ),
      ],
    );
  }
}
