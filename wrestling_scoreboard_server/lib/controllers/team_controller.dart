import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class TeamController extends OrganizationalController<Team> {
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

  Future<Response> requestTeamMatches(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    return TeamMatchController().handleRequestManyFromQuery(
        isRaw: request.isRaw, sqlQuery: teamMatchesQuery, substitutionValues: {'id': id}, obfuscate: obfuscate);
  }

  Future<Response> import(Request request, User? user, String teamId) async {
    return Response.notFound('This operation is not supported yet!');
  }

  @override
  Set<String> getSearchableAttributes() => {'name', 'description'};
}
