import 'package:common/common.dart';

import 'entity_controller.dart';

class TeamMatchFightController extends EntityController<TeamMatchFight> {
  static final TeamMatchFightController _singleton = TeamMatchFightController._internal();

  factory TeamMatchFightController() {
    return _singleton;
  }

  TeamMatchFightController._internal() : super(tableName: 'team_match_fight');
}
