// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match_fight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamMatchFightImpl _$$TeamMatchFightImplFromJson(Map<String, dynamic> json) =>
    _$TeamMatchFightImpl(
      id: json['id'] as int?,
      teamMatch: TeamMatch.fromJson(json['teamMatch'] as Map<String, dynamic>),
      fight: Fight.fromJson(json['fight'] as Map<String, dynamic>),
      pos: json['pos'] as int,
    );

Map<String, dynamic> _$$TeamMatchFightImplToJson(
        _$TeamMatchFightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamMatch': instance.teamMatch.toJson(),
      'fight': instance.fight.toJson(),
      'pos': instance.pos,
    };
