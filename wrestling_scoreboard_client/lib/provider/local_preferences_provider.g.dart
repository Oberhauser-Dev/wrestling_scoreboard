// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Null value represents the system locale `Platform.localeName`.
@ProviderFor(LocaleNotifier)
const localeNotifierProvider = LocaleNotifierProvider._();

/// Null value represents the system locale `Platform.localeName`.
final class LocaleNotifierProvider extends $NotifierProvider<LocaleNotifier, Raw<Future<Locale?>>> {
  /// Null value represents the system locale `Platform.localeName`.
  const LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeNotifierProvider',
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

String _$localeNotifierHash() => r'd1a158392a814010eadb717b29bdbd563f79c97f';

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
const themeModeNotifierProvider = ThemeModeNotifierProvider._();

final class ThemeModeNotifierProvider extends $NotifierProvider<ThemeModeNotifier, Raw<Future<ThemeMode>>> {
  const ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeNotifierProvider',
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
const fontFamilyNotifierProvider = FontFamilyNotifierProvider._();

final class FontFamilyNotifierProvider extends $NotifierProvider<FontFamilyNotifier, Raw<Future<String?>>> {
  const FontFamilyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fontFamilyNotifierProvider',
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
const webSocketUrlNotifierProvider = WebSocketUrlNotifierProvider._();

final class WebSocketUrlNotifierProvider extends $NotifierProvider<WebSocketUrlNotifier, Raw<Future<String>>> {
  const WebSocketUrlNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketUrlNotifierProvider',
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

String _$webSocketUrlNotifierHash() => r'4ea4f9c1880f05b6b6d0d718e043c04145e2a589';

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

@ProviderFor(NetworkTimeoutNotifier)
const networkTimeoutNotifierProvider = NetworkTimeoutNotifierProvider._();

final class NetworkTimeoutNotifierProvider extends $NotifierProvider<NetworkTimeoutNotifier, Raw<Future<Duration>>> {
  const NetworkTimeoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkTimeoutNotifierProvider',
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
const apiUrlNotifierProvider = ApiUrlNotifierProvider._();

final class ApiUrlNotifierProvider extends $NotifierProvider<ApiUrlNotifier, Raw<Future<String>>> {
  const ApiUrlNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiUrlNotifierProvider',
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

String _$apiUrlNotifierHash() => r'84cce7dfdf5727e4be7430397825e6dc984b7c04';

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
const appDataDirectoryNotifierProvider = AppDataDirectoryNotifierProvider._();

final class AppDataDirectoryNotifierProvider extends $NotifierProvider<AppDataDirectoryNotifier, Raw<Future<String?>>> {
  const AppDataDirectoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDataDirectoryNotifierProvider',
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

String _$appDataDirectoryNotifierHash() => r'bbd8db761e198e5368dc171247f66769ce7f07bb';

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
const bellSoundNotifierProvider = BellSoundNotifierProvider._();

final class BellSoundNotifierProvider extends $NotifierProvider<BellSoundNotifier, Raw<Future<String>>> {
  const BellSoundNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bellSoundNotifierProvider',
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
const timeCountDownNotifierProvider = TimeCountDownNotifierProvider._();

final class TimeCountDownNotifierProvider extends $NotifierProvider<TimeCountDownNotifier, Raw<Future<bool>>> {
  const TimeCountDownNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeCountDownNotifierProvider',
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

@ProviderFor(FavoritesNotifier)
const favoritesNotifierProvider = FavoritesNotifierProvider._();

final class FavoritesNotifierProvider extends $NotifierProvider<FavoritesNotifier, Raw<Future<Map<String, Set<int>>>>> {
  const FavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesNotifierProvider',
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
const orgAuthNotifierProvider = OrgAuthNotifierProvider._();

final class OrgAuthNotifierProvider extends $NotifierProvider<OrgAuthNotifier, Raw<Future<Map<int, AuthService>>>> {
  const OrgAuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orgAuthNotifierProvider',
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

String _$orgAuthNotifierHash() => r'0c4640e47bee1b05ac64d6f5ec26a85eaad2e13f';

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
const proposeApiImportDurationNotifierProvider = ProposeApiImportDurationNotifierProvider._();

final class ProposeApiImportDurationNotifierProvider
    extends $NotifierProvider<ProposeApiImportDurationNotifier, Raw<Future<Duration>>> {
  const ProposeApiImportDurationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proposeApiImportDurationNotifierProvider',
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

String _$proposeApiImportDurationNotifierHash() => r'9777ac55dd525899c1c2c1e7579921669381eb8f';

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
const jwtNotifierProvider = JwtNotifierProvider._();

final class JwtNotifierProvider extends $NotifierProvider<JwtNotifier, Raw<Future<String?>>> {
  const JwtNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jwtNotifierProvider',
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
