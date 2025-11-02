import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const keyLocale = 'locale';
  static const keyThemeMode = 'theme-mode';
  static const keyApiUrl = 'api-url';
  static const keyWsUrl = 'ws-url';
  static const keyWebClientUrl = 'web-client-url';
  static const keyAppDataDirectory = 'app-data-directory';

  /// Network timeout in milliseconds.
  static const keyNetworkTimeout = 'network-timeout';

  static const keyProposeApiImportDuration = 'propose-api-import-duration';

  static const keyBellSound = 'bell-sound';
  static const keyTimeCountDown = 'time-count-down';
  static const keySmartBoutActions = 'smart-bout-actions';
  static const keyTeamMatchChronologicalSort = 'team-match-chronological-sort';

  static const keyFontFamily = 'font-family';
  static const keyFavorites = 'favorites';
  static const keyOrganizationAuth = 'org-auth';
  static const keyJwtToken = 'jwt';
  static const keyDataSuffix = '-data';

  static const keyBackupEnabled = 'backup-enabled';
  static const keyBackupRules = 'backup-rules';

  static final supportedLanguages = {const Locale('en', 'US'), const Locale('de', 'DE')};

  static Future<void> setString(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  static Future<void> setBool(String key, bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setBool(key, value);
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

  static Future<void> setStringList(String key, List<String>? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setStringList(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  static Future<String?> getString(String key) => SharedPreferences.getInstance().then((value) => value.getString(key));

  static Future<bool?> getBool(String key) => SharedPreferences.getInstance().then((value) => value.getBool(key));

  static Future<int?> getInt(String key) => SharedPreferences.getInstance().then((value) => value.getInt(key));

  static Future<List<String>?> getStringList(String key) =>
      SharedPreferences.getInstance().then((value) => value.getStringList(key));
}
