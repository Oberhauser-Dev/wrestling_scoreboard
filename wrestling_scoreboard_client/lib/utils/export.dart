import 'dart:io';
import 'dart:convert';

import 'package:wrestling_scoreboard_client/platform/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';

exportPNG(String fileName, Uint8List image) async {
  if (kIsWeb) {
    await _createOutputDownload(fileName, Uri.dataFromBytes(image as List<int>, mimeType: 'image/png'));
  } else {
    final outputFile = await _createOutputFile("$fileName.png");
    await outputFile?.writeAsBytes(image as List<int>);
  }
}

exportSQL(String fileName, String sqlString) async {
  if (kIsWeb) {
    await _createOutputDownload(fileName, Uri.dataFromString(sqlString, mimeType: 'application/sql', encoding: utf8));
  } else {
    String? outputPath = (await file_selector.getSaveLocation(suggestedName: fileName))?.path;
    if (outputPath != null) {
      final outputFile = await _createOutputFile("$fileName.sql");
      await outputFile?.writeAsString(sqlString, encoding: const Utf8Codec());
    }
  }
}

exportCSV(String fileName, List<String> table) async {
  String content = table.join('\n');

  if (kIsWeb) {
    await _createOutputDownload(fileName, Uri.dataFromString(content, mimeType: 'text/csv', encoding: utf8));
  } else {
    final outputFile = await _createOutputFile("$fileName.csv");
    await outputFile?.writeAsString(content, encoding: const Utf8Codec());
  }
}

Future<void> _createOutputDownload(String fileName, Uri fileData) async {
  html.AnchorElement()
    ..href = '$fileData'
    ..download = fileName
    ..style.display = 'none'
    ..click();
}

Future<File?> _createOutputFile(String fileName) async {
  String? filePath = await file_selector.getDirectoryPath();

  if (filePath == null) return null;
  return File("$filePath/$fileName");
}
