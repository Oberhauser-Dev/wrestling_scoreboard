// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_weight_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueWeightClass _$LeagueWeightClassFromJson(Map<String, dynamic> json) {
  return LeagueWeightClass(
    id: json['id'] as int?,
    league: League.fromJson(json['league'] as Map<String, dynamic>),
    weightClass:
        WeightClass.fromJson(json['weightClass'] as Map<String, dynamic>),
    pos: json['pos'] as int,
  );
}

Map<String, dynamic> _$LeagueWeightClassToJson(LeagueWeightClass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pos': instance.pos,
      'league': instance.league,
      'weightClass': instance.weightClass,
    };
