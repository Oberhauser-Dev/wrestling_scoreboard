import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum WrestlingStyle {
  free, // free style
  greco, // greco-roman style
}

styleToString(WrestlingStyle style, BuildContext context) {
  if (style == WrestlingStyle.free) return AppLocalizations.of(context)!.freeStyle;
  return AppLocalizations.of(context)!.freeStyle;
}
