// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Club _$ClubFromJson(Map<String, dynamic> json) => _Club(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      no: json['no'] as String?,
    );

Map<String, dynamic> _$ClubToJson(_Club instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization.toJson(),
      'name': instance.name,
      'no': instance.no,
    };
