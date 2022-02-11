import 'dart:async';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const keyLocale = 'locale';
  static const keyApiUrl = 'api-url';
  static const keyWsUrl = 'ws-url';
  static const keyBellSound = 'bell-sound';

  static final StreamController<Locale?> onChangeLocale = StreamController.broadcast();
  static final StreamController<String> onChangeApiUrl = StreamController.broadcast();
  static final StreamController<String> onChangeWsUrlWebSocket = StreamController.broadcast();
  static final StreamController<String> onChangeBellSound = StreamController.broadcast();

  static final supportedLanguages = {
    'en_US': const Locale('en', 'US'),
    'de_DE': const Locale('de', 'DE'),
  };

  static Future<void> setString(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if(value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }
  
  static Future<String?> getString(String key) => SharedPreferences.getInstance().then((value) => value.getString(key));
}
