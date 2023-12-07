import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class TeamMatchBoutController extends EntityController<TeamMatchBout> {
  static final TeamMatchBoutController _singleton = TeamMatchBoutController._internal();

  factory TeamMatchBoutController() {
    return _singleton;
  }

  TeamMatchBoutController._internal() : super(tableName: 'team_match_bout');
}
