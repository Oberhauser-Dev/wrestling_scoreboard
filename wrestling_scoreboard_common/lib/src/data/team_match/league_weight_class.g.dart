// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueWeightClassImpl _$$LeagueWeightClassImplFromJson(Map<String, dynamic> json) => _$LeagueWeightClassImpl(
      id: (json['id'] as num?)?.toInt(),
      orgSyncId: json['orgSyncId'] as String?,
      organization:
          json['organization'] == null ? null : Organization.fromJson(json['organization'] as Map<String, dynamic>),
      pos: (json['pos'] as num).toInt(),
      league: League.fromJson(json['league'] as Map<String, dynamic>),
      weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
      seasonPartition: (json['seasonPartition'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LeagueWeightClassImplToJson(_$LeagueWeightClassImpl instance) => <String, dynamic>{
      'id': instance.id,
      'orgSyncId': instance.orgSyncId,
      'organization': instance.organization?.toJson(),
      'pos': instance.pos,
      'league': instance.league.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'seasonPartition': instance.seasonPartition,
    };