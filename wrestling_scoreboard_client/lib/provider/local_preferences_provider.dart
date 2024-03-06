import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'local_preferences_provider.g.dart';

/// Null value represents the system locale `Platform.localeName`.
@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Raw<Future<Locale?>> build() async {
    final localeStr = await Preferences.getString(Preferences.keyLocale);
    Locale? locale;
    if (localeStr != null) {
      final splits = localeStr.split('_');
      if (splits.length > 1) {
        locale = Locale(splits[0], splits[1]);
      } else {
        locale = Locale(splits[0]);
      }
    }
    Preferences.onChangeLocale.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return locale;
  }
}

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Raw<Future<ThemeMode>> build() async {
    final themeModeStr = await Preferences.getString(Preferences.keyThemeMode);
    ThemeMode themeMode;
    if (themeModeStr != null) {
      themeMode = ThemeMode.values.byName(themeModeStr);
    } else {
      themeMode = ThemeMode.system;
    }
    Preferences.onChangeThemeMode.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return themeMode;
  }
}

@Riverpod(keepAlive: true)
class FontFamilyNotifier extends _$FontFamilyNotifier {
  @override
  Raw<Future<String?>> build() async {
    final fontFamily = await Preferences.getString(Preferences.keyFontFamily);
    Preferences.onChangeFontFamily.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return fontFamily;
  }
}

@Riverpod(keepAlive: true)
class WebSocketUrlNotifier extends _$WebSocketUrlNotifier {
  @override
  Raw<Future<String>> build() async {
    var webSocketUrl = await Preferences.getString(Preferences.keyWsUrl);
    webSocketUrl ??= Env.webSocketUrl.fromString();
    Preferences.onChangeWsUrlWebSocket.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return webSocketUrl;
  }
}

@Riverpod(keepAlive: true)
class NetworkTimeoutNotifier extends _$NetworkTimeoutNotifier {
  @override
  Raw<Future<Duration>> build() async {
    var networkTimeout = await Preferences.getInt(Preferences.keyNetworkTimeout);
    Preferences.onChangeNetworkTimeout.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return Duration(milliseconds: networkTimeout ?? 10000);
  }
}

@Riverpod(keepAlive: true)
class ApiUrlNotifier extends _$ApiUrlNotifier {
  @override
  Raw<Future<String>> build() async {
    var apiUrl = await Preferences.getString(Preferences.keyApiUrl);
    apiUrl ??= Env.apiUrl.fromString();
    Preferences.onChangeApiUrl.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return apiUrl;
  }
}

@riverpod
class ApiProviderNotifier extends _$ApiProviderNotifier {
  @override
  Raw<Future<WrestlingApiProvider?>> build() async {
    Preferences.onChangeApiProvider.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    final apiProviderStr = await Preferences.getString(Preferences.keyApiProvider);
    final WrestlingApiProvider? apiProvider;
    if (apiProviderStr != null) {
      apiProvider = WrestlingApiProvider.values.byName(apiProviderStr);
    } else {
      apiProvider = null;
    }
    return apiProvider;
  }
}

@riverpod
class ReportProviderNotifier extends _$ReportProviderNotifier {
  @override
  Raw<Future<WrestlingReportProvider?>> build() async {
    Preferences.onChangeReportProvider.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    final apiProviderStr = await Preferences.getString(Preferences.keyReportProvider);
    final WrestlingReportProvider? apiProvider;
    if (apiProviderStr != null) {
      apiProvider = WrestlingReportProvider.values.byName(apiProviderStr);
    } else {
      apiProvider = null;
    }
    return apiProvider;
  }
}

@Riverpod(keepAlive: true)
class BellSoundNotifier extends _$BellSoundNotifier {
  @override
  Raw<Future<String>> build() async {
    var bellSoundPath = await Preferences.getString(Preferences.keyBellSound);
    bellSoundPath ??= Env.bellSoundPath.fromString();
    Preferences.onChangeBellSound.stream.distinct().listen((event) {
      state = Future.value(event);
    });
    return bellSoundPath;
  }
}
