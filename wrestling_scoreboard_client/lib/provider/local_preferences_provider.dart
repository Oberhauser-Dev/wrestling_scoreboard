import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/utils/environment.dart';

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

@Riverpod(keepAlive: true)
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  Raw<Future<Map<String, Set<int>>>> build() async {
    final favoriteStrList = await Preferences.getStringList(Preferences.keyFavorites);
    final favorites = (favoriteStrList ?? []).map((rawStr) {
      final parts = rawStr.split('=');
      return MapEntry(parts[0], parts[1].split(',').map((e) => int.parse(e)).toSet());
    });
    return Map.fromEntries(favorites);
  }

  Future<void> _setFavorites(Map<String, Set<int>> favorites) async {
    state = Future.value(favorites);
    final preferenceList = favorites.entries.map((e) {
      return '${e.key}=${e.value.join(',')}';
    }).toList();
    await Preferences.setStringList(Preferences.keyFavorites, preferenceList);
  }

  void addFavorite(String tableName, int id) async {
    final favorites = await state;
    favorites.putIfAbsent(tableName, () => {});
    favorites[tableName]?.add(id);
    await _setFavorites(favorites);
  }

  void removeFavorite(String tableName, int id) async {
    final favorites = await state;
    favorites[tableName]?.remove(id);
    if (favorites[tableName]?.isEmpty ?? false) {
      favorites.remove(tableName);
    }
    await _setFavorites(favorites);
  }
}
