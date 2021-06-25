import 'package:json_annotation/json_annotation.dart';

part 'league.g.dart';

@JsonSerializable()
class League {
  static League outOfCompetition = League(name: 'Out of competition', year: DateTime(DateTime.now().year));
  DateTime year;
  String name;

  League({required this.name, required this.year});

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  Map<String, dynamic> toJson() => _$LeagueToJson(this);
}
