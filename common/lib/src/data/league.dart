import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';

part 'league.g.dart';

/// The league in which the team is fighting.
@JsonSerializable()
class League extends DataObject {
  static League outOfCompetition = League(name: 'Out of competition', startDate: DateTime(DateTime.now().year));
  DateTime startDate;
  String name;

  League({int? id, required this.name, required this.startDate}) : super(id);

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  Map<String, dynamic> toJson() => _$LeagueToJson(this);
}
