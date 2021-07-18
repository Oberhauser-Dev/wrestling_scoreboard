import 'package:json_annotation/json_annotation.dart';

import '../data_object.dart';
import '../fight.dart';
import 'team_match.dart';

part 'team_match_fight.g.dart';

@JsonSerializable()
class TeamMatchFight extends DataObject {
  final TeamMatch teamMatch;
  final Fight fight;

  TeamMatchFight({int? id, required this.teamMatch, required this.fight}) : super(id);
}
