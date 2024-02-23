import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toDateString(BuildContext context) {
    return toDateStringFromLocaleName(Localizations.localeOf(context).toLanguageTag());
  }

  String toDateStringFromLocaleName(String localeName) {
    return DateFormat.yMMMd(localeName).format(this);
  }

  String toTimeString(BuildContext context) {
    return toTimeStringFromLocaleName(Localizations.localeOf(context).toLanguageTag());
  }

  String toTimeStringFromLocaleName(String localeName) {
    return DateFormat.Hm(localeName).format(this);
  }

  String toDateTimeString(BuildContext context) {
    return toDateTimeStringFromLocaleName(Localizations.localeOf(context).toLanguageTag());
  }

  String toDateTimeStringFromLocaleName(String localeName) {
    return DateFormat.yMMMd(localeName).add_Hm().format(this);
  }
}
