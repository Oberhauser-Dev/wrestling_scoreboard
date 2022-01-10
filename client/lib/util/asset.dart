import 'dart:convert';

import 'package:flutter/services.dart';

Future<List<String>> getAssetList({String prefix = '', String filetype = ''}) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final imagePaths = manifestMap.keys
      .where((String key) => key.startsWith(prefix))
      .where((String key) => key.endsWith(filetype))
      .toList();

  return imagePaths;
}
