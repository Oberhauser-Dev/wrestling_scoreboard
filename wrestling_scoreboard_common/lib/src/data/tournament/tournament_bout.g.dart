// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_bout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentBoutImpl _$$TournamentBoutImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentBoutImpl(
      id: json['id'] as int?,
      tournament:
          Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
      bout: Bout.fromJson(json['bout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TournamentBoutImplToJson(
        _$TournamentBoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournament': instance.tournament.toJson(),
      'bout': instance.bout.toJson(),
    };
