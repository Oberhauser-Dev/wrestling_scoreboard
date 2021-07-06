// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMatch _$TeamMatchFromJson(Map<String, dynamic> json) {
  return TeamMatch(
    Lineup.fromJson(json['home'] as Map<String, dynamic>),
    Lineup.fromJson(json['guest'] as Map<String, dynamic>),
    Person.fromJson(json['referee'] as Map<String, dynamic>),
    id: json['id'] as int?,
    no: json['no'] as String?,
    location: json['location'] as String?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  )
    ..transcriptWriter = json['transcriptWriter'] == null
        ? null
        : Person.fromJson(json['transcriptWriter'] as Map<String, dynamic>)
    ..timeKeeper = json['timeKeeper'] == null
        ? null
        : Person.fromJson(json['timeKeeper'] as Map<String, dynamic>)
    ..matPresident = json['matPresident'] == null
        ? null
        : Person.fromJson(json['matPresident'] as Map<String, dynamic>)
    ..stewards = (json['stewards'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList()
    ..visitorsCount = json['visitorsCount'] as int
    ..comment = json['comment'] as String
    ..league = League.fromJson(json['league'] as Map<String, dynamic>)
    ..maxRounds = json['maxRounds'] as int
    ..weightClasses = (json['weightClasses'] as List<dynamic>)
        .map((e) => WeightClass.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$TeamMatchToJson(TeamMatch instance) => <String, dynamic>{
      'id': instance.id,
      'no': instance.no,
      'home': instance.home,
      'guest': instance.guest,
      'referee': instance.referee,
      'transcriptWriter': instance.transcriptWriter,
      'timeKeeper': instance.timeKeeper,
      'matPresident': instance.matPresident,
      'stewards': instance.stewards,
      'date': instance.date?.toIso8601String(),
      'location': instance.location,
      'visitorsCount': instance.visitorsCount,
      'comment': instance.comment,
      'league': instance.league,
      'maxRounds': instance.maxRounds,
      'weightClasses': instance.weightClasses,
    };
