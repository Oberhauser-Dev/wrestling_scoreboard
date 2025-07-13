// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BellPlayerNotifier)
const bellPlayerNotifierProvider = BellPlayerNotifierProvider._();

final class BellPlayerNotifierProvider extends $NotifierProvider<BellPlayerNotifier, Raw<Future<AudioPlayer>>> {
  const BellPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bellPlayerNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bellPlayerNotifierHash();

  @$internal
  @override
  BellPlayerNotifier create() => BellPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<AudioPlayer>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<AudioPlayer>>>(value));
  }
}

String _$bellPlayerNotifierHash() => r'629ce6a4cd9db09a0250a179cd31607a10216d97';

abstract class _$BellPlayerNotifier extends $Notifier<Raw<Future<AudioPlayer>>> {
  Raw<Future<AudioPlayer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<AudioPlayer>>, Raw<Future<AudioPlayer>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<AudioPlayer>>, Raw<Future<AudioPlayer>>>,
              Raw<Future<AudioPlayer>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
