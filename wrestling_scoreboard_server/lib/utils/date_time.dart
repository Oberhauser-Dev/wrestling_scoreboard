import 'package:timezone/timezone.dart' as tz;

extension DateTimeExt on DateTime {
  DateTime fromLocation(tz.Location location) {
    return tz.TZDateTime(location, year, month, day, hour, minute, second, millisecond, microsecond).native;
  }
}
