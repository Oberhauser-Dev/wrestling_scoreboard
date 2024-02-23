// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueImpl _$$LeagueImplFromJson(Map<String, dynamic> json) => _$LeagueImpl(
      id: json['id'] as int?,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      boutConfig: BoutConfig.fromJson(json['boutConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LeagueImplToJson(_$LeagueImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'boutConfig': instance.boutConfig.toJson(),
    };
