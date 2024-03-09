// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubImpl _$$ClubImplFromJson(Map<String, dynamic> json) => _$ClubImpl(
      id: json['id'] as int?,
      name: json['name'] as String,
      organization: Organization.fromJson(json['organization'] as Map<String, dynamic>),
      no: json['no'] as String?,
    );

Map<String, dynamic> _$$ClubImplToJson(_$ClubImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'organization': instance.organization.toJson(),
      'no': instance.no,
    };
