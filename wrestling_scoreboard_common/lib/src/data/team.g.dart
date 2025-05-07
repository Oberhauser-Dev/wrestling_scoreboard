// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => _Team(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'name': instance.name,
      'description': instance.description,
    };
