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

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
