extension FileNameDateTimeParser on DateTime {
  String toFileNameDateFormat() => toIso8601String().substring(0, 10);

  String toFileNameDateTimeFormat() => toIso8601String().replaceAll(':', '-').replaceAll(RegExp(r'\.[0-9]+'), '');

  String toFileNameDateTimeMillisFormat() => toIso8601String().replaceAll(':', '-').replaceAll('.', '-');

  static DateTime? tryParse(String dateStr) {
    if (dateStr.length > 10) {
      if (dateStr.length > 20) {
        dateStr = dateStr.substring(0, 19) + dateStr.substring(19).replaceAll('-', ':');
      }
      dateStr = dateStr.substring(0, 10) + dateStr.substring(10).replaceAll('-', ':');
    }
    return DateTime.tryParse(dateStr);
  }
}
