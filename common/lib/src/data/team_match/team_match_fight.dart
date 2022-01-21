import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import 'team_match.dart';

part 'team_match_fight.g.dart';

@JsonSerializable()
class TeamMatchFight extends DataObject {
  int pos;
  TeamMatch teamMatch;
  Fight fight;

  TeamMatchFight({int? id, required this.teamMatch, required this.fight, required this.pos}) : super(id);

  factory TeamMatchFight.fromJson(Map<String, dynamic> json) => _$TeamMatchFightFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TeamMatchFightToJson(this);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'team_match_id': teamMatch.id,
      'fight_id': fight.id,
    };
  }
}
