import 'package:json_annotation/json_annotation.dart';

import 'club.dart';
import 'league.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  String? id;
  final String name;
  final String? description;
  League? league;
  Club club;

  Team({required this.name, required this.club, this.description, this.league});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
