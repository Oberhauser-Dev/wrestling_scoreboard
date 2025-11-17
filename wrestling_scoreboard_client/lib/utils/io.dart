import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

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

/// Regex to replace invalid filename characters and whitespace
final _invalidFileNameRegex = RegExp(r'[\\/:*?"<>|\s]');

extension FileNameExtension on String {
  String get sanitizedFileName => replaceAll(_invalidFileNameRegex, '-').trim();
}

Future<void> shareFileUri(Uri uri) async {
  if (isDesktop) {
    await launchUrl(uri);
  } else {
    await SharePlus.instance.share(ShareParams(uri: uri));
  }
}
