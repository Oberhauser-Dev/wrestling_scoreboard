import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';
import 'package:wrestling_scoreboard_client/platform/html.dart' if (dart.library.html) 'dart:html' as html;
import 'package:wrestling_scoreboard_client/view/utils.dart';

exportPNG({required String fileName, required Uint8List image}) async {
  await _createOutputDownload(
    content: image,
    fileExtension: 'png',
    fileName: fileName,
    mimeType: 'image/png',
  );
}

exportSQL({required String fileName, required String sqlString}) async {
  await _createOutputDownload(
    content: sqlString,
    fileExtension: 'sql',
    fileName: fileName,
    mimeType: 'application/sql',
  );
}

/// Exports a [table] (list of rows) as CSV to the specified [fileName] (without extension).
exportCSV({required String fileName, required List<List<dynamic>> table}) async {
  const converter = ListToCsvConverter();
  final content = converter.convert(table);
  await _createOutputDownload(
    content: content,
    fileExtension: 'csv',
    fileName: fileName,
    mimeType: 'text/csv',
  );
}

Future<void> _createOutputDownload<T>({
  required T content,
  required String mimeType,
  required String fileName,
  required String fileExtension,
}) async {
  if (kIsWeb) {
    final Uri uri;
    if (content is String) {
      uri = Uri.dataFromString(content, mimeType: mimeType, encoding: utf8);
    } else if (content is List<int>) {
      uri = Uri.dataFromBytes(content, mimeType: mimeType);
    } else {
      throw UnimplementedError('Data type not supported: $T');
    }
    html.AnchorElement()
      ..href = uri.toString()
      ..download = fileName
      ..style.display = 'none'
      ..click();
  } else {
    String? outputPath;
    if (isDesktop) {
      outputPath = (await file_selector.getSaveLocation(suggestedName: '$fileName.$fileExtension'))?.path;
    } else {
      // TODO: Not supported on iOS yet: https://github.com/flutter/flutter/issues/111583
      String? filePath = await file_selector.getDirectoryPath();
      if (filePath == null) return;
      outputPath = '$filePath/$fileName.$fileExtension';
    }
    if (outputPath == null) return;
    final outputFile = File(outputPath);

    if (content is String) {
      await outputFile.writeAsString(content, encoding: const Utf8Codec());
    } else if (content is List<int>) {
      await outputFile.writeAsBytes(content);
    } else {
      throw UnimplementedError('Data type not supported: $T');
    }
  }
}
