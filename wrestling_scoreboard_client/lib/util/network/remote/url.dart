import 'dart:io';

import 'package:flutter/foundation.dart';

/// Adapts the Localhost String to Platform specific localhost (e.g. Android Emulator).
String adaptLocalhost(String url) {
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      url = url.replaceFirst('//localhost', '//10.0.2.2').replaceFirst('//127.0.0.1', '//10.0.2.2');
    }
  }
  return url;
}
