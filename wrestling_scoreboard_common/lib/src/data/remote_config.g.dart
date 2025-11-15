// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoteConfig _$RemoteConfigFromJson(Map<String, dynamic> json) => _RemoteConfig(
  migration: Migration.fromJson(json['migration'] as Map<String, dynamic>),
  hasEmailVerification: json['hasEmailVerification'] as bool? ?? false,
);

Map<String, dynamic> _$RemoteConfigToJson(_RemoteConfig instance) => <String, dynamic>{
  'migration': instance.migration.toJson(),
  'hasEmailVerification': instance.hasEmailVerification,
};
