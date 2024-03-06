import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Preferences {
  static const keyLocale = 'locale';
  static const keyThemeMode = 'theme-mode';
  static const keyApiUrl = 'api-url';
  static const keyWsUrl = 'ws-url';
  static const keyApiProvider = 'api-provider';
  static const keyReportProvider = 'report-provider';

  /// Network timeout in milliseconds.
  static const keyNetworkTimeout = 'network-timeout';

  static const keyBellSound = 'bell-sound';
  static const keyFontFamily = 'font-family';

  static final StreamController<Locale?> onChangeLocale = StreamController.broadcast();
  static final StreamController<ThemeMode> onChangeThemeMode = StreamController.broadcast();
  static final StreamController<String> onChangeApiUrl = StreamController.broadcast();
  static final StreamController<String> onChangeWsUrlWebSocket = StreamController.broadcast();
  static final StreamController<WrestlingApiProvider?> onChangeApiProvider = StreamController.broadcast();
  static final StreamController<WrestlingReportProvider?> onChangeReportProvider = StreamController.broadcast();
  static final StreamController<Duration> onChangeNetworkTimeout = StreamController.broadcast();
  static final StreamController<String> onChangeBellSound = StreamController.broadcast();
  static final StreamController<String?> onChangeFontFamily = StreamController.broadcast();

  static final supportedLanguages = {
    const Locale('en', 'US'),
    const Locale('de', 'DE'),
  };

  static Future<void> setString(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  static Future<void> setInt(String key, int? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setInt(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  static Future<String?> getString(String key) => SharedPreferences.getInstance().then((value) => value.getString(key));

  static Future<int?> getInt(String key) => SharedPreferences.getInstance().then((value) => value.getInt(key));
}
