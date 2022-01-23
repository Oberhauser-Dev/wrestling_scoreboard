// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return Tournament(
    id: json['id'] as int?,
    name: json['name'] as String,
    ex_lineups: (json['ex_lineups'] as List<dynamic>)
        .map((e) => Lineup.fromJson(e as Map<String, dynamic>))
        .toList(),
    ex_weightClasses: (json['ex_weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList(),
    ex_referees: (json['ex_referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList(),
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    visitorsCount: json['visitorsCount'] as int?,
    comment: json['comment'] as String?,
  )
    ..ex_tanscriptWriters = (json['ex_tanscriptWriters'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_timeKeepers = (json['ex_timeKeepers'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_matPresidents = (json['ex_matPresidents'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..ex_stewards = (json['ex_stewards'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..no = json['no'] as String?
    ..ex_fights = (json['ex_fights'] as List<dynamic>)
        .map((e) => Fight.fromJson(e as Map<String, dynamic>))
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
      'ex_lineups': instance.ex_lineups.map((e) => e.toJson()).toList(),
      'ex_referees': instance.ex_referees.map((e) => e.toJson()).toList(),
      'ex_tanscriptWriters':
          instance.ex_tanscriptWriters.map((e) => e.toJson()).toList(),
      'ex_timeKeepers': instance.ex_timeKeepers.map((e) => e.toJson()).toList(),
      'ex_matPresidents':
          instance.ex_matPresidents.map((e) => e.toJson()).toList(),
      'ex_stewards': instance.ex_stewards.map((e) => e.toJson()).toList(),
      'date': instance.date?.toIso8601String(),
      'no': instance.no,
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'ex_fights': instance.ex_fights.map((e) => e.toJson()).toList(),
      'ex_weightClasses':
          instance.ex_weightClasses.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'roundDuration': instance.roundDuration.inMicroseconds,
      'breakDuration': instance.breakDuration.inMicroseconds,
      'activityDuration': instance.activityDuration.inMicroseconds,
      'injuryDuration': instance.injuryDuration.inMicroseconds,
      'maxRounds': instance.maxRounds,
    };
