// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleDataStreamHash() => r'b1c83c1bed6ae98086dac08fcb71ffb2a3d18f06';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [singleDataStream].
@ProviderFor(singleDataStream)
const singleDataStreamProvider = SingleDataStreamFamily();

/// See also [singleDataStream].
class SingleDataStreamFamily extends Family {
  /// See also [singleDataStream].
  const SingleDataStreamFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'singleDataStreamProvider';

  /// See also [singleDataStream].
  SingleDataStreamProvider<T> call<T extends DataObject>({
    required int id,
    T? initialData,
  }) {
    return SingleDataStreamProvider<T>(
      id: id,
      initialData: initialData,
    );
  }

  @visibleForOverriding
  @override
  SingleDataStreamProvider<DataObject> getProviderOverride(
    covariant SingleDataStreamProvider<DataObject> provider,
  ) {
    return call(
      id: provider.id,
      initialData: provider.initialData,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      Stream<T> Function<T extends DataObject>(SingleDataStreamRef ref)
          create) {
    return _$SingleDataStreamFamilyOverride(this, create);
  }
}

class _$SingleDataStreamFamilyOverride implements FamilyOverride {
  _$SingleDataStreamFamilyOverride(this.overriddenFamily, this.create);

  final Stream<T> Function<T extends DataObject>(SingleDataStreamRef ref)
      create;

  @override
  final SingleDataStreamFamily overriddenFamily;

  @override
  SingleDataStreamProvider getProviderOverride(
    covariant SingleDataStreamProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [singleDataStream].
class SingleDataStreamProvider<T extends DataObject>
    extends AutoDisposeStreamProvider<T> {
  /// See also [singleDataStream].
  SingleDataStreamProvider({
    required int id,
    T? initialData,
  }) : this._internal(
          (ref) => singleDataStream<T>(
            ref as SingleDataStreamRef<T>,
            id: id,
            initialData: initialData,
          ),
          from: singleDataStreamProvider,
          name: r'singleDataStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleDataStreamHash,
          dependencies: SingleDataStreamFamily._dependencies,
          allTransitiveDependencies:
              SingleDataStreamFamily._allTransitiveDependencies,
          id: id,
          initialData: initialData,
        );

  SingleDataStreamProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.initialData,
  }) : super.internal();

  final int id;
  final T? initialData;

  @override
  Override overrideWith(
    Stream<T> Function(SingleDataStreamRef<T> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SingleDataStreamProvider<T>._internal(
        (ref) => create(ref as SingleDataStreamRef<T>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        initialData: initialData,
      ),
    );
  }

  @override
  ({
    int id,
    T? initialData,
  }) get argument {
    return (
      id: id,
      initialData: initialData,
    );
  }

  @override
  AutoDisposeStreamProviderElement<T> createElement() {
    return _SingleDataStreamProviderElement(this);
  }

  SingleDataStreamProvider _copyWith(
    Stream<T> Function<T extends DataObject>(SingleDataStreamRef ref) create,
  ) {
    return SingleDataStreamProvider._internal(
      (ref) => create(ref as SingleDataStreamRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      id: id,
      initialData: initialData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SingleDataStreamProvider &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.initialData == initialData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, initialData.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SingleDataStreamRef<T extends DataObject>
    on AutoDisposeStreamProviderRef<T> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `initialData` of this provider.
  T? get initialData;
}

class _SingleDataStreamProviderElement<T extends DataObject>
    extends AutoDisposeStreamProviderElement<T> with SingleDataStreamRef<T> {
  _SingleDataStreamProviderElement(super.provider);

  @override
  int get id => (origin as SingleDataStreamProvider<T>).id;
  @override
  T? get initialData => (origin as SingleDataStreamProvider<T>).initialData;
}

String _$manyDataStreamHash() => r'49089cdc4cfef3e619053020a56ac9835bcc4bc4';

/// See also [manyDataStream].
@ProviderFor(manyDataStream)
const manyDataStreamProvider = ManyDataStreamFamily();

/// See also [manyDataStream].
class ManyDataStreamFamily extends Family {
  /// See also [manyDataStream].
  const ManyDataStreamFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'manyDataStreamProvider';

  /// See also [manyDataStream].
  ManyDataStreamProvider<T, S>
      call<T extends DataObject, S extends DataObject?>({
    S? filterObject,
    List<T>? initialData,
  }) {
    return ManyDataStreamProvider<T, S>(
      filterObject: filterObject,
      initialData: initialData,
    );
  }

  @visibleForOverriding
  @override
  ManyDataStreamProvider<DataObject, DataObject?> getProviderOverride(
    covariant ManyDataStreamProvider<DataObject, DataObject?> provider,
  ) {
    return call(
      filterObject: provider.filterObject,
      initialData: provider.initialData,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      Stream<List<T>> Function<T extends DataObject, S extends DataObject?>(
              ManyDataStreamRef ref)
          create) {
    return _$ManyDataStreamFamilyOverride(this, create);
  }
}

class _$ManyDataStreamFamilyOverride implements FamilyOverride {
  _$ManyDataStreamFamilyOverride(this.overriddenFamily, this.create);

  final Stream<List<T>> Function<T extends DataObject, S extends DataObject?>(
      ManyDataStreamRef ref) create;

  @override
  final ManyDataStreamFamily overriddenFamily;

  @override
  ManyDataStreamProvider getProviderOverride(
    covariant ManyDataStreamProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [manyDataStream].
class ManyDataStreamProvider<T extends DataObject, S extends DataObject?>
    extends AutoDisposeStreamProvider<List<T>> {
  /// See also [manyDataStream].
  ManyDataStreamProvider({
    S? filterObject,
    List<T>? initialData,
  }) : this._internal(
          (ref) => manyDataStream<T, S>(
            ref as ManyDataStreamRef<T, S>,
            filterObject: filterObject,
            initialData: initialData,
          ),
          from: manyDataStreamProvider,
          name: r'manyDataStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$manyDataStreamHash,
          dependencies: ManyDataStreamFamily._dependencies,
          allTransitiveDependencies:
              ManyDataStreamFamily._allTransitiveDependencies,
          filterObject: filterObject,
          initialData: initialData,
        );

  ManyDataStreamProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filterObject,
    required this.initialData,
  }) : super.internal();

  final S? filterObject;
  final List<T>? initialData;

  @override
  Override overrideWith(
    Stream<List<T>> Function(ManyDataStreamRef<T, S> ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ManyDataStreamProvider<T, S>._internal(
        (ref) => create(ref as ManyDataStreamRef<T, S>),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filterObject: filterObject,
        initialData: initialData,
      ),
    );
  }

  @override
  ({
    S? filterObject,
    List<T>? initialData,
  }) get argument {
    return (
      filterObject: filterObject,
      initialData: initialData,
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<T>> createElement() {
    return _ManyDataStreamProviderElement(this);
  }

  ManyDataStreamProvider _copyWith(
    Stream<List<T>> Function<T extends DataObject, S extends DataObject?>(
            ManyDataStreamRef ref)
        create,
  ) {
    return ManyDataStreamProvider._internal(
      (ref) => create(ref as ManyDataStreamRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      filterObject: filterObject,
      initialData: initialData,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ManyDataStreamProvider &&
        other.runtimeType == runtimeType &&
        other.filterObject == filterObject &&
        other.initialData == initialData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filterObject.hashCode);
    hash = _SystemHash.combine(hash, initialData.hashCode);
    hash = _SystemHash.combine(hash, T.hashCode);
    hash = _SystemHash.combine(hash, S.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ManyDataStreamRef<T extends DataObject, S extends DataObject?>
    on AutoDisposeStreamProviderRef<List<T>> {
  /// The parameter `filterObject` of this provider.
  S? get filterObject;

  /// The parameter `initialData` of this provider.
  List<T>? get initialData;
}

class _ManyDataStreamProviderElement<T extends DataObject,
        S extends DataObject?> extends AutoDisposeStreamProviderElement<List<T>>
    with ManyDataStreamRef<T, S> {
  _ManyDataStreamProviderElement(super.provider);

  @override
  S? get filterObject => (origin as ManyDataStreamProvider<T, S>).filterObject;
  @override
  List<T>? get initialData =>
      (origin as ManyDataStreamProvider<T, S>).initialData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
