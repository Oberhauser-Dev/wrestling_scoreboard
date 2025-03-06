import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';

extension AppLocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
