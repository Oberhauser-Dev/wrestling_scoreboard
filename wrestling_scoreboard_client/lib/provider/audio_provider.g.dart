// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BellPlayerNotifier)
const bellPlayerNotifierProvider = BellPlayerNotifierProvider._();

final class BellPlayerNotifierProvider extends $NotifierProvider<BellPlayerNotifier, Raw<Future<AudioPlayer>>> {
  const BellPlayerNotifierProvider._({super.runNotifierBuildOverride, BellPlayerNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'bellPlayerNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final BellPlayerNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bellPlayerNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<AudioPlayer>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<AudioPlayer>>>(value),
    );
  }

  @$internal
  @override
  BellPlayerNotifier create() => _createCb?.call() ?? BellPlayerNotifier();

  @$internal
  @override
  BellPlayerNotifierProvider $copyWithCreate(
    BellPlayerNotifier Function() create,
  ) {
    return BellPlayerNotifierProvider._(create: create);
  }

  @$internal
  @override
  BellPlayerNotifierProvider $copyWithBuild(
    Raw<Future<AudioPlayer>> Function(
      Ref,
      BellPlayerNotifier,
    ) build,
  ) {
    return BellPlayerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<BellPlayerNotifier, Raw<Future<AudioPlayer>>> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$bellPlayerNotifierHash() => r'629ce6a4cd9db09a0250a179cd31607a10216d97';

abstract class _$BellPlayerNotifier extends $Notifier<Raw<Future<AudioPlayer>>> {
  Raw<Future<AudioPlayer>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<AudioPlayer>>>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<Raw<Future<AudioPlayer>>>, Raw<Future<AudioPlayer>>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
