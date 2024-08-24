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
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Raw<Future<User?>>>(value),
    );
  }

  @$internal
  @override
  UserNotifier create() => _createCb?.call() ?? UserNotifier();

  @$internal
  @override
  UserNotifierProvider $copyWithCreate(
    UserNotifier Function() create,
  ) {
    return UserNotifierProvider._(create: create);
  }

  @$internal
  @override
  UserNotifierProvider $copyWithBuild(
    Raw<Future<User?>> Function(
      Ref<Raw<Future<User?>>>,
      UserNotifier,
    ) build,
  ) {
    return UserNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<UserNotifier, Raw<Future<User?>>> $createElement(ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$userNotifierHash() => r'5cfac4dea161f15a98b2aecf867e76d5d41812ce';

abstract class _$UserNotifier extends $Notifier<Raw<Future<User?>>> {
  Raw<Future<User?>> build();

  @$internal
  @override
  Raw<Future<User?>> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
