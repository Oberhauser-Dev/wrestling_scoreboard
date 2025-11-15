import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'remote_config.freezed.dart';
part 'remote_config.g.dart';

@freezed
abstract class RemoteConfig with _$RemoteConfig {
  const RemoteConfig._();

  const factory RemoteConfig({required Migration migration, @Default(false) bool hasEmailVerification}) = _RemoteConfig;

  factory RemoteConfig.fromJson(Map<String, Object?> json) => _$RemoteConfigFromJson(json);

  static const cTableName = 'remote_config';
}
