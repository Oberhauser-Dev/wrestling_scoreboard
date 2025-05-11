import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class ClubController extends OrganizationalController<Club> {
  static final ClubController _singleton = ClubController._internal();

  factory ClubController() {
    return _singleton;
  }

  ClubController._internal() : super();

  static const teamsQuery = '''
        SELECT t.*
        FROM ${Team.cTableName} AS t
        JOIN ${TeamClubAffiliation.cTableName} AS tca ON t.id = tca.team_id
        WHERE tca.club_id = @id
        ORDER BY t.name;''';

  Future<Response> requestTeams(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    return TeamController().handleGetRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: teamsQuery,
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }
}
