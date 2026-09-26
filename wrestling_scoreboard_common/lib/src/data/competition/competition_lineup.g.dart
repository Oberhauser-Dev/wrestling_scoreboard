// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition_lineup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompetitionLineup _$CompetitionLineupFromJson(Map<String, dynamic> json) => _CompetitionLineup(
  id: (json['id'] as num?)?.toInt(),
  competition: Competition.fromJson(json['competition'] as Map<String, dynamic>),
  club: Club.fromJson(json['club'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompetitionLineupToJson(_CompetitionLineup instance) => <String, dynamic>{
  'id': instance.id,
  'competition': instance.competition.toJson(),
  'club': instance.club.toJson(),
};
