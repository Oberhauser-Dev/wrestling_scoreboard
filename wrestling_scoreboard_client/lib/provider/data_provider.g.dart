// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$manyDataStreamHash() => r'49089cdc4cfef3e619053020a56ac9835bcc4bc4';

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

/// See also [manyDataStream].
@ProviderFor(manyDataStream)
const manyDataStreamProvider = ManyDataStreamFamily();

/// See also [manyDataStream].
class ManyDataStreamFamily<T extends DataObject, S extends DataObject?> extends Family<AsyncValue<List<T>>> {
  /// See also [manyDataStream].
  const ManyDataStreamFamily();

  /// See also [manyDataStream].
  ManyDataStreamProvider<T,S> call<T extends DataObject, S extends DataObject?>({
    S? filterObject,
    List<T>? initialData,
  }) {
    return ManyDataStreamProvider<T,S>(
      filterObject: filterObject,
      initialData: initialData,
    );
  }

  @override
  ManyDataStreamProvider<T,S> getProviderOverride(
    covariant ManyDataStreamProvider<T,S> provider,
  ) {
    return call<T,S>(
      filterObject: provider.filterObject,
      initialData: provider.initialData,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'manyDataStreamProvider';
}

/// See also [manyDataStream].
class ManyDataStreamProvider<T extends DataObject, S extends DataObject?> extends AutoDisposeStreamProvider<List<T>> {
  /// See also [manyDataStream].
  ManyDataStreamProvider({
    S? filterObject,
    List<T>? initialData,
  }) : this._internal(
          (ref) => manyDataStream(
            ref as ManyDataStreamRef,
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
    super._createNotifier, {
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
    Raw<Stream<List<T>>> Function(ManyDataStreamRef<T,S> provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ManyDataStreamProvider._internal(
        (ref) => create(ref as ManyDataStreamRef<T,S>),
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
  AutoDisposeStreamProviderElement<List<T>> createElement() {
    return _ManyDataStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManyDataStreamProvider &&
        other.filterObject == filterObject &&
        other.initialData == initialData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filterObject.hashCode);
    hash = _SystemHash.combine(hash, initialData.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ManyDataStreamRef<T extends DataObject, S extends DataObject?> on AutoDisposeStreamProviderRef<List<T>> {
  /// The parameter `filterObject` of this provider.
  S? get filterObject;

  /// The parameter `initialData` of this provider.
  List<T>? get initialData;
}

class _ManyDataStreamProviderElement<T extends DataObject, S extends DataObject?>
    extends AutoDisposeStreamProviderElement<List<T>> with ManyDataStreamRef {
  _ManyDataStreamProviderElement(super.provider);

  @override
  S? get filterObject => (origin as ManyDataStreamProvider<T,S>).filterObject;
  @override
  List<T>? get initialData => (origin as ManyDataStreamProvider<T,S>).initialData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
