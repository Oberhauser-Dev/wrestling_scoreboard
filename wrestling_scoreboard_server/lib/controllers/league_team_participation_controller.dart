import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class LeagueTeamParticipationController extends ShelfController<LeagueTeamParticipation> {
  static final LeagueTeamParticipationController _singleton = LeagueTeamParticipationController._internal();

  factory LeagueTeamParticipationController() {
    return _singleton;
  }

  LeagueTeamParticipationController._internal() : super();

  Future<LeagueTeamParticipation?> getByLeagueAndTeamId({
    required int teamId,
    required int leagueId,
    required obfuscate,
  }) async {
    final many = await getMany(
        conditions: ['team_id = @teamId', 'league_id = @leagueId'],
        substitutionValues: {'teamId': teamId, 'leagueId': leagueId},
        obfuscate: obfuscate);
    return many.zeroOrOne;
  }
}
