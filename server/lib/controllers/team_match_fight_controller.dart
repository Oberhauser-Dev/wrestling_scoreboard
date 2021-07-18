import 'package:common/common.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';
import 'team_match_controller.dart';

class TeamMatchFightController extends EntityController<TeamMatchFight> {
  static final TeamMatchFightController _singleton = TeamMatchFightController._internal();

  factory TeamMatchFightController() {
    return _singleton;
  }

  TeamMatchFightController._internal() : super(tableName: 'team_match_fight');

  @override
  Future<TeamMatchFight> parseToClass(Map<String, dynamic> e) async {
    final teamMatch = await TeamMatchController().getSingle(e['team_match_id'] as int);
    final fight = await FightController().getSingle(e['fight_id'] as int);

    return TeamMatchFight(
      id: e['id'] as int?,
      teamMatch: teamMatch!,
      fight: fight!,
    );
  }
}
