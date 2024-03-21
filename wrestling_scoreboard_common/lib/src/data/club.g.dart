// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubImpl _$$ClubImplFromJson(Map<String, dynamic> json) => _$ClubImpl(
      id: json['id'] as int?,
      orgSyncId: json['orgSyncId'] as String?,
      organization: Organization.fromJson(json['organization'] as Map<String, dynamic>),
      name: json['name'] as String,
      no: json['no'] as String?,
    );

Map<String, dynamic> _$$ClubImplToJson(_$ClubImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization.toJson(),
      'name': instance.name,
      'no': instance.no,
    };
