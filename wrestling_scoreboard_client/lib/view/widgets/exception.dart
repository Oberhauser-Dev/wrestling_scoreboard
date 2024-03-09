import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';

class ExceptionWidget extends StatelessWidget {
  final Object exception;
  final StackTrace? stackTrace;
  final Function()? onRetry;

  const ExceptionWidget(this.exception, {this.onRetry, super.key, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PaddedCard(child: ExceptionInfo(exception, stackTrace: stackTrace, onRetry: onRetry)),
    );
  }
}

class ExceptionInfo extends StatelessWidget {
  final Object exception;
  final StackTrace? stackTrace;
  final Function()? onRetry;

  const ExceptionInfo(this.exception, {this.onRetry, super.key, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    String title;
    if (exception is RestException) {
      title = localizations.invalidParameterException;
    } else if (exception is SocketException) {
      title = localizations.noWebSocketConnection;
    } else {
      title = localizations.errorOccurred;
    }
    final disabledColor = Theme.of(context).disabledColor;

    final expansionTile = ExpansionTile(
      title: Text(title),
      childrenPadding: const EdgeInsets.all(16),
      children: [
        SelectableText(exception.toString(), style: TextStyle(color: disabledColor, fontSize: 14)),
        if (stackTrace != null)
          SelectableText(stackTrace!.toString(), style: TextStyle(color: disabledColor, fontSize: 11)),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        expansionTile,
        if (onRetry != null) const SizedBox(height: 16),
        if (onRetry != null) OutlinedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry))
      ],
    );
  }
}
