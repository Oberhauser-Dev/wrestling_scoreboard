import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
    return locale;
  }

  Future<void> setState(Locale? val) async {
    await Preferences.setString(Preferences.keyLocale, val?.toLanguageTag());
    state = Future.value(val);
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
    return themeMode;
  }

  Future<void> setState(ThemeMode val) async {
    await Preferences.setString(Preferences.keyThemeMode, val.name);
    state = Future.value(val);
  }
}

@Riverpod(keepAlive: true)
class FontFamilyNotifier extends _$FontFamilyNotifier {
  @override
  Raw<Future<String?>> build() async {
    final fontFamily = await Preferences.getString(Preferences.keyFontFamily);
    return fontFamily;
  }

  Future<void> setState(String? val) async {
    await Preferences.setString(Preferences.keyFontFamily, val);
    state = Future.value(val);
  }
}

@Riverpod(keepAlive: true)
class WebSocketUrlNotifier extends _$WebSocketUrlNotifier {
  @override
  Raw<Future<String>> build() async {
    var webSocketUrl = await Preferences.getString(Preferences.keyWsUrl);
    webSocketUrl ??= Env.webSocketUrl.fromString();
    return webSocketUrl;
  }

  Future<void> setState(String? val) async {
    await Preferences.setString(Preferences.keyWsUrl, val);
    state = Future.value(val);
  }
}

@Riverpod(keepAlive: true)
class NetworkTimeoutNotifier extends _$NetworkTimeoutNotifier {
  @override
  Raw<Future<Duration>> build() async {
    final networkTimeout = await Preferences.getInt(Preferences.keyNetworkTimeout);
    return Duration(milliseconds: networkTimeout ?? 10000);
  }

  Future<void> setState(Duration? val) async {
    Preferences.setInt(Preferences.keyNetworkTimeout, val?.inMilliseconds);
    state = Future.value(val);
  }
}

@Riverpod(keepAlive: true)
class ApiUrlNotifier extends _$ApiUrlNotifier {
  @override
  Raw<Future<String>> build() async {
    var apiUrl = await Preferences.getString(Preferences.keyApiUrl);
    apiUrl ??= Env.apiUrl.fromString();
    return apiUrl;
  }

  Future<void> setState(String? val) async {
    await Preferences.setString(Preferences.keyApiUrl, val);
    state = Future.value(val);
  }
}

@Riverpod()
class AppDataDirectoryNotifier extends _$AppDataDirectoryNotifier {
  @override
  Raw<Future<String?>> build() async {
    return await Preferences.getString(Preferences.keyAppDataDirectory) ?? (await _defaultDirectory());
  }

  Future<void> setState(String? val) async {
    await Preferences.setString(Preferences.keyAppDataDirectory, val);
    state = Future.value(val);
  }

  Future<void> resetState() async {
    await setState(await _defaultDirectory());
  }

  Future<String?> _defaultDirectory() async {
    if (kIsWeb) return null;
    return (await getApplicationSupportDirectory()).path;
  }
}

@Riverpod(keepAlive: true)
class BellSoundNotifier extends _$BellSoundNotifier {
  @override
  Raw<Future<String>> build() async {
    var bellSoundPath = await Preferences.getString(Preferences.keyBellSound);
    bellSoundPath ??= Env.bellSoundPath.fromString();
    return bellSoundPath;
  }

  Future<void> setState(String? val) async {
    await Preferences.setString(Preferences.keyBellSound, val);
    state = Future.value(val);
  }
}

@Riverpod(keepAlive: true)
class TimeCountDownNotifier extends _$TimeCountDownNotifier {
  @override
  Raw<Future<bool>> build() async {
    var timeCountDown = await Preferences.getBool(Preferences.keyTimeCountDown);
    timeCountDown ??= Env.timeCountDown.fromBool();
    return timeCountDown;
  }

  Future<void> setState(bool? val) async {
    await Preferences.setBool(Preferences.keyTimeCountDown, val);
    state = Future.value(val);
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
    final preferenceList =
        favorites.entries.map((e) {
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

@riverpod
class OrgAuthNotifier extends _$OrgAuthNotifier {
  @override
  Raw<Future<Map<int, AuthService>>> build() async {
    final orgAuthStrList = await Preferences.getStringList(Preferences.keyOrganizationAuth);
    try {
      final orgAuths = (orgAuthStrList ?? []).map((rawStr) {
        final parts = rawStr.split('=');
        final orgId = int.parse(parts[0]);
        final authTypeStr = parts[1];
        final authType = getTypeFromTableName(authTypeStr);
        final authJson = jsonDecode(Uri.decodeFull(parts[2]));
        final authService = switch (authType) {
          const (BasicAuthService) => BasicAuthService.fromJson(authJson),
          _ => throw UnimplementedError('AuthService $authTypeStr not known'),
        };
        return MapEntry(orgId, authService);
      });
      return Map.fromEntries(orgAuths);
    } on UnimplementedError catch (e) {
      debugPrint((e.message ?? e.toString()) + e.stackTrace.toString());
      await Preferences.setStringList(Preferences.keyOrganizationAuth, []);
    }
    return {};
  }

  Future<void> _setOrgAuthServices(Map<int, AuthService> orgAuthServices) async {
    state = Future.value(orgAuthServices);
    final orgAuthList =
        orgAuthServices.entries.map((e) {
          final authService = e.value;
          final String authType;
          final String authJson;
          if (authService is BasicAuthService) {
            authType = getTableNameFromType(BasicAuthService);
            authJson = Uri.encodeFull(jsonEncode(authService.toJson()));
          } else {
            throw UnimplementedError('AuthService ${e.runtimeType} not known');
          }
          return '${e.key}=$authType=$authJson';
        }).toList();
    // TODO: use secure storage: https://pub.dev/packages/flutter_secure_storage
    await Preferences.setStringList(Preferences.keyOrganizationAuth, orgAuthList);
  }

  void addOrgAuthService(int id, AuthService authService) async {
    final authServiceMap = await state;
    authServiceMap[id] = authService;
    await _setOrgAuthServices(authServiceMap);
  }

  void removeOrgAuthService(int id) async {
    final authServiceMap = await state;
    authServiceMap.remove(id);
    await _setOrgAuthServices(authServiceMap);
  }
}

@Riverpod(keepAlive: true)
class ProposeApiImportDurationNotifier extends _$ProposeApiImportDurationNotifier {
  @override
  Raw<Future<Duration>> build() async {
    final proposeApiImportDurationSecs = await Preferences.getInt(Preferences.keyProposeApiImportDuration);
    return proposeApiImportDurationSecs != null
        ? Duration(seconds: proposeApiImportDurationSecs)
        : const Duration(days: 2);
  }

  Future<void> setState(Duration? val) async {
    Preferences.setInt(Preferences.keyProposeApiImportDuration, val?.inSeconds);
    state = Future.value(val);
  }
}

@Riverpod(keepAlive: true)
class JwtNotifier extends _$JwtNotifier {
  @override
  Raw<Future<String?>> build() async {
    return await Preferences.getString(Preferences.keyJwtToken);
  }

  Future<void> setState(String? val) async {
    // TODO: use secure storage: https://pub.dev/packages/flutter_secure_storage
    await Preferences.setString(Preferences.keyJwtToken, val);
    state = Future.value(val);
  }
}
