// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketStateStreamHash() => r'04de839e83ee6df7389b8831f579692fbe40e400';

/// See also [webSocketStateStream].
@ProviderFor(webSocketStateStream)
final webSocketStateStreamProvider = StreamProvider<WebSocketConnectionState>.internal(
  webSocketStateStream,
  name: r'webSocketStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$webSocketStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WebSocketStateStreamRef = StreamProviderRef<WebSocketConnectionState>;
String _$dataManagerNotifierHash() => r'5b99bb7d219662dd70ff7bf93f67d89a4c48f2e7';

/// See also [DataManagerNotifier].
@ProviderFor(DataManagerNotifier)
final dataManagerNotifierProvider = NotifierProvider<DataManagerNotifier, Raw<Future<DataManager>>>.internal(
  DataManagerNotifier.new,
  name: r'dataManagerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$dataManagerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DataManagerNotifier = Notifier<Raw<Future<DataManager>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
