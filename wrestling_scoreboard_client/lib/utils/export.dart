import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';
import 'package:wrestling_scoreboard_client/platform/none.dart'
    if (dart.library.js_interop) 'package:web/web.dart'
    as web;
import 'package:wrestling_scoreboard_client/view/utils.dart';

Future<void> exportPNG({required String fileBaseName, required Uint8List image}) async {
  await downloadSelector(content: image, fileExtension: 'png', fileBaseName: fileBaseName, mimeType: 'image/png');
}

Future<void> exportSQL({required String fileBaseName, required String sqlString}) async {
  await downloadSelector(
    content: sqlString,
    fileExtension: 'sql',
    fileBaseName: fileBaseName,
    mimeType: 'application/sql',
  );
}

Future<void> exportRDB({required String fileBaseName, required String rdbString}) async {
  await downloadSelector(
    content: rdbString,
    fileExtension: 'rdb',
    fileBaseName: fileBaseName,
    mimeType: 'text/rdb',
    encoding: latin1,
  );
}

/// Exports a [table] (list of rows) as CSV to the specified [fileBaseName] (without extension).
Future<void> exportCSV({required String fileBaseName, required List<List<dynamic>> table}) async {
  const converter = ListToCsvConverter();
  final content = converter.convert(table);
  await downloadSelector(content: content, fileExtension: 'csv', fileBaseName: fileBaseName, mimeType: 'text/csv');
}

Future<void> downloadSelector<T>({
  required T content,
  required String mimeType,
  required String fileBaseName,
  required String fileExtension,
  Encoding encoding = utf8,
}) async {
  final fileName = '$fileBaseName.$fileExtension';
  if (kIsWeb) {
    final Uri uri;
    if (content is String) {
      uri = Uri.dataFromString(content, mimeType: mimeType, encoding: encoding);
    } else if (content is List<int>) {
      uri = Uri.dataFromBytes(content, mimeType: mimeType);
    } else {
      throw UnimplementedError('Data type not supported: $T');
    }
    web.HTMLAnchorElement()
      ..href = uri.toString()
      ..download = fileName
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath;
    if (isDesktop) {
      outputPath = (await file_selector.getSaveLocation(suggestedName: fileName))?.path;
    } else {
      // TODO: Not supported on iOS yet: https://github.com/flutter/flutter/issues/111583
      final String? filePath = await file_selector.getDirectoryPath();
      if (filePath == null) return;
      outputPath = '$filePath/$fileName';
    }
    if (outputPath == null) return;
    final outputFile = File(outputPath);

    if (content is String) {
      await outputFile.writeAsString(content, encoding: encoding);
    } else if (content is List<int>) {
      await outputFile.writeAsBytes(content);
    } else {
      throw UnimplementedError('Data type not supported: $T');
    }
  }
}
