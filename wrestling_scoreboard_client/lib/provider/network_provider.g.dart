// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
@ProviderFor(DataManagerNotifier)
const dataManagerNotifierProvider = DataManagerNotifierProvider._();

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
final class DataManagerNotifierProvider extends $NotifierProvider<DataManagerNotifier, Raw<Future<DataManager>>> {
  /// This provider can be scoped, so it can be overridden in a sub scope of the app.
  const DataManagerNotifierProvider._({super.runNotifierBuildOverride, DataManagerNotifier Function()? create})
    : _createCb = create,
      super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataManagerNotifierProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[],
        allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  final DataManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dataManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $ValueProvider<Raw<Future<DataManager>>>(value));
  }

  @$internal
  @override
  DataManagerNotifier create() => _createCb?.call() ?? DataManagerNotifier();

  @$internal
  @override
  DataManagerNotifierProvider $copyWithCreate(DataManagerNotifier Function() create) {
    return DataManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  DataManagerNotifierProvider $copyWithBuild(Raw<Future<DataManager>> Function(Ref, DataManagerNotifier) build) {
    return DataManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<DataManagerNotifier, Raw<Future<DataManager>>> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$dataManagerNotifierHash() => r'c8dea305a880328441dfe1ea59a319cba4065403';

abstract class _$DataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<DataManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              NotifierBase<Raw<Future<DataManager>>>,
              Raw<Future<DataManager>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
@ProviderFor(WebSocketManagerNotifier)
const webSocketManagerNotifierProvider = WebSocketManagerNotifierProvider._();

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
final class WebSocketManagerNotifierProvider
    extends $NotifierProvider<WebSocketManagerNotifier, Raw<Future<WebSocketManager>>> {
  /// This provider can be scoped, so it can be overridden in a sub scope of the app.
  const WebSocketManagerNotifierProvider._({
    super.runNotifierBuildOverride,
    WebSocketManagerNotifier Function()? create,
  }) : _createCb = create,
       super(
         from: null,
         argument: null,
         retry: null,
         name: r'webSocketManagerNotifierProvider',
         isAutoDispose: false,
         dependencies: const <ProviderOrFamily>[dataManagerNotifierProvider],
         allTransitiveDependencies: const <ProviderOrFamily>[
           WebSocketManagerNotifierProvider.$allTransitiveDependencies0,
         ],
       );

  static const $allTransitiveDependencies0 = dataManagerNotifierProvider;

  final WebSocketManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$webSocketManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $ValueProvider<Raw<Future<WebSocketManager>>>(value));
  }

  @$internal
  @override
  WebSocketManagerNotifier create() => _createCb?.call() ?? WebSocketManagerNotifier();

  @$internal
  @override
  WebSocketManagerNotifierProvider $copyWithCreate(WebSocketManagerNotifier Function() create) {
    return WebSocketManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  WebSocketManagerNotifierProvider $copyWithBuild(
    Raw<Future<WebSocketManager>> Function(Ref, WebSocketManagerNotifier) build,
  ) {
    return WebSocketManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WebSocketManagerNotifier, Raw<Future<WebSocketManager>>> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(this, pointer);
}

String _$webSocketManagerNotifierHash() => r'b4f127bbe6fc7bfa3804d5af8a33ec0adb83f7f3';

abstract class _$WebSocketManagerNotifier extends $Notifier<Raw<Future<WebSocketManager>>> {
  Raw<Future<WebSocketManager>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<WebSocketManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              NotifierBase<Raw<Future<WebSocketManager>>>,
              Raw<Future<WebSocketManager>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(webSocketStateStream)
const webSocketStateStreamProvider = WebSocketStateStreamProvider._();

final class WebSocketStateStreamProvider
    extends $FunctionalProvider<AsyncValue<WebSocketConnectionState>, Stream<WebSocketConnectionState>>
    with $FutureModifier<WebSocketConnectionState>, $StreamProvider<WebSocketConnectionState> {
  const WebSocketStateStreamProvider._({Stream<WebSocketConnectionState> Function(Ref ref)? create})
    : _createCb = create,
      super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketStateStreamProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[
          webSocketManagerNotifierProvider,
          localWebsocketManagerNotifierProvider,
          mockWebsocketManagerNotifierProvider,
        ],
        allTransitiveDependencies: const <ProviderOrFamily>{
          WebSocketStateStreamProvider.$allTransitiveDependencies0,
          WebSocketStateStreamProvider.$allTransitiveDependencies1,
          WebSocketStateStreamProvider.$allTransitiveDependencies2,
          WebSocketStateStreamProvider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = webSocketManagerNotifierProvider;
  static const $allTransitiveDependencies1 = WebSocketManagerNotifierProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = localWebsocketManagerNotifierProvider;
  static const $allTransitiveDependencies3 = mockWebsocketManagerNotifierProvider;

  final Stream<WebSocketConnectionState> Function(Ref ref)? _createCb;

  @override
  String debugGetCreateSourceHash() => _$webSocketStateStreamHash();

  @$internal
  @override
  $StreamProviderElement<WebSocketConnectionState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(this, pointer);

  @override
  WebSocketStateStreamProvider $copyWithCreate(Stream<WebSocketConnectionState> Function(Ref ref) create) {
    return WebSocketStateStreamProvider._(create: create);
  }

  @override
  Stream<WebSocketConnectionState> create(Ref ref) {
    final _$cb = _createCb ?? webSocketStateStream;
    return _$cb(ref);
  }
}

String _$webSocketStateStreamHash() => r'8c07bedb8f4026426f3b424dc5bcda22463de2c2';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
