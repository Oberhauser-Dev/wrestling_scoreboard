import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toDateString(BuildContext context) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(this);
  }

  String toTimeString(BuildContext context) {
    return DateFormat.Hm(Localizations.localeOf(context).toLanguageTag()).format(this);
  }

  String toDateTimeString(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return '${DateFormat.yMMMd(locale.toLanguageTag()).format(this)} ${DateFormat.Hm(locale.toLanguageTag()).format(this)}';
  }
}
