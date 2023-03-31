// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tournament _$TournamentFromJson(Map<String, dynamic> json) => Tournament(
      id: json['id'] as int?,
      name: json['name'] as String,
      boutConfig:
          BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
      location: json['location'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      visitorsCount: json['visitorsCount'] as int?,
      comment: json['comment'] as String?,
    )..no = json['no'] as String?;

Map<String, dynamic> _$TournamentToJson(Tournament instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'no': instance.no,
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'name': instance.name,
      'boutConfig': instance.boutConfig.toJson(),
    };
