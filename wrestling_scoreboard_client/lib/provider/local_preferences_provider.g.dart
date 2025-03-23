// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Null value represents the system locale `Platform.localeName`.
@ProviderFor(LocaleNotifier)
const localeNotifierProvider = LocaleNotifierProvider._();

/// Null value represents the system locale `Platform.localeName`.
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Raw<Future<Locale?>>> {
  /// Null value represents the system locale `Platform.localeName`.
  const LocaleNotifierProvider._(
      {super.runNotifierBuildOverride, LocaleNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      LocaleNotifier,
    ) build,
  ) {
    return LocaleNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<LocaleNotifier, Raw<Future<Locale?>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$localeNotifierHash() => r'd1a158392a814010eadb717b29bdbd563f79c97f';

abstract class _$LocaleNotifier extends $Notifier<Raw<Future<Locale?>>> {
  Raw<Future<Locale?>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Locale?>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<Locale?>>>,
        Raw<Future<Locale?>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ThemeModeNotifier)
const themeModeNotifierProvider = ThemeModeNotifierProvider._();

final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, Raw<Future<ThemeMode>>> {
  const ThemeModeNotifierProvider._(
      {super.runNotifierBuildOverride, ThemeModeNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      ThemeModeNotifier,
    ) build,
  ) {
    return ThemeModeNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ThemeModeNotifier, Raw<Future<ThemeMode>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$themeModeNotifierHash() => r'87a0d4c71b037664266350d35d9e4c54be1d1dd8';

abstract class _$ThemeModeNotifier extends $Notifier<Raw<Future<ThemeMode>>> {
  Raw<Future<ThemeMode>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<ThemeMode>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<ThemeMode>>>,
        Raw<Future<ThemeMode>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FontFamilyNotifier)
const fontFamilyNotifierProvider = FontFamilyNotifierProvider._();

final class FontFamilyNotifierProvider
    extends $NotifierProvider<FontFamilyNotifier, Raw<Future<String?>>> {
  const FontFamilyNotifierProvider._(
      {super.runNotifierBuildOverride, FontFamilyNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      FontFamilyNotifier,
    ) build,
  ) {
    return FontFamilyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<FontFamilyNotifier, Raw<Future<String?>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$fontFamilyNotifierHash() =>
    r'58f6c3cdeafa1c63986ffa5ad4de5ca9b8865b64';

abstract class _$FontFamilyNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String?>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<String?>>>,
        Raw<Future<String?>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WebSocketUrlNotifier)
const webSocketUrlNotifierProvider = WebSocketUrlNotifierProvider._();

final class WebSocketUrlNotifierProvider
    extends $NotifierProvider<WebSocketUrlNotifier, Raw<Future<String>>> {
  const WebSocketUrlNotifierProvider._(
      {super.runNotifierBuildOverride, WebSocketUrlNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      WebSocketUrlNotifier,
    ) build,
  ) {
    return WebSocketUrlNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WebSocketUrlNotifier, Raw<Future<String>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$webSocketUrlNotifierHash() =>
    r'4ea4f9c1880f05b6b6d0d718e043c04145e2a589';

abstract class _$WebSocketUrlNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<String>>>,
        Raw<Future<String>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NetworkTimeoutNotifier)
const networkTimeoutNotifierProvider = NetworkTimeoutNotifierProvider._();

final class NetworkTimeoutNotifierProvider
    extends $NotifierProvider<NetworkTimeoutNotifier, Raw<Future<Duration>>> {
  const NetworkTimeoutNotifierProvider._(
      {super.runNotifierBuildOverride,
      NetworkTimeoutNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  NetworkTimeoutNotifier create() =>
      _createCb?.call() ?? NetworkTimeoutNotifier();

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
      Ref,
      NetworkTimeoutNotifier,
    ) build,
  ) {
    return NetworkTimeoutNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<NetworkTimeoutNotifier, Raw<Future<Duration>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$networkTimeoutNotifierHash() =>
    r'686b1e7acba03732bd54aa332f2e5805cf5f526c';

abstract class _$NetworkTimeoutNotifier
    extends $Notifier<Raw<Future<Duration>>> {
  Raw<Future<Duration>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Duration>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<Duration>>>,
        Raw<Future<Duration>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ApiUrlNotifier)
const apiUrlNotifierProvider = ApiUrlNotifierProvider._();

final class ApiUrlNotifierProvider
    extends $NotifierProvider<ApiUrlNotifier, Raw<Future<String>>> {
  const ApiUrlNotifierProvider._(
      {super.runNotifierBuildOverride, ApiUrlNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      ApiUrlNotifier,
    ) build,
  ) {
    return ApiUrlNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ApiUrlNotifier, Raw<Future<String>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$apiUrlNotifierHash() => r'84cce7dfdf5727e4be7430397825e6dc984b7c04';

abstract class _$ApiUrlNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<String>>>,
        Raw<Future<String>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BellSoundNotifier)
const bellSoundNotifierProvider = BellSoundNotifierProvider._();

final class BellSoundNotifierProvider
    extends $NotifierProvider<BellSoundNotifier, Raw<Future<String>>> {
  const BellSoundNotifierProvider._(
      {super.runNotifierBuildOverride, BellSoundNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      Ref,
      BellSoundNotifier,
    ) build,
  ) {
    return BellSoundNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<BellSoundNotifier, Raw<Future<String>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$bellSoundNotifierHash() => r'44cc9ac294b4cf03b9ddeeb822cb5985d3c8cfe3';

abstract class _$BellSoundNotifier extends $Notifier<Raw<Future<String>>> {
  Raw<Future<String>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<String>>>,
        Raw<Future<String>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TimeCountDownNotifier)
const timeCountDownNotifierProvider = TimeCountDownNotifierProvider._();

final class TimeCountDownNotifierProvider
    extends $NotifierProvider<TimeCountDownNotifier, Raw<Future<bool>>> {
  const TimeCountDownNotifierProvider._(
      {super.runNotifierBuildOverride,
      TimeCountDownNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'timeCountDownNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final TimeCountDownNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$timeCountDownNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<bool>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<bool>>>(value),
    );
  }

  @$internal
  @override
  TimeCountDownNotifier create() =>
      _createCb?.call() ?? TimeCountDownNotifier();

  @$internal
  @override
  TimeCountDownNotifierProvider $copyWithCreate(
    TimeCountDownNotifier Function() create,
  ) {
    return TimeCountDownNotifierProvider._(create: create);
  }

  @$internal
  @override
  TimeCountDownNotifierProvider $copyWithBuild(
    Raw<Future<bool>> Function(
      Ref,
      TimeCountDownNotifier,
    ) build,
  ) {
    return TimeCountDownNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<TimeCountDownNotifier, Raw<Future<bool>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$timeCountDownNotifierHash() =>
    r'2ad9751aa977e4c757f46b66218f47618a882fbd';

abstract class _$TimeCountDownNotifier extends $Notifier<Raw<Future<bool>>> {
  Raw<Future<bool>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<bool>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<bool>>>, Raw<Future<bool>>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FavoritesNotifier)
const favoritesNotifierProvider = FavoritesNotifierProvider._();

final class FavoritesNotifierProvider extends $NotifierProvider<
    FavoritesNotifier, Raw<Future<Map<String, Set<int>>>>> {
  const FavoritesNotifierProvider._(
      {super.runNotifierBuildOverride, FavoritesNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      providerOverride:
          $ValueProvider<Raw<Future<Map<String, Set<int>>>>>(value),
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
      Ref,
      FavoritesNotifier,
    ) build,
  ) {
    return FavoritesNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<FavoritesNotifier,
      Raw<Future<Map<String, Set<int>>>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$favoritesNotifierHash() => r'97f2d02bbc78a039c8a97863a8900b91e623730f';

abstract class _$FavoritesNotifier
    extends $Notifier<Raw<Future<Map<String, Set<int>>>>> {
  Raw<Future<Map<String, Set<int>>>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Map<String, Set<int>>>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<Map<String, Set<int>>>>>,
        Raw<Future<Map<String, Set<int>>>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrgAuthNotifier)
const orgAuthNotifierProvider = OrgAuthNotifierProvider._();

final class OrgAuthNotifierProvider extends $NotifierProvider<OrgAuthNotifier,
    Raw<Future<Map<int, AuthService>>>> {
  const OrgAuthNotifierProvider._(
      {super.runNotifierBuildOverride, OrgAuthNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
      providerOverride:
          $ValueProvider<Raw<Future<Map<int, AuthService>>>>(value),
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
      Ref,
      OrgAuthNotifier,
    ) build,
  ) {
    return OrgAuthNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<OrgAuthNotifier, Raw<Future<Map<int, AuthService>>>>
      $createElement($ProviderPointer pointer) =>
          $NotifierProviderElement(this, pointer);
}

String _$orgAuthNotifierHash() => r'0c4640e47bee1b05ac64d6f5ec26a85eaad2e13f';

abstract class _$OrgAuthNotifier
    extends $Notifier<Raw<Future<Map<int, AuthService>>>> {
  Raw<Future<Map<int, AuthService>>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Map<int, AuthService>>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<Map<int, AuthService>>>>,
        Raw<Future<Map<int, AuthService>>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProposeApiImportDurationNotifier)
const proposeApiImportDurationNotifierProvider =
    ProposeApiImportDurationNotifierProvider._();

final class ProposeApiImportDurationNotifierProvider extends $NotifierProvider<
    ProposeApiImportDurationNotifier, Raw<Future<Duration>>> {
  const ProposeApiImportDurationNotifierProvider._(
      {super.runNotifierBuildOverride,
      ProposeApiImportDurationNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'proposeApiImportDurationNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ProposeApiImportDurationNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$proposeApiImportDurationNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<Duration>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<Duration>>>(value),
    );
  }

  @$internal
  @override
  ProposeApiImportDurationNotifier create() =>
      _createCb?.call() ?? ProposeApiImportDurationNotifier();

  @$internal
  @override
  ProposeApiImportDurationNotifierProvider $copyWithCreate(
    ProposeApiImportDurationNotifier Function() create,
  ) {
    return ProposeApiImportDurationNotifierProvider._(create: create);
  }

  @$internal
  @override
  ProposeApiImportDurationNotifierProvider $copyWithBuild(
    Raw<Future<Duration>> Function(
      Ref,
      ProposeApiImportDurationNotifier,
    ) build,
  ) {
    return ProposeApiImportDurationNotifierProvider._(
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ProposeApiImportDurationNotifier,
      Raw<Future<Duration>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$proposeApiImportDurationNotifierHash() =>
    r'eeddaf8abe731269562eac53d8bd127bc34484ff';

abstract class _$ProposeApiImportDurationNotifier
    extends $Notifier<Raw<Future<Duration>>> {
  Raw<Future<Duration>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<Duration>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<Duration>>>,
        Raw<Future<Duration>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JwtNotifier)
const jwtNotifierProvider = JwtNotifierProvider._();

final class JwtNotifierProvider
    extends $NotifierProvider<JwtNotifier, Raw<Future<String?>>> {
  const JwtNotifierProvider._(
      {super.runNotifierBuildOverride, JwtNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'jwtNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final JwtNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$jwtNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<String?>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<String?>>>(value),
    );
  }

  @$internal
  @override
  JwtNotifier create() => _createCb?.call() ?? JwtNotifier();

  @$internal
  @override
  JwtNotifierProvider $copyWithCreate(
    JwtNotifier Function() create,
  ) {
    return JwtNotifierProvider._(create: create);
  }

  @$internal
  @override
  JwtNotifierProvider $copyWithBuild(
    Raw<Future<String?>> Function(
      Ref,
      JwtNotifier,
    ) build,
  ) {
    return JwtNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<JwtNotifier, Raw<Future<String?>>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$jwtNotifierHash() => r'0f7f485373404b743e171aa3683b04ac037877d3';

abstract class _$JwtNotifier extends $Notifier<Raw<Future<String?>>> {
  Raw<Future<String?>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<String?>>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<Raw<Future<String?>>>,
        Raw<Future<String?>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
