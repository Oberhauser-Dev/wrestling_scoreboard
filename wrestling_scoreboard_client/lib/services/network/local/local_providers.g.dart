// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalWebsocketManagerNotifier)
const localWebsocketManagerProvider = LocalWebsocketManagerNotifierProvider._();

final class LocalWebsocketManagerNotifierProvider
    extends $NotifierProvider<LocalWebsocketManagerNotifier, Raw<Future<WebSocketManager>>> {
  const LocalWebsocketManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localWebsocketManagerProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[dataManagerProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          LocalWebsocketManagerNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = dataManagerProvider;

  @override
  String debugGetCreateSourceHash() => _$localWebsocketManagerNotifierHash();

  @$internal
  @override
  LocalWebsocketManagerNotifier create() => LocalWebsocketManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WebSocketManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<WebSocketManager>>>(value));
  }
}

String _$localWebsocketManagerNotifierHash() => r'c1cf26f8783f8c4b526bb3b5fe64110862eb36b4';

abstract class _$LocalWebsocketManagerNotifier extends $Notifier<Raw<Future<WebSocketManager>>> {
  Raw<Future<WebSocketManager>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<WebSocketManager>>, Raw<Future<WebSocketManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<WebSocketManager>>, Raw<Future<WebSocketManager>>>,
              Raw<Future<WebSocketManager>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.

@ProviderFor(LocalDataManagerNotifier)
const localDataManagerProvider = LocalDataManagerNotifierProvider._();

/// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.
final class LocalDataManagerNotifierProvider
    extends $NotifierProvider<LocalDataManagerNotifier, Raw<Future<DataManager>>> {
  /// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.
  const LocalDataManagerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataManagerProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[localDataProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          LocalDataManagerNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = localDataProvider;

  @override
  String debugGetCreateSourceHash() => _$localDataManagerNotifierHash();

  @$internal
  @override
  LocalDataManagerNotifier create() => LocalDataManagerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<DataManager>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<DataManager>>>(value));
  }
}

String _$localDataManagerNotifierHash() => r'cd7b44d66cf608f2d4b90d9ea468b8999b9f4431';

/// [LocalDataManager] uses [LocalDataNotifier] internally, so need to list it as dependency.

abstract class _$LocalDataManagerNotifier extends $Notifier<Raw<Future<DataManager>>> {
  Raw<Future<DataManager>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<DataManager>>, Raw<Future<DataManager>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<DataManager>>, Raw<Future<DataManager>>>,
              Raw<Future<DataManager>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LocalDataNotifier)
const localDataProvider = LocalDataNotifierFamily._();

final class LocalDataNotifierProvider<T extends DataObject>
    extends $NotifierProvider<LocalDataNotifier<T>, Raw<Future<List<Map<String, dynamic>>>>> {
  const LocalDataNotifierProvider._({required LocalDataNotifierFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'localDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataNotifierHash();

  @override
  String toString() {
    return r'localDataProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  LocalDataNotifier<T> create() => LocalDataNotifier<T>();

  $R _captureGenerics<$R>($R Function<T extends DataObject>() cb) {
    return cb<T>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<List<Map<String, dynamic>>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<List<Map<String, dynamic>>>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LocalDataNotifierProvider && other.runtimeType == runtimeType && other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$localDataNotifierHash() => r'e5a48460159238b44baafcf28a8ffd85738092c2';

final class LocalDataNotifierFamily extends $Family {
  const LocalDataNotifierFamily._()
    : super(
        retry: null,
        name: r'localDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  LocalDataNotifierProvider<T> call<T extends DataObject>() => LocalDataNotifierProvider<T>._(from: this);

  @override
  String toString() => r'localDataProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(LocalDataNotifier<T> Function<T extends DataObject>() create) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as LocalDataNotifierProvider;
      return provider._captureGenerics(<T extends DataObject>() {
        provider as LocalDataNotifierProvider<T>;
        return provider.$view(create: create<T>).$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    Raw<Future<List<Map<String, dynamic>>>> Function<T extends DataObject>(Ref ref, LocalDataNotifier<T> notifier)
    build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as LocalDataNotifierProvider;
      return provider._captureGenerics(<T extends DataObject>() {
        provider as LocalDataNotifierProvider<T>;
        return provider.$view(runNotifierBuildOverride: build<T>).$createElement(pointer);
      });
    },
  );
}

abstract class _$LocalDataNotifier<T extends DataObject> extends $Notifier<Raw<Future<List<Map<String, dynamic>>>>> {
  Raw<Future<List<Map<String, dynamic>>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<List<Map<String, dynamic>>>>, Raw<Future<List<Map<String, dynamic>>>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<List<Map<String, dynamic>>>>, Raw<Future<List<Map<String, dynamic>>>>>,
              Raw<Future<List<Map<String, dynamic>>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
