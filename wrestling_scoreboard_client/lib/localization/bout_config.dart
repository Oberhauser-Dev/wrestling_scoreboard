import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/duration.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension BoutConfigLocalization on BoutConfig {
  String localize(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return '# $id | ${localizations.periodCount}: $periodCount, '
        '${localizations.periodDuration}: ${periodDuration.formatMinutesAndSeconds()}, '
        '${localizations.injuryDuration}: ${injuryDuration?.formatMinutesAndSeconds() ?? '-'}, '
        '${localizations.activityDuration}: ${activityDuration?.formatMinutesAndSeconds() ?? '-'}, '
        '${localizations.breakDuration}: ${breakDuration.formatMinutesAndSeconds()}';
  }
}
