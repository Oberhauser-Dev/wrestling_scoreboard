import 'dart:io';
import 'dart:convert';

import 'package:wrestling_scoreboard_client/platform/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';

exportPNG(String filename, Uint8List image) async {
  if (kIsWeb) {
    html.AnchorElement()
      ..href = '${Uri.dataFromBytes(image as List<int>, mimeType: 'image/png')}'
      ..download = filename
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath = (await file_selector.getSaveLocation(suggestedName: filename))?.path;
    if (outputPath != null) {
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(image as List<int>);
    }
  }
}

exportSQL(String fileName, String sqlString) async {
  if (kIsWeb) {
    html.AnchorElement()
      ..href = '${Uri.dataFromString(sqlString, mimeType: 'application/sql', encoding: utf8)}'
      ..download = fileName
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath = (await file_selector.getSaveLocation(suggestedName: fileName))?.path;
    if (outputPath != null) {
      final outputFile = File(outputPath);
      await outputFile.writeAsString(sqlString, encoding: const Utf8Codec());
    }
  }
}

exportCSV(String fileName, List<String> table) async {
  String content = table.join('\n');

  if (kIsWeb) {
    html.AnchorElement()
      ..href = '${Uri.dataFromString(content, mimeType: 'text/csv', encoding: utf8)}'
      ..download = fileName
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath = (await file_selector.getSaveLocation(suggestedName: fileName))?.path;
    if (outputPath != null) {
      final outputFile = File(outputPath);
      await outputFile.writeAsString(content, encoding: const Utf8Codec());
    }
  }
}
