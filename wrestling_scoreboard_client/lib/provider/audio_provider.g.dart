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
      Ref<Raw<Future<AudioPlayer>>>,
      BellPlayerNotifier,
    ) build,
  ) {
    return BellPlayerNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<BellPlayerNotifier, Raw<Future<AudioPlayer>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$bellPlayerNotifierHash() => r'88097368818de3aaeb3c325b620749dab8ac16a1';

abstract class _$BellPlayerNotifier extends $Notifier<Raw<Future<AudioPlayer>>> {
  Raw<Future<AudioPlayer>> build();

  @$internal
  @override
  Raw<Future<AudioPlayer>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
