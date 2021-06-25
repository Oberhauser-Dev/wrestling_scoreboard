// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

League _$LeagueFromJson(Map<String, dynamic> json) {
  return League(
    name: json['name'] as String,
    year: DateTime.parse(json['year'] as String),
  );
}

Map<String, dynamic> _$LeagueToJson(League instance) => <String, dynamic>{
      'year': instance.year.toIso8601String(),
      'name': instance.name,
    };
