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
    weightClasses: (json['weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList(),
    referees: (json['referees'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>)),
    no: json['no'] as String?,
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    visitorsCount: json['visitorsCount'] as int?,
    comment: json['comment'] as String?,
  )
    ..transcriptWriters = (json['transcriptWriters'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..timeKeepers = (json['timeKeepers'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..matPresidents = (json['matPresidents'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..stewards = (json['stewards'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
    ..fights = (json['fights'] as List<dynamic>)
        .map((e) => Fight.fromJson(e as Map<String, dynamic>))
        .toList()
    ..league = League.fromJson(json['league'] as Map<String, dynamic>)
    ..maxRounds = json['maxRounds'] as int;
}

Map<String, dynamic> _$TeamMatchToJson(TeamMatch instance) => <String, dynamic>{
      'id': instance.id,
      'referees': instance.referees.toList(),
      'transcriptWriters': instance.transcriptWriters.toList(),
      'timeKeepers': instance.timeKeepers.toList(),
      'matPresidents': instance.matPresidents.toList(),
      'stewards': instance.stewards.toList(),
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
