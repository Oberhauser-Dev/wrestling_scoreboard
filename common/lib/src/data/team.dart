import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'data_object.dart';
import 'league.dart';

part 'team.g.dart';

/// The team of a club.
@JsonSerializable()
class Team extends DataObject {
  final String name;
  final String? description;
  League? league;
  Club club;

  Team({int? id, required this.name, required this.club, this.description, this.league}) : super(id);

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TeamToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'club_id': club.id,
      'league_id': league?.id,
    };
  }
}
