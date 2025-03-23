// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionLineup _$CompetitionLineupFromJson(Map<String, dynamic> json) =>
    _CompetitionLineup(
      id: (json['id'] as num?)?.toInt(),
      competition:
          Competition.fromJson(json['competition'] as Map<String, dynamic>),
      club: Club.fromJson(json['club'] as Map<String, dynamic>),
      leader: json['leader'] == null
          ? null
          : Membership.fromJson(json['leader'] as Map<String, dynamic>),
      coach: json['coach'] == null
          ? null
          : Membership.fromJson(json['coach'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompetitionLineupToJson(_CompetitionLineup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'competition': instance.competition.toJson(),
      'club': instance.club.toJson(),
      'leader': instance.leader?.toJson(),
      'coach': instance.coach?.toJson(),
    };
