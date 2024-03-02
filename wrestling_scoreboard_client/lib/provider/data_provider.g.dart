// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef SingleDataStreamRef<T extends DataObject> = Ref<AsyncValue<T>>;

@ProviderFor(singleDataStream)
const singleDataStreamProvider = SingleDataStreamFamily._();

final class SingleDataStreamProvider<T extends DataObject>
    extends $FunctionalProvider<AsyncValue<T>, Stream<T>, SingleDataStreamRef<T>>
    with $FutureModifier<T>, $StreamProvider<T, SingleDataStreamRef<T>> {
  const SingleDataStreamProvider._(
      {required SingleDataStreamFamily super.from,
      required SingleProviderData<T> super.argument,
      Stream<T> Function(
        SingleDataStreamRef<T> ref,
        SingleProviderData<T> pData,
      )? create})
      : _createCb = create,
        super(
          name: r'singleDataStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<T> Function(
    SingleDataStreamRef<T> ref,
    SingleProviderData<T> pData,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$singleDataStreamHash();

  SingleDataStreamProvider<T> _copyWithCreate(
    Stream<T> Function<T extends DataObject>(
      SingleDataStreamRef<T> ref,
      SingleProviderData<T> pData,
    ) create,
  ) {
    return SingleDataStreamProvider<T>._(
        argument: argument as SingleProviderData<T>, from: from! as SingleDataStreamFamily, create: create<T>);
  }

  @override
  String toString() {
    return r'singleDataStreamProvider'
        '<${T}>'
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<T> $createElement(ProviderContainer container) => $StreamProviderElement(this, container);

  @override
  SingleDataStreamProvider<T> $copyWithCreate(
    Stream<T> Function(
      SingleDataStreamRef<T> ref,
    ) create,
  ) {
    return SingleDataStreamProvider<T>._(
        argument: argument as SingleProviderData<T>,
        from: from! as SingleDataStreamFamily,
        create: (
          ref,
          SingleProviderData<T> pData,
        ) =>
            create(ref));
  }

  @override
  Stream<T> create(SingleDataStreamRef<T> ref) {
    final _$cb = _createCb ?? singleDataStream<T>;
    final argument = this.argument as SingleProviderData<T>;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SingleDataStreamProvider && other.runtimeType == runtimeType && other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$singleDataStreamHash() => r'50dcde28e62121bc26b9c2b70a254ed0f3217d27';

final class SingleDataStreamFamily extends Family {
  const SingleDataStreamFamily._()
      : super(
          name: r'singleDataStreamProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SingleDataStreamProvider<T> call<T extends DataObject>(
    SingleProviderData<T> pData,
  ) =>
      SingleDataStreamProvider<T>._(argument: pData, from: this);

  @override
  String debugGetCreateSourceHash() => _$singleDataStreamHash();

  @override
  String toString() => r'singleDataStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Stream<T> Function<T extends DataObject>(
      SingleDataStreamRef<T> ref,
      SingleProviderData<T> args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as SingleDataStreamProvider;

        return provider._copyWithCreate(<T extends DataObject>(
          ref,
          SingleProviderData<T> pData,
        ) {
          return create(ref, pData);
        }).$createElement(container);
      },
    );
  }
}

typedef ManyDataStreamRef<T extends DataObject, S extends DataObject?> = Ref<AsyncValue<List<T>>>;

@ProviderFor(manyDataStream)
const manyDataStreamProvider = ManyDataStreamFamily._();

final class ManyDataStreamProvider<T extends DataObject, S extends DataObject?>
    extends $FunctionalProvider<AsyncValue<List<T>>, Stream<List<T>>, ManyDataStreamRef<T, S>>
    with $FutureModifier<List<T>>, $StreamProvider<List<T>, ManyDataStreamRef<T, S>> {
  const ManyDataStreamProvider._(
      {required ManyDataStreamFamily super.from,
      required ManyProviderData<T, S> super.argument,
      Stream<List<T>> Function(
        ManyDataStreamRef<T, S> ref,
        ManyProviderData<T, S> pData,
      )? create})
      : _createCb = create,
        super(
          name: r'manyDataStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Stream<List<T>> Function(
    ManyDataStreamRef<T, S> ref,
    ManyProviderData<T, S> pData,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$manyDataStreamHash();

  ManyDataStreamProvider<T, S> _copyWithCreate(
    Stream<List<T>> Function<T extends DataObject, S extends DataObject?>(
      ManyDataStreamRef<T, S> ref,
      ManyProviderData<T, S> pData,
    ) create,
  ) {
    return ManyDataStreamProvider<T, S>._(
        argument: argument as ManyProviderData<T, S>, from: from! as ManyDataStreamFamily, create: create<T, S>);
  }

  @override
  String toString() {
    return r'manyDataStreamProvider'
        '<${T}, ${S}>'
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<T>> $createElement(ProviderContainer container) =>
      $StreamProviderElement(this, container);

  @override
  ManyDataStreamProvider<T, S> $copyWithCreate(
    Stream<List<T>> Function(
      ManyDataStreamRef<T, S> ref,
    ) create,
  ) {
    return ManyDataStreamProvider<T, S>._(
        argument: argument as ManyProviderData<T, S>,
        from: from! as ManyDataStreamFamily,
        create: (
          ref,
          ManyProviderData<T, S> pData,
        ) =>
            create(ref));
  }

  @override
  Stream<List<T>> create(ManyDataStreamRef<T, S> ref) {
    final _$cb = _createCb ?? manyDataStream<T, S>;
    final argument = this.argument as ManyProviderData<T, S>;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ManyDataStreamProvider && other.runtimeType == runtimeType && other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$manyDataStreamHash() => r'61ddb2c86c206435d72abedf3803853a3a8b5e88';

final class ManyDataStreamFamily extends Family {
  const ManyDataStreamFamily._()
      : super(
          name: r'manyDataStreamProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ManyDataStreamProvider<T, S> call<T extends DataObject, S extends DataObject?>(
    ManyProviderData<T, S> pData,
  ) =>
      ManyDataStreamProvider<T, S>._(argument: pData, from: this);

  @override
  String debugGetCreateSourceHash() => _$manyDataStreamHash();

  @override
  String toString() => r'manyDataStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Stream<List<T>> Function<T extends DataObject, S extends DataObject?>(
      ManyDataStreamRef<T, S> ref,
      ManyProviderData<T, S> args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ManyDataStreamProvider;

        return provider._copyWithCreate(<T extends DataObject, S extends DataObject?>(
          ref,
          ManyProviderData<T, S> pData,
        ) {
          return create(ref, pData);
        }).$createElement(container);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
