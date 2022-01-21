import 'package:common/common.dart';
import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/team_match_controller.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'league_controller.dart';

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
        WHERE lu.team_id = @id;''';

  Future<Response> requestTeamMatches(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(TeamMatchController(),
        isRaw: isRaw(request), sqlQuery: teamMatchesQuery, substitutionValues: {'id': id});
  }

  @override
  Future<Team> parseFromRaw(Map<String, dynamic> e) async {
    final club = await ClubController().getSingle(e['club_id'] as int);
    final leagueId = e['league_id'] as int?;
    final league = leagueId == null ? null : await LeagueController().getSingle(leagueId);
    return Team(
        id: e[primaryKeyName] as int?,
        name: e['name'] as String,
        club: club!,
        description: e['description'] as String?,
        league: league);
  }
}
