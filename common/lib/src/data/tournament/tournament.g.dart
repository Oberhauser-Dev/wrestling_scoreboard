// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return Tournament(
    id: json['id'] as int?,
    name: json['name'] as String,
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    visitorsCount: json['visitorsCount'] as int?,
    comment: json['comment'] as String?,
  )
    ..no = json['no'] as String?
    ..roundDuration = Duration(microseconds: json['roundDuration'] as int)
    ..breakDuration = Duration(microseconds: json['breakDuration'] as int)
    ..activityDuration = Duration(microseconds: json['activityDuration'] as int)
    ..injuryDuration = Duration(microseconds: json['injuryDuration'] as int)
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$TournamentToJson(Tournament instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'no': instance.no,
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'name': instance.name,
      'roundDuration': instance.roundDuration.inMicroseconds,
      'breakDuration': instance.breakDuration.inMicroseconds,
      'activityDuration': instance.activityDuration.inMicroseconds,
      'injuryDuration': instance.injuryDuration.inMicroseconds,
      'maxRounds': instance.maxRounds,
    };
