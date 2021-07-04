import 'package:json_annotation/json_annotation.dart';

part 'league.g.dart';

@JsonSerializable()
class League {
  static League outOfCompetition = League(name: 'Out of competition', startDate: DateTime(DateTime.now().year));
  DateTime startDate;
  String name;

  League({required this.name, required this.startDate});

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  Map<String, dynamic> toJson() => _$LeagueToJson(this);
}
