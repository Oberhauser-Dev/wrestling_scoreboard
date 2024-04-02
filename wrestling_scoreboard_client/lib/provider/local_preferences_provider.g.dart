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
  const LocaleNotifierProvider._({super.runNotifierBuildOverride, LocaleNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'localeNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final LocaleNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Locale?>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<Locale?>>>(value),
    );
  }

  @$internal
  @override
  LocaleNotifier create() => _createCb?.call() ?? LocaleNotifier();

  @$internal
  @override
  LocaleNotifierProvider $copyWithCreate(
    LocaleNotifier Function() create,
  ) {
    return LocaleNotifierProvider._(create: create);
  }

  @$internal
  @override
  LocaleNotifierProvider $copyWithBuild(
    Raw<Future<Locale?>> Function(
      Ref<Raw<Future<Locale?>>>,
      LocaleNotifier,
    ) build,
  ) {
    return LocaleNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<LocaleNotifier, Raw<Future<Locale?>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$localeNotifierHash() => r'e1e390bd02d18a8474b484ee33bc40edca7e9c3d';

abstract class _$LocaleNotifier extends $Notifier<Raw<Future<Locale?>>> {
  Raw<Future<Locale?>> build();
  @$internal
  @override
  Raw<Future<Locale?>> runBuild() => build();
}

@ProviderFor(ThemeModeNotifier)
const themeModeNotifierProvider = ThemeModeNotifierProvider._();

final class ThemeModeNotifierProvider extends $NotifierProvider<ThemeModeNotifier, Raw<Future<ThemeMode>>> {
  const ThemeModeNotifierProvider._({super.runNotifierBuildOverride, ThemeModeNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'themeModeNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ThemeModeNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<ThemeMode>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<ThemeMode>>>(value),
    );
  }

  @$internal
  @override
  ThemeModeNotifier create() => _createCb?.call() ?? ThemeModeNotifier();

  @$internal
  @override
  ThemeModeNotifierProvider $copyWithCreate(
    ThemeModeNotifier Function() create,
  ) {
    return ThemeModeNotifierProvider._(create: create);
  }

  @$internal
  @override
  ThemeModeNotifierProvider $copyWithBuild(
    Raw<Future<ThemeMode>> Function(
      Ref<Raw<Future<ThemeMode>>>,
      ThemeModeNotifier,
    ) build,
  ) {
    return ThemeModeNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ThemeModeNotifier, Raw<Future<ThemeMode>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$themeModeNotifierHash() => r'29aedc145964f8e32034ab495a26ee3ccedfed82';

abstract class _$ThemeModeNotifier extends $Notifier<Raw<Future<ThemeMode>>> {
  Raw<Future<ThemeMode>> build();
  @$internal
  @override
  Raw<Future<ThemeMode>> runBuild() => build();
}

@ProviderFor(FontFamilyNotifier)
const fontFamilyNotifierProvider = FontFamilyNotifierProvider._();

final class FontFamilyNotifierProvider extends $NotifierProvider<FontFamilyNotifier, Raw<Future<String?>>> {
  const FontFamilyNotifierProvider._({super.runNotifierBuildOverride, FontFamilyNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'fontFamilyNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FontFamilyNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$fontFamilyNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String?>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String?>>>(value),
    );
  }

  @$internal
  @override
  FontFamilyNotifier create() => _createCb?.call() ?? FontFamilyNotifier();

  @$internal
  @override
  FontFamilyNotifierProvider $copyWithCreate(
    FontFamilyNotifier Function() create,
  ) {
    return FontFamilyNotifierProvider._(create: create);
  }

  @$internal
  @override
  FontFamilyNotifierProvider $copyWithBuild(
    Raw<Future<String?>> Function(
      Ref<Raw<Future<String?>>>,
      FontFamilyNotifier,
    ) build,
  ) {
    return FontFamilyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<FontFamilyNotifier, Raw<Future<String?>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$fontFamilyNotifierHash() => r'38c577d6ba358636b04947a2d8d33bb02f7a8bfc';

abstract class _$FontFamilyNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$internal
  @override
  Raw<Future<String?>> runBuild() => build();
}

@ProviderFor(WebSocketUrlNotifier)
const webSocketUrlNotifierProvider = WebSocketUrlNotifierProvider._();

final class WebSocketUrlNotifierProvider extends $NotifierProvider<WebSocketUrlNotifier, Raw<Future<String>>> {
  const WebSocketUrlNotifierProvider._({super.runNotifierBuildOverride, WebSocketUrlNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'webSocketUrlNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final WebSocketUrlNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$webSocketUrlNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  WebSocketUrlNotifier create() => _createCb?.call() ?? WebSocketUrlNotifier();

  @$internal
  @override
  WebSocketUrlNotifierProvider $copyWithCreate(
    WebSocketUrlNotifier Function() create,
  ) {
    return WebSocketUrlNotifierProvider._(create: create);
  }

  @$internal
  @override
  WebSocketUrlNotifierProvider $copyWithBuild(
    Raw<Future<String>> Function(
      Ref<Raw<Future<String>>>,
      WebSocketUrlNotifier,
    ) build,
  ) {
    return WebSocketUrlNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WebSocketUrlNotifier, Raw<Future<String>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$webSocketUrlNotifierHash() => r'3e384b28903aca1717d43fa65ace0651b39b668a';

abstract class _$WebSocketUrlNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  Raw<Future<String>> runBuild() => build();
}

@ProviderFor(NetworkTimeoutNotifier)
const networkTimeoutNotifierProvider = NetworkTimeoutNotifierProvider._();

final class NetworkTimeoutNotifierProvider extends $NotifierProvider<NetworkTimeoutNotifier, Raw<Future<Duration>>> {
  const NetworkTimeoutNotifierProvider._({super.runNotifierBuildOverride, NetworkTimeoutNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'networkTimeoutNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final NetworkTimeoutNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$networkTimeoutNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Duration>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<Duration>>>(value),
    );
  }

  @$internal
  @override
  NetworkTimeoutNotifier create() => _createCb?.call() ?? NetworkTimeoutNotifier();

  @$internal
  @override
  NetworkTimeoutNotifierProvider $copyWithCreate(
    NetworkTimeoutNotifier Function() create,
  ) {
    return NetworkTimeoutNotifierProvider._(create: create);
  }

  @$internal
  @override
  NetworkTimeoutNotifierProvider $copyWithBuild(
    Raw<Future<Duration>> Function(
      Ref<Raw<Future<Duration>>>,
      NetworkTimeoutNotifier,
    ) build,
  ) {
    return NetworkTimeoutNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NetworkTimeoutNotifier, Raw<Future<Duration>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$networkTimeoutNotifierHash() => r'2c6a26f2904896d01c9ddd31fd4ae7637030a027';

abstract class _$NetworkTimeoutNotifier extends $Notifier<Raw<Future<Duration>>> {
  Raw<Future<Duration>> build();
  @$internal
  @override
  Raw<Future<Duration>> runBuild() => build();
}

@ProviderFor(ApiUrlNotifier)
const apiUrlNotifierProvider = ApiUrlNotifierProvider._();

final class ApiUrlNotifierProvider extends $NotifierProvider<ApiUrlNotifier, Raw<Future<String>>> {
  const ApiUrlNotifierProvider._({super.runNotifierBuildOverride, ApiUrlNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'apiUrlNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ApiUrlNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$apiUrlNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  ApiUrlNotifier create() => _createCb?.call() ?? ApiUrlNotifier();

  @$internal
  @override
  ApiUrlNotifierProvider $copyWithCreate(
    ApiUrlNotifier Function() create,
  ) {
    return ApiUrlNotifierProvider._(create: create);
  }

  @$internal
  @override
  ApiUrlNotifierProvider $copyWithBuild(
    Raw<Future<String>> Function(
      Ref<Raw<Future<String>>>,
      ApiUrlNotifier,
    ) build,
  ) {
    return ApiUrlNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ApiUrlNotifier, Raw<Future<String>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$apiUrlNotifierHash() => r'8c063b9ec135234c56970345957760282a21fbde';

abstract class _$ApiUrlNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  Raw<Future<String>> runBuild() => build();
}

@ProviderFor(BellSoundNotifier)
const bellSoundNotifierProvider = BellSoundNotifierProvider._();

final class BellSoundNotifierProvider extends $NotifierProvider<BellSoundNotifier, Raw<Future<String>>> {
  const BellSoundNotifierProvider._({super.runNotifierBuildOverride, BellSoundNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'bellSoundNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final BellSoundNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bellSoundNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String>>>(value),
    );
  }

  @$internal
  @override
  BellSoundNotifier create() => _createCb?.call() ?? BellSoundNotifier();

  @$internal
  @override
  BellSoundNotifierProvider $copyWithCreate(
    BellSoundNotifier Function() create,
  ) {
    return BellSoundNotifierProvider._(create: create);
  }

  @$internal
  @override
  BellSoundNotifierProvider $copyWithBuild(
    Raw<Future<String>> Function(
      Ref<Raw<Future<String>>>,
      BellSoundNotifier,
    ) build,
  ) {
    return BellSoundNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<BellSoundNotifier, Raw<Future<String>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$bellSoundNotifierHash() => r'1c9d805977f6f32cd7b44e7bd1ecfecd15447ddd';

abstract class _$BellSoundNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  Raw<Future<String>> runBuild() => build();
}

@ProviderFor(FavoritesNotifier)
const favoritesNotifierProvider = FavoritesNotifierProvider._();

final class FavoritesNotifierProvider extends $NotifierProvider<FavoritesNotifier, Raw<Future<Map<String, Set<int>>>>> {
  const FavoritesNotifierProvider._({super.runNotifierBuildOverride, FavoritesNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'favoritesNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FavoritesNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$favoritesNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Map<String, Set<int>>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<Map<String, Set<int>>>>>(value),
    );
  }

  @$internal
  @override
  FavoritesNotifier create() => _createCb?.call() ?? FavoritesNotifier();

  @$internal
  @override
  FavoritesNotifierProvider $copyWithCreate(
    FavoritesNotifier Function() create,
  ) {
    return FavoritesNotifierProvider._(create: create);
  }

  @$internal
  @override
  FavoritesNotifierProvider $copyWithBuild(
    Raw<Future<Map<String, Set<int>>>> Function(
      Ref<Raw<Future<Map<String, Set<int>>>>>,
      FavoritesNotifier,
    ) build,
  ) {
    return FavoritesNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<FavoritesNotifier, Raw<Future<Map<String, Set<int>>>>> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$favoritesNotifierHash() => r'97f2d02bbc78a039c8a97863a8900b91e623730f';

abstract class _$FavoritesNotifier extends $Notifier<Raw<Future<Map<String, Set<int>>>>> {
  Raw<Future<Map<String, Set<int>>>> build();
  @$internal
  @override
  Raw<Future<Map<String, Set<int>>>> runBuild() => build();
}

@ProviderFor(OrgAuthNotifier)
const orgAuthNotifierProvider = OrgAuthNotifierProvider._();

final class OrgAuthNotifierProvider extends $NotifierProvider<OrgAuthNotifier, Raw<Future<Map<int, AuthService>>>> {
  const OrgAuthNotifierProvider._({super.runNotifierBuildOverride, OrgAuthNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'orgAuthNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final OrgAuthNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$orgAuthNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Map<int, AuthService>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<Map<int, AuthService>>>>(value),
    );
  }

  @$internal
  @override
  OrgAuthNotifier create() => _createCb?.call() ?? OrgAuthNotifier();

  @$internal
  @override
  OrgAuthNotifierProvider $copyWithCreate(
    OrgAuthNotifier Function() create,
  ) {
    return OrgAuthNotifierProvider._(create: create);
  }

  @$internal
  @override
  OrgAuthNotifierProvider $copyWithBuild(
    Raw<Future<Map<int, AuthService>>> Function(
      Ref<Raw<Future<Map<int, AuthService>>>>,
      OrgAuthNotifier,
    ) build,
  ) {
    return OrgAuthNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<OrgAuthNotifier, Raw<Future<Map<int, AuthService>>>> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$orgAuthNotifierHash() => r'4ea0cb1cf146ff4c48b962f8bbee907e98c24f9a';

abstract class _$OrgAuthNotifier extends $Notifier<Raw<Future<Map<int, AuthService>>>> {
  Raw<Future<Map<int, AuthService>>> build();
  @$internal
  @override
  Raw<Future<Map<int, AuthService>>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
