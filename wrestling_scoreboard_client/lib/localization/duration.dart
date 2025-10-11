import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';

extension DurationLocalization on Duration {
  String formatDaysHoursMinutes(BuildContext context) {
    final localizations = context.l10n;
    return '$inDays ${localizations.days}, ${inHours.remainder(24).toString().padLeft(2, '0')}:${inMinutes.remainder(60).toString().padLeft(2, '0')}';
  }

  String formatMinutesAndSeconds() {
    return '$inMinutes:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  String formatSecondsAndMilliseconds() {
    return '$inSeconds.${inMilliseconds.remainder(1000).toString().padLeft(3, '0')}s';
  }

  String formatMinutesAndSecondsAndMilliseconds() {
    return '$inMinutes:${inSeconds.remainder(60).toString().padLeft(2, '0')}.${inMilliseconds.remainder(1000).toString().padLeft(3, '0')}s';
  }

  String formatDeciSeconds() {
    return (inMilliseconds.remainder(1000) / 100).toInt().toString();
  }
}
