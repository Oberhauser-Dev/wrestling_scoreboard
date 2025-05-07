// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UserNotifier)
const userNotifierProvider = UserNotifierProvider._();

final class UserNotifierProvider extends $NotifierProvider<UserNotifier, Raw<Future<User?>>> {
  const UserNotifierProvider._({super.runNotifierBuildOverride, UserNotifier Function()? create})
    : _createCb = create,
      super(
        from: null,
        argument: null,
        retry: null,
        name: r'userNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        allTransitiveDependencies: null,
      );

  final UserNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$userNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<Future<User?>> value) {
    return $ProviderOverride(origin: this, providerOverride: $ValueProvider<Raw<Future<User?>>>(value));
  }

  @$internal
  @override
  UserNotifier create() => _createCb?.call() ?? UserNotifier();

  @$internal
  @override
  UserNotifierProvider $copyWithCreate(UserNotifier Function() create) {
    return UserNotifierProvider._(create: create);
  }

  @$internal
  @override
  UserNotifierProvider $copyWithBuild(Raw<Future<User?>> Function(Ref, UserNotifier) build) {
    return UserNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<UserNotifier, Raw<Future<User?>>> $createElement($ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$userNotifierHash() => r'36bea4cc9b89f18b89d1fd78203395da8209b59d';

abstract class _$UserNotifier extends $Notifier<Raw<Future<User?>>> {
  Raw<Future<User?>> build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Raw<Future<User?>>>;
    final element =
        ref.element as $ClassProviderElement<NotifierBase<Raw<Future<User?>>>, Raw<Future<User?>>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
