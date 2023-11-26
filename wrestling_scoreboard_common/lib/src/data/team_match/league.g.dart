// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

League _$LeagueFromJson(Map<String, dynamic> json) => League(
      id: json['id'] as int?,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      boutConfig:
          BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeagueToJson(League instance) => <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'name': instance.name,
      'boutConfig': instance.boutConfig.toJson(),
    };
