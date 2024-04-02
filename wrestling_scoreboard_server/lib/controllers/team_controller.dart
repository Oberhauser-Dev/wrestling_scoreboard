import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';

class TeamController extends EntityController<Team> {
  static final TeamController _singleton = TeamController._internal();

  factory TeamController() {
    return _singleton;
  }

  TeamController._internal() : super(tableName: 'team');

  static const teamMatchesQuery = '''
        SELECT tm.*
        FROM team_match AS tm
        JOIN lineup AS lu ON tm.home_id = lu.id OR tm.guest_id = lu.id
        WHERE lu.team_id = @id
        ORDER BY date;''';

  Future<Response> requestTeamMatches(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(TeamMatchController(),
        isRaw: isRaw(request), sqlQuery: teamMatchesQuery, substitutionValues: {'id': id});
  }
}
