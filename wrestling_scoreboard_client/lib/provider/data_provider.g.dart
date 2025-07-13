// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(singleDataStream)
const singleDataStreamProvider = SingleDataStreamFamily._();

final class SingleDataStreamProvider<T extends DataObject> extends $FunctionalProvider<AsyncValue<T>, T, Stream<T>>
    with $FutureModifier<T>, $StreamProvider<T> {
  const SingleDataStreamProvider._({
    required SingleDataStreamFamily super.from,
    required SingleProviderData<T> super.argument,
  }) : super(
         retry: null,
         name: r'singleDataStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = webSocketStateStreamProvider;
  static const $allTransitiveDependencies1 = WebSocketStateStreamProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = WebSocketStateStreamProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = WebSocketStateStreamProvider.$allTransitiveDependencies2;
  static const $allTransitiveDependencies4 = WebSocketStateStreamProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$singleDataStreamHash();

  @override
  String toString() {
    return r'singleDataStreamProvider'
        '<${T}>'
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<T> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<T> create(Ref ref) {
    final argument = this.argument as SingleProviderData<T>;
    return singleDataStream<T>(ref, argument);
  }

  $R _captureGenerics<$R>($R Function<T extends DataObject>() cb) {
    return cb<T>();
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

String _$singleDataStreamHash() => r'1e6ba62eda5bd5b3d5ae5bb32ba861e963c23f1f';

final class SingleDataStreamFamily extends $Family {
  const SingleDataStreamFamily._()
    : super(
        retry: null,
        name: r'singleDataStreamProvider',
        dependencies: const <ProviderOrFamily>[webSocketStateStreamProvider, dataManagerNotifierProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          SingleDataStreamProvider.$allTransitiveDependencies0,
          SingleDataStreamProvider.$allTransitiveDependencies1,
          SingleDataStreamProvider.$allTransitiveDependencies2,
          SingleDataStreamProvider.$allTransitiveDependencies3,
          SingleDataStreamProvider.$allTransitiveDependencies4,
        },
        isAutoDispose: true,
      );

  SingleDataStreamProvider<T> call<T extends DataObject>(SingleProviderData<T> pData) =>
      SingleDataStreamProvider<T>._(argument: pData, from: this);

  @override
  String toString() => r'singleDataStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(Stream<T> Function<T extends DataObject>(Ref ref, SingleProviderData<T> args) create) =>
      $FamilyOverride(
        from: this,
        createElement: (pointer) {
          final provider = pointer.origin as SingleDataStreamProvider;
          return provider._captureGenerics(<T extends DataObject>() {
            provider as SingleDataStreamProvider<T>;
            final argument = provider.argument as SingleProviderData<T>;
            return provider.$view(create: (ref) => create(ref, argument)).$createElement(pointer);
          });
        },
      );
}

@ProviderFor(manyDataStream)
const manyDataStreamProvider = ManyDataStreamFamily._();

final class ManyDataStreamProvider<T extends DataObject, S extends DataObject?>
    extends $FunctionalProvider<AsyncValue<List<T>>, List<T>, Stream<List<T>>>
    with $FutureModifier<List<T>>, $StreamProvider<List<T>> {
  const ManyDataStreamProvider._({
    required ManyDataStreamFamily super.from,
    required ManyProviderData<T, S> super.argument,
  }) : super(
         retry: null,
         name: r'manyDataStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = webSocketStateStreamProvider;
  static const $allTransitiveDependencies1 = WebSocketStateStreamProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = WebSocketStateStreamProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = WebSocketStateStreamProvider.$allTransitiveDependencies2;
  static const $allTransitiveDependencies4 = WebSocketStateStreamProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$manyDataStreamHash();

  @override
  String toString() {
    return r'manyDataStreamProvider'
        '<${T}, ${S}>'
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<T>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<T>> create(Ref ref) {
    final argument = this.argument as ManyProviderData<T, S>;
    return manyDataStream<T, S>(ref, argument);
  }

  $R _captureGenerics<$R>($R Function<T extends DataObject, S extends DataObject?>() cb) {
    return cb<T, S>();
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

String _$manyDataStreamHash() => r'cfcc50606c1459ecfd5eea6944524f5217c96b54';

final class ManyDataStreamFamily extends $Family {
  const ManyDataStreamFamily._()
    : super(
        retry: null,
        name: r'manyDataStreamProvider',
        dependencies: const <ProviderOrFamily>[webSocketStateStreamProvider, dataManagerNotifierProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          ManyDataStreamProvider.$allTransitiveDependencies0,
          ManyDataStreamProvider.$allTransitiveDependencies1,
          ManyDataStreamProvider.$allTransitiveDependencies2,
          ManyDataStreamProvider.$allTransitiveDependencies3,
          ManyDataStreamProvider.$allTransitiveDependencies4,
        },
        isAutoDispose: true,
      );

  ManyDataStreamProvider<T, S> call<T extends DataObject, S extends DataObject?>(ManyProviderData<T, S> pData) =>
      ManyDataStreamProvider<T, S>._(argument: pData, from: this);

  @override
  String toString() => r'manyDataStreamProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Stream<List<T>> Function<T extends DataObject, S extends DataObject?>(Ref ref, ManyProviderData<T, S> args) create,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as ManyDataStreamProvider;
      return provider._captureGenerics(<T extends DataObject, S extends DataObject?>() {
        provider as ManyDataStreamProvider<T, S>;
        final argument = provider.argument as ManyProviderData<T, S>;
        return provider.$view(create: (ref) => create(ref, argument)).$createElement(pointer);
      });
    },
  );
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
