import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

styleToString(WrestlingStyle style, BuildContext context) {
  if (style == WrestlingStyle.free) return AppLocalizations.of(context)!.freeStyle;
  return AppLocalizations.of(context)!.grecoRoman;
}

styleToAbbr(WrestlingStyle style, BuildContext context) {
  if (style == WrestlingStyle.free) return AppLocalizations.of(context)!.freeStyleAbbr;
  return AppLocalizations.of(context)!.grecoRomanAbbr;
}
