import 'package:flutter/cupertino.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_common/common.dart';

extension WrestlingStyleLocalization on WrestlingStyle {
  localize(BuildContext context) {
    if (this == WrestlingStyle.free) return context.l10n.freeStyle;
    return context.l10n.grecoRoman;
  }

  abbreviation(BuildContext context) {
    if (this == WrestlingStyle.free) return context.l10n.freeStyleAbbr;
    return context.l10n.grecoRomanAbbr;
  }
}
