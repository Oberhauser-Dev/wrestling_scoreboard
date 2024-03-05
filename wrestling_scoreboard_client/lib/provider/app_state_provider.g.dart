// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(WindowStateNotifier)
const windowStateNotifierProvider = WindowStateNotifierProvider._();

final class WindowStateNotifierProvider extends $NotifierProvider<WindowStateNotifier, Raw<Future<WindowState>>> {
  const WindowStateNotifierProvider._({super.runNotifierBuildOverride, WindowStateNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'windowStateNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final WindowStateNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$windowStateNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WindowState>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<WindowState>>>(value),
    );
  }

  @$internal
  @override
  WindowStateNotifier create() => _createCb?.call() ?? WindowStateNotifier();

  @$internal
  @override
  WindowStateNotifierProvider $copyWithCreate(
    WindowStateNotifier Function() create,
  ) {
    return WindowStateNotifierProvider._(create: create);
  }

  @$internal
  @override
  WindowStateNotifierProvider $copyWithBuild(
    Raw<Future<WindowState>> Function(
      Ref<Raw<Future<WindowState>>>,
      WindowStateNotifier,
    ) build,
  ) {
    return WindowStateNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<WindowStateNotifier, Raw<Future<WindowState>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$windowStateNotifierHash() => r'929e42278b3ca7b70a11395dce93897096154217';

abstract class _$WindowStateNotifier extends $Notifier<Raw<Future<WindowState>>> {
  Raw<Future<WindowState>> build();

  @$internal
  @override
  Raw<Future<WindowState>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
