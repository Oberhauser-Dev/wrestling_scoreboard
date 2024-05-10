// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DataManagerNotifier)
const dataManagerNotifierProvider = DataManagerNotifierProvider._();

final class DataManagerNotifierProvider extends $NotifierProvider<DataManagerNotifier, Raw<Future<DataManager>>> {
  const DataManagerNotifierProvider._({super.runNotifierBuildOverride, DataManagerNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'dataManagerNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final DataManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dataManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<DataManager>>>(value),
    );
  }

  @$internal
  @override
  DataManagerNotifier create() => _createCb?.call() ?? DataManagerNotifier();

  @$internal
  @override
  DataManagerNotifierProvider $copyWithCreate(
    DataManagerNotifier Function() create,
  ) {
    return DataManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  DataManagerNotifierProvider $copyWithBuild(
    Raw<Future<DataManager>> Function(
      Ref<Raw<Future<DataManager>>>,
      DataManagerNotifier,
    ) build,
  ) {
    return DataManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<DataManagerNotifier, Raw<Future<DataManager>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$dataManagerNotifierHash() => r'ca415c0257cc0041067af426ad3887c4353f72e2';

abstract class _$DataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();

  @$internal
  @override
  Raw<Future<DataManager>> runBuild() => build();
}

@ProviderFor(WebSocketManagerNotifier)
const webSocketManagerNotifierProvider = WebSocketManagerNotifierProvider._();

final class WebSocketManagerNotifierProvider
    extends $NotifierProvider<WebSocketManagerNotifier, Raw<Future<WebSocketManager>>> {
  const WebSocketManagerNotifierProvider._(
      {super.runNotifierBuildOverride, WebSocketManagerNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'webSocketManagerNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final WebSocketManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$webSocketManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<WebSocketManager>>>(value),
    );
  }

  @$internal
  @override
  WebSocketManagerNotifier create() => _createCb?.call() ?? WebSocketManagerNotifier();

  @$internal
  @override
  WebSocketManagerNotifierProvider $copyWithCreate(
    WebSocketManagerNotifier Function() create,
  ) {
    return WebSocketManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  WebSocketManagerNotifierProvider $copyWithBuild(
    Raw<Future<WebSocketManager>> Function(
      Ref<Raw<Future<WebSocketManager>>>,
      WebSocketManagerNotifier,
    ) build,
  ) {
    return WebSocketManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WebSocketManagerNotifier, Raw<Future<WebSocketManager>>> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$webSocketManagerNotifierHash() => r'265576c4812245258bd39d047948d2def4d4c4a9';

abstract class _$WebSocketManagerNotifier extends $Notifier<Raw<Future<WebSocketManager>>> {
  Raw<Future<WebSocketManager>> build();

  @$internal
  @override
  Raw<Future<WebSocketManager>> runBuild() => build();
}

typedef WebSocketStateStreamRef = Ref<AsyncValue<WebSocketConnectionState>>;

@ProviderFor(webSocketStateStream)
const webSocketStateStreamProvider = WebSocketStateStreamProvider._();

final class WebSocketStateStreamProvider extends $FunctionalProvider<AsyncValue<WebSocketConnectionState>,
        Stream<WebSocketConnectionState>, WebSocketStateStreamRef>
    with $FutureModifier<WebSocketConnectionState>, $StreamProvider<WebSocketConnectionState, WebSocketStateStreamRef> {
  const WebSocketStateStreamProvider._(
      {Stream<WebSocketConnectionState> Function(
        WebSocketStateStreamRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'webSocketStateStreamProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<WebSocketConnectionState> Function(
    WebSocketStateStreamRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$webSocketStateStreamHash();

  @$internal
  @override
  $StreamProviderElement<WebSocketConnectionState> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  WebSocketStateStreamProvider $copyWithCreate(
    Stream<WebSocketConnectionState> Function(
      WebSocketStateStreamRef ref,
    ) create,
  ) {
    return WebSocketStateStreamProvider._(create: create);
  }

  @override
  Stream<WebSocketConnectionState> create(WebSocketStateStreamRef ref) {
    final _$cb = _createCb ?? webSocketStateStream;
    return _$cb(ref);
  }
}

String _$webSocketStateStreamHash() => r'046cdb4052ca78dcc18a13b84248602709b861fb';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
