// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UserNotifier)
const userNotifierProvider = UserNotifierProvider._();

final class UserNotifierProvider extends $NotifierProvider<UserNotifier, Raw<Future<User?>>> {
  const UserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userNotifierProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[dataManagerNotifierProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[UserNotifierProvider.$allTransitiveDependencies0],
      );

  static const $allTransitiveDependencies0 = dataManagerNotifierProvider;

  @override
  String debugGetCreateSourceHash() => _$userNotifierHash();

  @$internal
  @override
  UserNotifier create() => UserNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<User?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Raw<Future<User?>>>(value));
  }
}

String _$userNotifierHash() => r'c7e7df23f18e9c559245722e3c3281165a4f3120';

abstract class _$UserNotifier extends $Notifier<Raw<Future<User?>>> {
  Raw<Future<User?>> build();

  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<User?>>, Raw<Future<User?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<User?>>, Raw<Future<User?>>>,
              Raw<Future<User?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
