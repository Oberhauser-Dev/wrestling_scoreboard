// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketStateStreamHash() =>
    r'724acc900d53840a78018b4e53e95d0c1c053b45';

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
String _$dataManagerHash() => r'5c94263367326024f3d8fe004371537ad9c5843d';

/// See also [DataManager].
@ProviderFor(DataManager)
final dataManagerProvider =
    NotifierProvider<DataManager, Raw<DataProvider>>.internal(
  DataManager.new,
  name: r'dataManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dataManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DataManager = Notifier<Raw<DataProvider>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
