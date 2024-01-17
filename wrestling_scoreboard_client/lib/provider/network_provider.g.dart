// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketStateStreamHash() =>
    r'c2e1d1beacf1b2787622218daa6945200f4b27ee';

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
String _$dataManagerHash() => r'7cb308ac16bac0355060736e0892351b51899cd2';

/// See also [DataManager].
@ProviderFor(DataManager)
final dataManagerProvider =
    NotifierProvider<DataManager, Raw<Future<DataProvider>>>.internal(
  DataManager.new,
  name: r'dataManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dataManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DataManager = Notifier<Raw<Future<DataProvider>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
