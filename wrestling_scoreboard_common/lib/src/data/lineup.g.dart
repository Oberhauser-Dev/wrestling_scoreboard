// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lineup _$LineupFromJson(Map<String, dynamic> json) => _Lineup(
      id: (json['id'] as num?)?.toInt(),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      leader: json['leader'] == null ? null : Membership.fromJson(json['leader'] as Map<String, dynamic>),
      coach: json['coach'] == null ? null : Membership.fromJson(json['coach'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LineupToJson(_Lineup instance) => <String, dynamic>{
      'id': instance.id,
      'team': instance.team.toJson(),
      'leader': instance.leader?.toJson(),
      'coach': instance.coach?.toJson(),
    };
