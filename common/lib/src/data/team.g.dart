// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team(
    id: json['id'] as int?,
    name: json['name'] as String,
    club: Club.fromJson(json['club'] as Map<String, dynamic>),
    description: json['description'] as String?,
    league: json['league'] == null
        ? null
        : League.fromJson(json['league'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'league': instance.league?.toJson(),
      'club': instance.club.toJson(),
    };
