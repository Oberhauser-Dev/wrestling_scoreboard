// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match_bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamMatchBoutImpl _$$TeamMatchBoutImplFromJson(Map<String, dynamic> json) => _$TeamMatchBoutImpl(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      pos: (json['pos'] as num).toInt(),
      teamMatch: TeamMatch.fromJson(json['teamMatch'] as Map<String, dynamic>),
      bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TeamMatchBoutImplToJson(_$TeamMatchBoutImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'pos': instance.pos,
      'teamMatch': instance.teamMatch.toJson(),
      'bout': instance.bout.toJson(),
    };
