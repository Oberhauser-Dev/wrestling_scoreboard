// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueWeightClassImpl _$$LeagueWeightClassImplFromJson(Map<String, dynamic> json) => _$LeagueWeightClassImpl(
      id: json['id'] as int?,
      pos: json['pos'] as int,
      league: League.fromJson(json['league'] as Map<String, dynamic>),
      weightClass: WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
      seasonPartition: json['seasonPartition'] as int?,
    );

Map<String, dynamic> _$$LeagueWeightClassImplToJson(_$LeagueWeightClassImpl instance) => <String, dynamic>{
      'id': instance.id,
      'pos': instance.pos,
      'league': instance.league.toJson(),
      'weightClass': instance.weightClass.toJson(),
      'seasonPartition': instance.seasonPartition,
    };
