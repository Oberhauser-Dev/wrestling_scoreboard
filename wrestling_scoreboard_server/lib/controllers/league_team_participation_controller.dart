import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class LeagueTeamParticipationController extends ShelfController<LeagueTeamParticipation> {
  static final LeagueTeamParticipationController _singleton = LeagueTeamParticipationController._internal();

  factory LeagueTeamParticipationController() {
    return _singleton;
  }

  LeagueTeamParticipationController._internal() : super(tableName: 'league_team_participation');
}
