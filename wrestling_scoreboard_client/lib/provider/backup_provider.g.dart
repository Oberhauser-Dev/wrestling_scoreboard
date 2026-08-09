// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackupNotifier)
final backupProvider = BackupNotifierProvider._();

final class BackupNotifierProvider extends $NotifierProvider<BackupNotifier, Raw<Future<(String?, List<BackupRule>)>>> {
  BackupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[backupEnabledProvider, backupRulesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          BackupNotifierProvider.$allTransitiveDependencies0,
          BackupNotifierProvider.$allTransitiveDependencies1,
          BackupNotifierProvider.$allTransitiveDependencies2,
          BackupNotifierProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = backupEnabledProvider;
  static final $allTransitiveDependencies1 = BackupEnabledNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = BackupEnabledNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = backupRulesProvider;

  @override
  String debugGetCreateSourceHash() => _$backupNotifierHash();

  @$internal
  @override
  BackupNotifier create() => BackupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<(String?, List<BackupRule>)>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<Future<(String?, List<BackupRule>)>>>(value),
    );
  }
}

String _$backupNotifierHash() => r'6156ee67da3a49d1d1430f1b676412adeabedb5a';

abstract class _$BackupNotifier extends $Notifier<Raw<Future<(String?, List<BackupRule>)>>> {
  Raw<Future<(String?, List<BackupRule>)>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Raw<Future<(String?, List<BackupRule>)>>, Raw<Future<(String?, List<BackupRule>)>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<(String?, List<BackupRule>)>>, Raw<Future<(String?, List<BackupRule>)>>>,
              Raw<Future<(String?, List<BackupRule>)>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
