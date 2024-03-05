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
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<DataManager>>>(value),
    );
  }

  @$internal
  @override
  MockDataManagerNotifier create() => _createCb?.call() ?? MockDataManagerNotifier();

  @$internal
  @override
  MockDataManagerNotifierProvider $copyWithCreate(
    MockDataManagerNotifier Function() create,
  ) {
    return MockDataManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  MockDataManagerNotifierProvider $copyWithBuild(
    Raw<Future<DataManager>> Function(
      Ref<Raw<Future<DataManager>>>,
      MockDataManagerNotifier,
    ) build,
  ) {
    return MockDataManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MockDataManagerNotifier, Raw<Future<DataManager>>> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$mockDataManagerNotifierHash() => r'9c3e0e3c990b61d515e8b2f23636bb3ca9201415';

abstract class _$MockDataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();

  @$internal
  @override
  Raw<Future<DataManager>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
