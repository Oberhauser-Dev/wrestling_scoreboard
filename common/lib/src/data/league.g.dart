// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

League _$LeagueFromJson(Map<String, dynamic> json) {
  return League(
    name: json['name'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
  );
}

Map<String, dynamic> _$LeagueToJson(League instance) => <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'name': instance.name,
    };
