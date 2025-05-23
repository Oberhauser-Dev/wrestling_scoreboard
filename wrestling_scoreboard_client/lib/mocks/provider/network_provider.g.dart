// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MockDataManagerNotifier)
const mockDataManagerNotifierProvider = MockDataManagerNotifierProvider._();

final class MockDataManagerNotifierProvider
    extends $NotifierProvider<MockDataManagerNotifier, Raw<Future<DataManager>>> {
  const MockDataManagerNotifierProvider._({super.runNotifierBuildOverride, MockDataManagerNotifier Function()? create})
    : _createCb = create,
      super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockDataManagerNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        allTransitiveDependencies: null,
      );

  final MockDataManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$mockDataManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $ValueProvider<Raw<Future<DataManager>>>(value));
  }

  @$internal
  @override
  MockDataManagerNotifier create() => _createCb?.call() ?? MockDataManagerNotifier();

  @$internal
  @override
  MockDataManagerNotifierProvider $copyWithCreate(MockDataManagerNotifier Function() create) {
    return MockDataManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  MockDataManagerNotifierProvider $copyWithBuild(
    Raw<Future<DataManager>> Function(Ref, MockDataManagerNotifier) build,
  ) {
    return MockDataManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MockDataManagerNotifier, Raw<Future<DataManager>>> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(this, pointer);
}

String _$mockDataManagerNotifierHash() => r'9c3e0e3c990b61d515e8b2f23636bb3ca9201415';

abstract class _$MockDataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
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

@ProviderFor(MockWebsocketManagerNotifier)
const mockWebsocketManagerNotifierProvider = MockWebsocketManagerNotifierProvider._();

final class MockWebsocketManagerNotifierProvider
    extends $NotifierProvider<MockWebsocketManagerNotifier, Raw<Future<WebSocketManager>>> {
  const MockWebsocketManagerNotifierProvider._({
    super.runNotifierBuildOverride,
    MockWebsocketManagerNotifier Function()? create,
  }) : _createCb = create,
       super(
         from: null,
         argument: null,
         retry: null,
         name: r'mockWebsocketManagerNotifierProvider',
         isAutoDispose: false,
         dependencies: null,
         allTransitiveDependencies: null,
       );

  final MockWebsocketManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$mockWebsocketManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $ValueProvider<Raw<Future<WebSocketManager>>>(value));
  }

  @$internal
  @override
  MockWebsocketManagerNotifier create() => _createCb?.call() ?? MockWebsocketManagerNotifier();

  @$internal
  @override
  MockWebsocketManagerNotifierProvider $copyWithCreate(MockWebsocketManagerNotifier Function() create) {
    return MockWebsocketManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  MockWebsocketManagerNotifierProvider $copyWithBuild(
    Raw<Future<WebSocketManager>> Function(Ref, MockWebsocketManagerNotifier) build,
  ) {
    return MockWebsocketManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MockWebsocketManagerNotifier, Raw<Future<WebSocketManager>>> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(this, pointer);
}

String _$mockWebsocketManagerNotifierHash() => r'709ed2a007d7a6ac50c4c2680f750b6c1e730e95';

abstract class _$MockWebsocketManagerNotifier extends $Notifier<Raw<Future<WebSocketManager>>> {
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
