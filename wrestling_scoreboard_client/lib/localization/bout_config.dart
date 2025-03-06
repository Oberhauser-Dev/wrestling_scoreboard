import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutConfigLocalization on BoutConfig {
  String localize(BuildContext context) {
    final localizations = context.l10n;
    return '# $id | ${localizations.periodCount}: $periodCount, '
        '${localizations.periodDuration}: ${periodDuration.formatMinutesAndSeconds()}, '
        '${localizations.injuryDuration}: ${injuryDuration?.formatMinutesAndSeconds() ?? '-'}, '
        '${localizations.activityDuration}: ${activityDuration?.formatMinutesAndSeconds() ?? '-'}, '
        '${localizations.breakDuration}: ${breakDuration.formatMinutesAndSeconds()}';
  }
}
