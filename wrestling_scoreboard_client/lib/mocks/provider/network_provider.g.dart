// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MockDataManagerNotifier)
const mockDataManagerProvider = MockDataManagerNotifierProvider._();

final class MockDataManagerNotifierProvider
    extends $NotifierProvider<MockDataManagerNotifier, Raw<Future<DataManager>>> {
  const MockDataManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockDataManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockDataManagerNotifierHash();

  @$internal
  @override
  MockDataManagerNotifier create() => MockDataManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<DataManager>>>(value));
  }
}

String _$mockDataManagerNotifierHash() => r'9c3e0e3c990b61d515e8b2f23636bb3ca9201415';

abstract class _$MockDataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
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

@ProviderFor(MockWebsocketManagerNotifier)
const mockWebsocketManagerProvider = MockWebsocketManagerNotifierProvider._();

final class MockWebsocketManagerNotifierProvider
    extends $NotifierProvider<MockWebsocketManagerNotifier, Raw<Future<WebSocketManager>>> {
  const MockWebsocketManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockWebsocketManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockWebsocketManagerNotifierHash();

  @$internal
  @override
  MockWebsocketManagerNotifier create() => MockWebsocketManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<WebSocketManager>>>(value));
  }
}

String _$mockWebsocketManagerNotifierHash() => r'0ca4a56e381640ba0bb6c2122498c052e2183807';

abstract class _$MockWebsocketManagerNotifier extends $Notifier<Raw<Future<WebSocketManager>>> {
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
