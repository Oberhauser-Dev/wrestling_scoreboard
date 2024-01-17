// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketStateStreamHash() =>
    r'bfe80bc0287789e7b15b8dadde53d53820c4e0c8';

/// See also [webSocketStateStream].
@ProviderFor(webSocketStateStream)
final webSocketStateStreamProvider =
    StreamProvider<WebSocketConnectionState>.internal(
  webSocketStateStream,
  name: r'webSocketStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$webSocketStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WebSocketStateStreamRef = StreamProviderRef<WebSocketConnectionState>;
String _$dataManagerNotifierHash() =>
    r'f5b3a82d377333a757b5078f845e780a9e0bec37';

/// See also [DataManagerNotifier].
@ProviderFor(DataManagerNotifier)
final dataManagerNotifierProvider =
    NotifierProvider<DataManagerNotifier, Raw<Future<DataProvider>>>.internal(
  DataManagerNotifier.new,
  name: r'dataManagerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dataManagerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DataManagerNotifier = Notifier<Raw<Future<DataProvider>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
