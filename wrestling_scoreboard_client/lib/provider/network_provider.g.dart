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

String _$dataManagerNotifierHash() => r'5b99bb7d219662dd70ff7bf93f67d89a4c48f2e7';

abstract class _$DataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();
  @$internal
  @override
  Raw<Future<DataManager>> runBuild() => build();
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

String _$webSocketStateStreamHash() => r'04de839e83ee6df7389b8831f579692fbe40e400';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
