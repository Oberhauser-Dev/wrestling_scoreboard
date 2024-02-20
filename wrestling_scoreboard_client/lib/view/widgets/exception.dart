import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';

class ExceptionWidget extends StatelessWidget {
  final Object exception;
  final Function()? onRetry;

  const ExceptionWidget(this.exception, {this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    final errorText = exception is SocketException
        ? SelectableText(
            AppLocalizations.of(context)!.noWebSocketConnection,
          )
        : SelectableText(exception.toString(), style: TextStyle(color: Theme.of(context).colorScheme.error));
    return Center(
      child: PaddedCard(
        child: Wrap(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              errorText,
              if (onRetry != null) const SizedBox(height: 16),
              if (onRetry != null) OutlinedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry))
            ],
          ),
        ]),
      ),
    );
  }
}
