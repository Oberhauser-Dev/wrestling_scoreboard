// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lineup _$LineupFromJson(Map<String, dynamic> json) {
  return Lineup(
    team: Team.fromJson(json['team'] as Map<String, dynamic>),
    participantStatusList: (json['participantStatusList'] as List<dynamic>)
        .map((e) => ParticipantStatus.fromJson(e as Map<String, dynamic>))
        .toList(),
    leader: json['leader'] == null
        ? null
        : Person.fromJson(json['leader'] as Map<String, dynamic>),
    coach: json['coach'] == null
        ? null
        : Person.fromJson(json['coach'] as Map<String, dynamic>),
    tier: json['tier'] as int,
  );
}

Map<String, dynamic> _$LineupToJson(Lineup instance) => <String, dynamic>{
      'team': instance.team,
      'leader': instance.leader,
      'coach': instance.coach,
      'participantStatusList': instance.participantStatusList,
      'tier': instance.tier,
    };
