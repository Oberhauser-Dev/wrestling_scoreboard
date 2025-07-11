// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(LocalWebsocketManagerNotifier)
const localWebsocketManagerNotifierProvider =
    LocalWebsocketManagerNotifierProvider._();

final class LocalWebsocketManagerNotifierProvider
    extends
        $NotifierProvider<
          LocalWebsocketManagerNotifier,
          Raw<Future<WebSocketManager>>
        > {
  const LocalWebsocketManagerNotifierProvider._({
    super.runNotifierBuildOverride,
    LocalWebsocketManagerNotifier Function()? create,
  }) : _createCb = create,
       super(
         from: null,
         argument: null,
         retry: null,
         name: r'localWebsocketManagerNotifierProvider',
         isAutoDispose: false,
         dependencies: const <ProviderOrFamily>[dataManagerNotifierProvider],
         allTransitiveDependencies: const <ProviderOrFamily>[
           LocalWebsocketManagerNotifierProvider.$allTransitiveDependencies0,
         ],
       );

  static const $allTransitiveDependencies0 = dataManagerNotifierProvider;

  final LocalWebsocketManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$localWebsocketManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<WebSocketManager>>>(value),
    );
  }

  @$internal
  @override
  LocalWebsocketManagerNotifier create() =>
      _createCb?.call() ?? LocalWebsocketManagerNotifier();

  @$internal
  @override
  LocalWebsocketManagerNotifierProvider $copyWithCreate(
    LocalWebsocketManagerNotifier Function() create,
  ) {
    return LocalWebsocketManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  LocalWebsocketManagerNotifierProvider $copyWithBuild(
    Raw<Future<WebSocketManager>> Function(Ref, LocalWebsocketManagerNotifier)
    build,
  ) {
    return LocalWebsocketManagerNotifierProvider._(
      runNotifierBuildOverride: build,
    );
  }

  @$internal
  @override
  $NotifierProviderElement<
    LocalWebsocketManagerNotifier,
    Raw<Future<WebSocketManager>>
  >
  $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$localWebsocketManagerNotifierHash() =>
    r'507901095468cab49cd07f88c2a83036f8a56cd7';

abstract class _$LocalWebsocketManagerNotifier
    extends $Notifier<Raw<Future<WebSocketManager>>> {
  Raw<Future<WebSocketManager>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<WebSocketManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              NotifierBase<Raw<Future<WebSocketManager>>>,
              Raw<Future<WebSocketManager>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.
@ProviderFor(LocalDataManagerNotifier)
const localDataManagerNotifierProvider = LocalDataManagerNotifierProvider._();

/// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.
final class LocalDataManagerNotifierProvider
    extends
        $NotifierProvider<LocalDataManagerNotifier, Raw<Future<DataManager>>> {
  /// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.
  const LocalDataManagerNotifierProvider._({
    super.runNotifierBuildOverride,
    LocalDataManagerNotifier Function()? create,
  }) : _createCb = create,
       super(
         from: null,
         argument: null,
         retry: null,
         name: r'localDataManagerNotifierProvider',
         isAutoDispose: false,
         dependencies: const <ProviderOrFamily>[localDataNotifierProvider],
         allTransitiveDependencies: const <ProviderOrFamily>[
           LocalDataManagerNotifierProvider.$allTransitiveDependencies0,
           LocalDataManagerNotifierProvider.$allTransitiveDependencies1,
         ],
       );

  static const $allTransitiveDependencies0 = localDataNotifierProvider;
  static const $allTransitiveDependencies1 =
      LocalDataNotifierProvider.$allTransitiveDependencies0;

  final LocalDataManagerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$localDataManagerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<DataManager>>>(value),
    );
  }

  @$internal
  @override
  LocalDataManagerNotifier create() =>
      _createCb?.call() ?? LocalDataManagerNotifier();

  @$internal
  @override
  LocalDataManagerNotifierProvider $copyWithCreate(
    LocalDataManagerNotifier Function() create,
  ) {
    return LocalDataManagerNotifierProvider._(create: create);
  }

  @$internal
  @override
  LocalDataManagerNotifierProvider $copyWithBuild(
    Raw<Future<DataManager>> Function(Ref, LocalDataManagerNotifier) build,
  ) {
    return LocalDataManagerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<LocalDataManagerNotifier, Raw<Future<DataManager>>>
  $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$localDataManagerNotifierHash() =>
    r'4caccb9b16a85ba5e0578d9aae9a31578a5050bb';

abstract class _$LocalDataManagerNotifier
    extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<DataManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              NotifierBase<Raw<Future<DataManager>>>,
              Raw<Future<DataManager>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LocalDataNotifier)
const localDataNotifierProvider = LocalDataNotifierFamily._();

final class LocalDataNotifierProvider<T extends DataObject>
    extends $NotifierProvider<LocalDataNotifier<T>, Raw<Future<List<T>>>> {
  const LocalDataNotifierProvider._({
    required LocalDataNotifierFamily super.from,
    super.runNotifierBuildOverride,
    LocalDataNotifier<T> Function()? create,
  }) : _createCb = create,
       super(
         argument: null,
         retry: null,
         name: r'localDataNotifierProvider',
         isAutoDispose: false,
         dependencies: null,
         allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = dataManagerNotifierProvider;

  final LocalDataNotifier<T> Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$localDataNotifierHash();

  LocalDataNotifierProvider<T> _copyWithCreate(
    LocalDataNotifier<T> Function<T extends DataObject>() create,
  ) {
    return LocalDataNotifierProvider<T>._(
      from: from! as LocalDataNotifierFamily,
      create: create<T>,
    );
  }

  LocalDataNotifierProvider<T> _copyWithBuild(
    Raw<Future<List<T>>> Function<T extends DataObject>(
      Ref,
      LocalDataNotifier<T>,
    )
    build,
  ) {
    return LocalDataNotifierProvider<T>._(
      from: from! as LocalDataNotifierFamily,
      runNotifierBuildOverride: build<T>,
    );
  }

  @override
  String toString() {
    return r'localDataNotifierProvider'
        '<${T}>'
        '()';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<List<T>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<List<T>>>>(value),
    );
  }

  @$internal
  @override
  LocalDataNotifier<T> create() => _createCb?.call() ?? LocalDataNotifier<T>();

  @$internal
  @override
  LocalDataNotifierProvider<T> $copyWithCreate(
    LocalDataNotifier<T> Function() create,
  ) {
    return LocalDataNotifierProvider<T>._(
      from: from! as LocalDataNotifierFamily,
      create: create,
    );
  }

  @$internal
  @override
  LocalDataNotifierProvider<T> $copyWithBuild(
    Raw<Future<List<T>>> Function(Ref, LocalDataNotifier<T>) build,
  ) {
    return LocalDataNotifierProvider<T>._(
      from: from! as LocalDataNotifierFamily,
      runNotifierBuildOverride: build,
    );
  }

  @$internal
  @override
  $NotifierProviderElement<LocalDataNotifier<T>, Raw<Future<List<T>>>>
  $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);

  @override
  bool operator ==(Object other) {
    return other is LocalDataNotifierProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$localDataNotifierHash() => r'b6a94102c95e64fc20a3b161043bc63f01b847aa';

final class LocalDataNotifierFamily extends Family {
  const LocalDataNotifierFamily._()
    : super(
        retry: null,
        name: r'localDataNotifierProvider',
        dependencies: const <ProviderOrFamily>[dataManagerNotifierProvider],
        allTransitiveDependencies: const <ProviderOrFamily>[
          LocalDataNotifierProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: false,
      );

  LocalDataNotifierProvider<T> call<T extends DataObject>() =>
      LocalDataNotifierProvider<T>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$localDataNotifierHash();

  @override
  String toString() => r'localDataNotifierProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    LocalDataNotifier<T> Function<T extends DataObject>() create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as LocalDataNotifierProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Raw<Future<List<T>>> Function<T extends DataObject>(
      Ref ref,
      LocalDataNotifier<T> notifier,
    )
    build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as LocalDataNotifierProvider;

        return provider._copyWithBuild(build).$createElement(pointer);
      },
    );
  }
}

abstract class _$LocalDataNotifier<T extends DataObject>
    extends $Notifier<Raw<Future<List<T>>>> {
  Raw<Future<List<T>>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<List<T>>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              NotifierBase<Raw<Future<List<T>>>>,
              Raw<Future<List<T>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
