// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserNotifier)
final userProvider = UserNotifierProvider._();

final class UserNotifierProvider extends $NotifierProvider<UserNotifier, Raw<Future<User?>>> {
  UserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[dataManagerProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[UserNotifierProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = dataManagerProvider;

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

String _$userNotifierHash() => r'62ec3741f5b6df50a18c93439710469909ee73eb';

abstract class _$UserNotifier extends $Notifier<Raw<Future<User?>>> {
  Raw<Future<User?>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Raw<Future<User?>>, Raw<Future<User?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Raw<Future<User?>>, Raw<Future<User?>>>,
              Raw<Future<User?>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
