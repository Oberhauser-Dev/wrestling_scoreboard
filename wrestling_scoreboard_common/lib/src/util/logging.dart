import 'package:logging/logging.dart';

extension LogRecordExtension on LogRecord {
  String get formatted {
    String text = '[$time] ${level.name}: $message';
    if (error != null) {
      text += '\nError: $error';
      if (stackTrace != null) {
        text += 'StackTrace: $stackTrace';
      }
    }
    text = switch (level) {
      Level.FINEST => '\x1B[38;5;247m$text\x1B[0m',
      Level.FINER => '\x1B[38;5;248m$text\x1B[0m',
      Level.FINE => '\x1B[38;5;249m$text\x1B[0m',
      Level.CONFIG => '\x1B[34m$text\x1B[0m',
      Level.WARNING => '\x1B[33m$text\x1B[0m',
      Level.SEVERE || Level.SHOUT => '\x1B[31m$text\x1B[0m',
      _ => text,
    };
    return text;
  }
}
