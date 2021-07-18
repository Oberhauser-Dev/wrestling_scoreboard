// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return Tournament(
    id: json['id'] as int?,
    name: json['name'] as String,
    lineups: (json['lineups'] as List<dynamic>)
        .map((e) => Lineup.fromJson(e as Map<String, dynamic>))
        .toList(),
    weightClasses: (json['weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList(),
    referees: (json['referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList(),
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  )
    ..transcriptWriters = (json['transcriptWriters'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList()
    ..timeKeepers = (json['timeKeepers'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList()
    ..matPresidents = (json['matPresidents'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList()
    ..stewards = (json['stewards'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList()
    ..visitorsCount = json['visitorsCount'] as int
    ..comment = json['comment'] as String
    ..fights = (json['fights'] as List<dynamic>?)
        ?.map((e) => Fight.fromJson(e as Map<String, dynamic>))
        .toList()
    ..roundDuration = Duration(microseconds: json['roundDuration'] as int)
    ..breakDuration = Duration(microseconds: json['breakDuration'] as int)
    ..activityDuration = Duration(microseconds: json['activityDuration'] as int)
    ..injuryDuration = Duration(microseconds: json['injuryDuration'] as int)
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$TournamentToJson(Tournament instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lineups': instance.lineups,
      'referees': instance.referees,
      'transcriptWriters': instance.transcriptWriters,
      'timeKeepers': instance.timeKeepers,
      'matPresidents': instance.matPresidents,
      'stewards': instance.stewards,
      'date': instance.date?.toIso8601String(),
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'fights': instance.fights,
      'weightClasses': instance.weightClasses,
      'name': instance.name,
      'roundDuration': instance.roundDuration.inMicroseconds,
      'breakDuration': instance.breakDuration.inMicroseconds,
      'activityDuration': instance.activityDuration.inMicroseconds,
      'injuryDuration': instance.injuryDuration.inMicroseconds,
      'maxRounds': instance.maxRounds,
    };
