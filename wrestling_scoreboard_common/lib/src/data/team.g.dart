// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamImpl _$$TeamImplFromJson(Map<String, dynamic> json) => _$TeamImpl(
      id: json['id'] as int?,
      name: json['name'] as String,
      club: Club.fromJson(json['club'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TeamImplToJson(_$TeamImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'club': instance.club.toJson(),
      'description': instance.description,
    };
