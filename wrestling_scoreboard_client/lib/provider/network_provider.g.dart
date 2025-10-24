// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This provider can be scoped, so it can be overridden in a sub scope of the app.

@ProviderFor(DataManagerNotifier)
const dataManagerProvider = DataManagerNotifierProvider._();

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
final class DataManagerNotifierProvider extends $NotifierProvider<DataManagerNotifier, Raw<Future<DataManager>>> {
  /// This provider can be scoped, so it can be overridden in a sub scope of the app.
  const DataManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataManagerProvider',
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

String _$dataManagerNotifierHash() => r'3bf51b57e7f2433b51072031b0594774a652a768';

/// This provider can be scoped, so it can be overridden in a sub scope of the app.

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
const webSocketManagerProvider = WebSocketManagerNotifierProvider._();

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
final class WebSocketManagerNotifierProvider
    extends $NotifierProvider<WebSocketManagerNotifier, Raw<Future<WebSocketManager>>> {
  /// This provider can be scoped, so it can be overridden in a sub scope of the app.
  const WebSocketManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketManagerProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[dataManagerProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          WebSocketManagerNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = dataManagerProvider;

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

String _$webSocketManagerNotifierHash() => r'02871868abdcc1275854a6caf58370908b0168db';

/// This provider can be scoped, so it can be overridden in a sub scope of the app.

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
          webSocketManagerProvider,
          localWebsocketManagerProvider,
          mockWebsocketManagerProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          WebSocketStateStreamProvider.$allTransitiveDependencies0,
          WebSocketStateStreamProvider.$allTransitiveDependencies1,
          WebSocketStateStreamProvider.$allTransitiveDependencies2,
          WebSocketStateStreamProvider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = webSocketManagerProvider;
  static const $allTransitiveDependencies1 = WebSocketManagerNotifierProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = localWebsocketManagerProvider;
  static const $allTransitiveDependencies3 = mockWebsocketManagerProvider;

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

String _$webSocketStateStreamHash() => r'19dffbedc10ec4cf7ee774b404a5ebc11e89c89c';
