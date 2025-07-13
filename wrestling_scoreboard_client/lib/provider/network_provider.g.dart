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
  const DataManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataManagerNotifierProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$dataManagerNotifierHash();

  @$internal
  @override
  DataManagerNotifier create() => DataManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<DataManager>>>(value));
  }
}

String _$dataManagerNotifierHash() => r'c8dea305a880328441dfe1ea59a319cba4065403';

abstract class _$DataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<DataManager>>, Raw<Future<DataManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<DataManager>>, Raw<Future<DataManager>>>,
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
  const WebSocketManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketManagerNotifierProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[dataManagerNotifierProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          WebSocketManagerNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = dataManagerNotifierProvider;

  @override
  String debugGetCreateSourceHash() => _$webSocketManagerNotifierHash();

  @$internal
  @override
  WebSocketManagerNotifier create() => WebSocketManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<WebSocketManager>>>(value));
  }
}

String _$webSocketManagerNotifierHash() => r'b4f127bbe6fc7bfa3804d5af8a33ec0adb83f7f3';

abstract class _$WebSocketManagerNotifier extends $Notifier<Raw<Future<WebSocketManager>>> {
  Raw<Future<WebSocketManager>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<WebSocketManager>>, Raw<Future<WebSocketManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<WebSocketManager>>, Raw<Future<WebSocketManager>>>,
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
    extends
        $FunctionalProvider<
          AsyncValue<WebSocketConnectionState>,
          WebSocketConnectionState,
          Stream<WebSocketConnectionState>
        >
    with $FutureModifier<WebSocketConnectionState>, $StreamProvider<WebSocketConnectionState> {
  const WebSocketStateStreamProvider._()
    : super(
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
        $allTransitiveDependencies: const <ProviderOrFamily>{
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

  @override
  String debugGetCreateSourceHash() => _$webSocketStateStreamHash();

  @$internal
  @override
  $StreamProviderElement<WebSocketConnectionState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<WebSocketConnectionState> create(Ref ref) {
    return webSocketStateStream(ref);
  }
}

String _$webSocketStateStreamHash() => r'8c07bedb8f4026426f3b424dc5bcda22463de2c2';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
