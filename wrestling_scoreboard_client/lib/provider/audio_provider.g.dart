// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BellPlayerNotifier)
const bellPlayerProvider = BellPlayerNotifierProvider._();

final class BellPlayerNotifierProvider extends $NotifierProvider<BellPlayerNotifier, Raw<Future<AudioPlayer>>> {
  const BellPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bellPlayerProvider',
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

String _$bellPlayerNotifierHash() => r'468bb0885278f98b9ebd49ea66b7c261c1249a15';

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
