// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserNotifier)
const userProvider = UserNotifierProvider._();

final class UserNotifierProvider extends $NotifierProvider<UserNotifier, Raw<Future<User?>>> {
  const UserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[dataManagerProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[UserNotifierProvider.$allTransitiveDependencies0],
      );

  static const $allTransitiveDependencies0 = dataManagerProvider;

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

String _$userNotifierHash() => r'20cb097680c55f94eb419148f60c3acef8d98370';

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
