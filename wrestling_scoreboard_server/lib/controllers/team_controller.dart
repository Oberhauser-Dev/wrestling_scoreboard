import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/import_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/api.dart';

class TeamController extends ShelfController<Team> with OrganizationalController<Team>, ImportController<Team> {
  static final TeamController _singleton = TeamController._internal();

  factory TeamController() {
    return _singleton;
  }

  TeamController._internal() : super();

  static const teamMatchesQuery = '''
        SELECT tm.*
        FROM ${TeamMatch.cTableName} AS tm
        JOIN ${TeamLineup.cTableName} AS lu ON tm.home_id = lu.id OR tm.guest_id = lu.id
        WHERE lu.team_id = @id
        ORDER BY date;''';

  Future<Response> requestTeamMatches(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    return TeamMatchController().handleGetRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: teamMatchesQuery,
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  static const clubsQuery = '''
        SELECT c.*
        FROM ${Club.cTableName} AS c
        JOIN ${TeamClubAffiliation.cTableName} AS tca ON c.id = tca.club_id
        WHERE tca.team_id = @id
        ORDER BY c.name;''';

  Future<Response> requestClubs(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    return ClubController().handleGetRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: clubsQuery,
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
    );
  }

  @override
  Stream<double> import({
    required WrestlingApi apiProvider,
    required Team entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  }) async* {
    final totalSteps = 1 + (includeSubjacent ? 1 : 0);
    int step = 0;
    yield (++step) / totalSteps;
    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      // Nothing to do
      yield (++step) / totalSteps;
    }
    throw UnimplementedError('This operation is not supported yet!');
  }

  @override
  Organization? getOrganization(Team entity) {
    return entity.organization;
  }
}
