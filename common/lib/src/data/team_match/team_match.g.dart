// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMatch _$TeamMatchFromJson(Map<String, dynamic> json) {
  return TeamMatch(
    id: json['id'] as int?,
    home: Lineup.fromJson(json['home'] as Map<String, dynamic>),
    guest: Lineup.fromJson(json['guest'] as Map<String, dynamic>),
    referees: (json['referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList(),
    no: json['no'] as String?,
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
    ..weightClasses = (json['weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList()
    ..league = League.fromJson(json['league'] as Map<String, dynamic>)
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$TeamMatchToJson(TeamMatch instance) => <String, dynamic>{
      'id': instance.id,
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
      'no': instance.no,
      'league': instance.league,
      'maxRounds': instance.maxRounds,
      'home': instance.home,
      'guest': instance.guest,
    };
