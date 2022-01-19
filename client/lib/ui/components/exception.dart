import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExceptionWidget extends StatelessWidget {
  final Object exception;
  final Function() onRetry;

  const ExceptionWidget(this.exception, this.onRetry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorText = exception is SocketException
        ? SelectableText(
            AppLocalizations.of(context)!.noWebSocketConnection,
          )
        : SelectableText(exception.toString(), style: TextStyle(color: Theme.of(context).errorColor));
    return Center(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                errorText,
                const SizedBox(height: 16),
                OutlinedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry))
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
