import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'data_object.dart';
import 'league.dart';

part 'team.g.dart';

@JsonSerializable()
class Team extends DataObject {
  final String name;
  final String? description;
  League? league;
  Club club;

  Team({int? id, required this.name, required this.club, this.description, this.league}) : super(id);

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
