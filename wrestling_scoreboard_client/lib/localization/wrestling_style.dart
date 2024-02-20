import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension WrestlingStyleLocalization on WrestlingStyle {
  localize(BuildContext context) {
    if (this == WrestlingStyle.free) return AppLocalizations.of(context)!.freeStyle;
    return AppLocalizations.of(context)!.grecoRoman;
  }

  abbreviation(BuildContext context) {
    if (this == WrestlingStyle.free) return AppLocalizations.of(context)!.freeStyleAbbr;
    return AppLocalizations.of(context)!.grecoRomanAbbr;
  }
}
