// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_club_affiliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamClubAffiliation _$TeamClubAffiliationFromJson(Map<String, dynamic> json) => _TeamClubAffiliation(
  id: (json['id'] as num?)?.toInt(),
  team: Team.fromJson(json['team'] as Map<String, dynamic>),
  club: Club.fromJson(json['club'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeamClubAffiliationToJson(_TeamClubAffiliation instance) => <String, dynamic>{
  'id': instance.id,
  'team': instance.team.toJson(),
  'club': instance.club.toJson(),
};
