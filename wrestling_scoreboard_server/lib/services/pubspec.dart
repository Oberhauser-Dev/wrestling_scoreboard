import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:wrestling_scoreboard_server/services/base_dir.dart';

Pubspec? pubspec;

Future<Pubspec> parsePubspec() async {
  if (pubspec == null) {
    final file = File(resolvePath('pubspec.yaml'));
    if (await file.exists()) {
      pubspec = Pubspec.parse(await file.readAsString());
    } else {
      throw FileSystemException('No file found', file.absolute.path);
    }
  }
  return pubspec!;
}
