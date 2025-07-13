// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(WindowStateNotifier)
const windowStateNotifierProvider = WindowStateNotifierProvider._();

final class WindowStateNotifierProvider extends $NotifierProvider<WindowStateNotifier, Raw<Future<WindowState>>> {
  const WindowStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowStateNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowStateNotifierHash();

  @$internal
  @override
  WindowStateNotifier create() => WindowStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<WindowState>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<WindowState>>>(value));
  }
}

String _$windowStateNotifierHash() => r'c450d92ac1e13d9404d9adb1e68f47177fb150f0';

abstract class _$WindowStateNotifier extends $Notifier<Raw<Future<WindowState>>> {
  Raw<Future<WindowState>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<WindowState>>, Raw<Future<WindowState>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<WindowState>>, Raw<Future<WindowState>>>,
              Raw<Future<WindowState>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
