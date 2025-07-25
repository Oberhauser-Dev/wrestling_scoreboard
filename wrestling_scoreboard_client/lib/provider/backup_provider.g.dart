// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BackupNotifier)
const backupNotifierProvider = BackupNotifierProvider._();

final class BackupNotifierProvider extends $NotifierProvider<BackupNotifier, Raw<Future<(String?, List<BackupRule>)>>> {
  const BackupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[backupEnabledNotifierProvider, backupRulesNotifierProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          BackupNotifierProvider.$allTransitiveDependencies0,
          BackupNotifierProvider.$allTransitiveDependencies1,
          BackupNotifierProvider.$allTransitiveDependencies2,
          BackupNotifierProvider.$allTransitiveDependencies3,
        },
      );

  static const $allTransitiveDependencies0 = backupEnabledNotifierProvider;
  static const $allTransitiveDependencies1 = BackupEnabledNotifierProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 = BackupEnabledNotifierProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 = backupRulesNotifierProvider;

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

String _$backupNotifierHash() => r'dd909def398fd500bfd61a3fd42de9baf589a38c';

abstract class _$BackupNotifier extends $Notifier<Raw<Future<(String?, List<BackupRule>)>>> {
  Raw<Future<(String?, List<BackupRule>)>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<(String?, List<BackupRule>)>>, Raw<Future<(String?, List<BackupRule>)>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<(String?, List<BackupRule>)>>, Raw<Future<(String?, List<BackupRule>)>>>,
              Raw<Future<(String?, List<BackupRule>)>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
