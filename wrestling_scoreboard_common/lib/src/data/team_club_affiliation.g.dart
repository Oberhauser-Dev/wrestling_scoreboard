// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_club_affiliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamClubAffiliationImpl _$$TeamClubAffiliationImplFromJson(Map<String, dynamic> json) => _$TeamClubAffiliationImpl(
      id: (json['id'] as num?)?.toInt(),
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      club: Club.fromJson(json['club'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TeamClubAffiliationImplToJson(_$TeamClubAffiliationImpl instance) => <String, dynamic>{
      'id': instance.id,
      'team': instance.team.toJson(),
      'club': instance.club.toJson(),
    };
