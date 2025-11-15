// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Null value represents the system locale `Platform.localeName`.

@ProviderFor(LocaleNotifier)
const localeProvider = LocaleNotifierProvider._();

/// Null value represents the system locale `Platform.localeName`.
final class LocaleNotifierProvider extends $NotifierProvider<LocaleNotifier, Raw<Future<Locale?>>> {
  /// Null value represents the system locale `Platform.localeName`.
  const LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Locale?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<Locale?>>>(value));
  }
}

String _$localeNotifierHash() => r'bb11642ed6d1ecce845d2d6f67b79020c8d3ec70';

/// Null value represents the system locale `Platform.localeName`.

abstract class _$LocaleNotifier extends $Notifier<Raw<Future<Locale?>>> {
  Raw<Future<Locale?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Locale?>>, Raw<Future<Locale?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<Locale?>>, Raw<Future<Locale?>>>,
              Raw<Future<Locale?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ThemeModeNotifier)
const themeModeProvider = ThemeModeNotifierProvider._();

final class ThemeModeNotifierProvider extends $NotifierProvider<ThemeModeNotifier, Raw<Future<ThemeMode>>> {
  const ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<ThemeMode>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<ThemeMode>>>(value));
  }
}

String _$themeModeNotifierHash() => r'87a0d4c71b037664266350d35d9e4c54be1d1dd8';

abstract class _$ThemeModeNotifier extends $Notifier<Raw<Future<ThemeMode>>> {
  Raw<Future<ThemeMode>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<ThemeMode>>, Raw<Future<ThemeMode>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<ThemeMode>>, Raw<Future<ThemeMode>>>,
              Raw<Future<ThemeMode>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FontFamilyNotifier)
const fontFamilyProvider = FontFamilyNotifierProvider._();

final class FontFamilyNotifierProvider extends $NotifierProvider<FontFamilyNotifier, Raw<Future<String?>>> {
  const FontFamilyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fontFamilyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fontFamilyNotifierHash();

  @$internal
  @override
  FontFamilyNotifier create() => FontFamilyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String?>>>(value));
  }
}

String _$fontFamilyNotifierHash() => r'58f6c3cdeafa1c63986ffa5ad4de5ca9b8865b64';

abstract class _$FontFamilyNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String?>>, Raw<Future<String?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String?>>, Raw<Future<String?>>>,
              Raw<Future<String?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WebSocketUrlNotifier)
const webSocketUrlProvider = WebSocketUrlNotifierProvider._();

final class WebSocketUrlNotifierProvider extends $NotifierProvider<WebSocketUrlNotifier, Raw<Future<String>>> {
  const WebSocketUrlNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webSocketUrlNotifierHash();

  @$internal
  @override
  WebSocketUrlNotifier create() => WebSocketUrlNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String>>>(value));
  }
}

String _$webSocketUrlNotifierHash() => r'5ce30ab4662573783d643e996d3eb8c14ac58127';

abstract class _$WebSocketUrlNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String>>, Raw<Future<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String>>, Raw<Future<String>>>,
              Raw<Future<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// The url used to host the client for web. This can be unset.
/// It is used for sharing the web url on native platforms.

@ProviderFor(WebClientUrlNotifier)
const webClientUrlProvider = WebClientUrlNotifierProvider._();

/// The url used to host the client for web. This can be unset.
/// It is used for sharing the web url on native platforms.
final class WebClientUrlNotifierProvider extends $NotifierProvider<WebClientUrlNotifier, Raw<Future<String?>>> {
  /// The url used to host the client for web. This can be unset.
  /// It is used for sharing the web url on native platforms.
  const WebClientUrlNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webClientUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webClientUrlNotifierHash();

  @$internal
  @override
  WebClientUrlNotifier create() => WebClientUrlNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String?>>>(value));
  }
}

String _$webClientUrlNotifierHash() => r'defe83fe084e8c4f5faa2eb219ad1393bc5b2f0b';

/// The url used to host the client for web. This can be unset.
/// It is used for sharing the web url on native platforms.

abstract class _$WebClientUrlNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String?>>, Raw<Future<String?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String?>>, Raw<Future<String?>>>,
              Raw<Future<String?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NetworkTimeoutNotifier)
const networkTimeoutProvider = NetworkTimeoutNotifierProvider._();

final class NetworkTimeoutNotifierProvider extends $NotifierProvider<NetworkTimeoutNotifier, Raw<Future<Duration>>> {
  const NetworkTimeoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkTimeoutProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkTimeoutNotifierHash();

  @$internal
  @override
  NetworkTimeoutNotifier create() => NetworkTimeoutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Duration>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<Duration>>>(value));
  }
}

String _$networkTimeoutNotifierHash() => r'22636b6e9a26d31205f86686c2447bd0cf119568';

abstract class _$NetworkTimeoutNotifier extends $Notifier<Raw<Future<Duration>>> {
  Raw<Future<Duration>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Duration>>, Raw<Future<Duration>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<Duration>>, Raw<Future<Duration>>>,
              Raw<Future<Duration>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ApiUrlNotifier)
const apiUrlProvider = ApiUrlNotifierProvider._();

final class ApiUrlNotifierProvider extends $NotifierProvider<ApiUrlNotifier, Raw<Future<String>>> {
  const ApiUrlNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiUrlNotifierHash();

  @$internal
  @override
  ApiUrlNotifier create() => ApiUrlNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String>>>(value));
  }
}

String _$apiUrlNotifierHash() => r'e20d0738971e4b3e4feab8f78df0ce44e7b29e78';

abstract class _$ApiUrlNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String>>, Raw<Future<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String>>, Raw<Future<String>>>,
              Raw<Future<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AppDataDirectoryNotifier)
const appDataDirectoryProvider = AppDataDirectoryNotifierProvider._();

final class AppDataDirectoryNotifierProvider extends $NotifierProvider<AppDataDirectoryNotifier, Raw<Future<String?>>> {
  const AppDataDirectoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDataDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDataDirectoryNotifierHash();

  @$internal
  @override
  AppDataDirectoryNotifier create() => AppDataDirectoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String?>>>(value));
  }
}

String _$appDataDirectoryNotifierHash() => r'022f78583c7bfd8314c2c42aec93793474f2ec0d';

abstract class _$AppDataDirectoryNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String?>>, Raw<Future<String?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String?>>, Raw<Future<String?>>>,
              Raw<Future<String?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BellSoundNotifier)
const bellSoundProvider = BellSoundNotifierProvider._();

final class BellSoundNotifierProvider extends $NotifierProvider<BellSoundNotifier, Raw<Future<String>>> {
  const BellSoundNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bellSoundProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bellSoundNotifierHash();

  @$internal
  @override
  BellSoundNotifier create() => BellSoundNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String>>>(value));
  }
}

String _$bellSoundNotifierHash() => r'44cc9ac294b4cf03b9ddeeb822cb5985d3c8cfe3';

abstract class _$BellSoundNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String>>, Raw<Future<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String>>, Raw<Future<String>>>,
              Raw<Future<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TimeCountDownNotifier)
const timeCountDownProvider = TimeCountDownNotifierProvider._();

final class TimeCountDownNotifierProvider extends $NotifierProvider<TimeCountDownNotifier, Raw<Future<bool>>> {
  const TimeCountDownNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeCountDownProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timeCountDownNotifierHash();

  @$internal
  @override
  TimeCountDownNotifier create() => TimeCountDownNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<bool>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<bool>>>(value));
  }
}

String _$timeCountDownNotifierHash() => r'2ad9751aa977e4c757f46b66218f47618a882fbd';

abstract class _$TimeCountDownNotifier extends $Notifier<Raw<Future<bool>>> {
  Raw<Future<bool>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<bool>>, Raw<Future<bool>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<bool>>, Raw<Future<bool>>>,
              Raw<Future<bool>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SmartBoutActionsNotifier)
const smartBoutActionsProvider = SmartBoutActionsNotifierProvider._();

final class SmartBoutActionsNotifierProvider extends $NotifierProvider<SmartBoutActionsNotifier, Raw<Future<bool>>> {
  const SmartBoutActionsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartBoutActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartBoutActionsNotifierHash();

  @$internal
  @override
  SmartBoutActionsNotifier create() => SmartBoutActionsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<bool>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<bool>>>(value));
  }
}

String _$smartBoutActionsNotifierHash() => r'ec4837e01a554e7c4be0d70748fe3f8351de38f4';

abstract class _$SmartBoutActionsNotifier extends $Notifier<Raw<Future<bool>>> {
  Raw<Future<bool>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<bool>>, Raw<Future<bool>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<bool>>, Raw<Future<bool>>>,
              Raw<Future<bool>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TeamMatchChronologicalSortNotifier)
const teamMatchChronologicalSortProvider = TeamMatchChronologicalSortNotifierProvider._();

final class TeamMatchChronologicalSortNotifierProvider
    extends $NotifierProvider<TeamMatchChronologicalSortNotifier, Raw<Future<bool>>> {
  const TeamMatchChronologicalSortNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamMatchChronologicalSortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamMatchChronologicalSortNotifierHash();

  @$internal
  @override
  TeamMatchChronologicalSortNotifier create() => TeamMatchChronologicalSortNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<bool>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<bool>>>(value));
  }
}

String _$teamMatchChronologicalSortNotifierHash() => r'baefe43c1be14b4fd1281e3660122e8b69588720';

abstract class _$TeamMatchChronologicalSortNotifier extends $Notifier<Raw<Future<bool>>> {
  Raw<Future<bool>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<bool>>, Raw<Future<bool>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<bool>>, Raw<Future<bool>>>,
              Raw<Future<bool>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FavoritesNotifier)
const favoritesProvider = FavoritesNotifierProvider._();

final class FavoritesNotifierProvider extends $NotifierProvider<FavoritesNotifier, Raw<Future<Map<String, Set<int>>>>> {
  const FavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesNotifierHash();

  @$internal
  @override
  FavoritesNotifier create() => FavoritesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Map<String, Set<int>>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<Map<String, Set<int>>>>>(value),
    );
  }
}

String _$favoritesNotifierHash() => r'97f2d02bbc78a039c8a97863a8900b91e623730f';

abstract class _$FavoritesNotifier extends $Notifier<Raw<Future<Map<String, Set<int>>>>> {
  Raw<Future<Map<String, Set<int>>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Map<String, Set<int>>>>, Raw<Future<Map<String, Set<int>>>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<Map<String, Set<int>>>>, Raw<Future<Map<String, Set<int>>>>>,
              Raw<Future<Map<String, Set<int>>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrgAuthNotifier)
const orgAuthProvider = OrgAuthNotifierProvider._();

final class OrgAuthNotifierProvider extends $NotifierProvider<OrgAuthNotifier, Raw<Future<Map<int, AuthService>>>> {
  const OrgAuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orgAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orgAuthNotifierHash();

  @$internal
  @override
  OrgAuthNotifier create() => OrgAuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Map<int, AuthService>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<Map<int, AuthService>>>>(value),
    );
  }
}

String _$orgAuthNotifierHash() => r'066bd5e8ab63e69aeed226b66879e1daa90c48c0';

abstract class _$OrgAuthNotifier extends $Notifier<Raw<Future<Map<int, AuthService>>>> {
  Raw<Future<Map<int, AuthService>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Map<int, AuthService>>>, Raw<Future<Map<int, AuthService>>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<Map<int, AuthService>>>, Raw<Future<Map<int, AuthService>>>>,
              Raw<Future<Map<int, AuthService>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProposeApiImportDurationNotifier)
const proposeApiImportDurationProvider = ProposeApiImportDurationNotifierProvider._();

final class ProposeApiImportDurationNotifierProvider
    extends $NotifierProvider<ProposeApiImportDurationNotifier, Raw<Future<Duration>>> {
  const ProposeApiImportDurationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proposeApiImportDurationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proposeApiImportDurationNotifierHash();

  @$internal
  @override
  ProposeApiImportDurationNotifier create() => ProposeApiImportDurationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Duration>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<Duration>>>(value));
  }
}

String _$proposeApiImportDurationNotifierHash() => r'68681fc51c1e126a27d8d63cc4acc696d22894bb';

abstract class _$ProposeApiImportDurationNotifier extends $Notifier<Raw<Future<Duration>>> {
  Raw<Future<Duration>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Duration>>, Raw<Future<Duration>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<Duration>>, Raw<Future<Duration>>>,
              Raw<Future<Duration>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JwtNotifier)
const jwtProvider = JwtNotifierProvider._();

final class JwtNotifierProvider extends $NotifierProvider<JwtNotifier, Raw<Future<String?>>> {
  const JwtNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jwtProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jwtNotifierHash();

  @$internal
  @override
  JwtNotifier create() => JwtNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<String?>>>(value));
  }
}

String _$jwtNotifierHash() => r'0f7f485373404b743e171aa3683b04ac037877d3';

abstract class _$JwtNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String?>>, Raw<Future<String?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<String?>>, Raw<Future<String?>>>,
              Raw<Future<String?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BackupEnabledNotifier)
const backupEnabledProvider = BackupEnabledNotifierProvider._();

final class BackupEnabledNotifierProvider extends $NotifierProvider<BackupEnabledNotifier, Raw<Future<bool>>> {
  const BackupEnabledNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupEnabledProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[userProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          BackupEnabledNotifierProvider.$allTransitiveDependencies0,
          BackupEnabledNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = userProvider;
  static const $allTransitiveDependencies1 = UserNotifierProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$backupEnabledNotifierHash();

  @$internal
  @override
  BackupEnabledNotifier create() => BackupEnabledNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<bool>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<bool>>>(value));
  }
}

String _$backupEnabledNotifierHash() => r'f2cfad13ab1483b8e71b40b6792df400ebfdd21c';

abstract class _$BackupEnabledNotifier extends $Notifier<Raw<Future<bool>>> {
  Raw<Future<bool>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<bool>>, Raw<Future<bool>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<bool>>, Raw<Future<bool>>>,
              Raw<Future<bool>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BackupRulesNotifier)
const backupRulesProvider = BackupRulesNotifierProvider._();

final class BackupRulesNotifierProvider extends $NotifierProvider<BackupRulesNotifier, Raw<Future<List<BackupRule>>>> {
  const BackupRulesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupRulesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[backupEnabledProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          BackupRulesNotifierProvider.$allTransitiveDependencies0,
          BackupRulesNotifierProvider.$allTransitiveDependencies1,
          BackupRulesNotifierProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = backupEnabledProvider;
  static const $allTransitiveDependencies1 = BackupEnabledNotifierProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = BackupEnabledNotifierProvider.$allTransitiveDependencies1;

  @override
  String debugGetCreateSourceHash() => _$backupRulesNotifierHash();

  @$internal
  @override
  BackupRulesNotifier create() => BackupRulesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<List<BackupRule>>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<List<BackupRule>>>>(value));
  }
}

String _$backupRulesNotifierHash() => r'cb975cde195d90959a5b8010e608a7faaa099959';

abstract class _$BackupRulesNotifier extends $Notifier<Raw<Future<List<BackupRule>>>> {
  Raw<Future<List<BackupRule>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<List<BackupRule>>>, Raw<Future<List<BackupRule>>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<List<BackupRule>>>, Raw<Future<List<BackupRule>>>>,
              Raw<Future<List<BackupRule>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
