// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineupImpl _$$LineupImplFromJson(Map<String, dynamic> json) => _$LineupImpl(
      id: json['id'] as int?,
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      leader: json['leader'] == null
          ? null
          : Membership.fromJson(json['leader'] as Map<String, dynamic>),
      coach: json['coach'] == null
          ? null
          : Membership.fromJson(json['coach'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LineupImplToJson(_$LineupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'team': instance.team.toJson(),
      'leader': instance.leader?.toJson(),
      'coach': instance.coach?.toJson(),
    };
