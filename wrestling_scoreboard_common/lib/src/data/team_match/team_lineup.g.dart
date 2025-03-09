// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamLineup _$TeamLineupFromJson(Map<String, dynamic> json) => _TeamLineup(
      id: (json['id'] as num?)?.toInt(),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      leader: json['leader'] == null ? null : Membership.fromJson(json['leader'] as Map<String, dynamic>),
      coach: json['coach'] == null ? null : Membership.fromJson(json['coach'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamLineupToJson(_TeamLineup instance) => <String, dynamic>{
      'id': instance.id,
      'team': instance.team.toJson(),
      'leader': instance.leader?.toJson(),
      'coach': instance.coach?.toJson(),
    };
