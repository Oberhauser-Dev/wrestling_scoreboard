import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class ClubController extends OrganizationalController<Club> {
  static final ClubController _singleton = ClubController._internal();

  factory ClubController() {
    return _singleton;
  }

  ClubController._internal() : super(tableName: 'club');

  static const teamsQuery = '''
        SELECT t.*
        FROM team AS t
        JOIN team_club_affiliation AS tca ON t.id = tca.team_id
        WHERE tca.club_id = @id
        ORDER BY t.name;''';

  Future<Response> requestTeams(Request request, User? user, String id) async {
    final bool obfuscate = user?.obfuscate ?? true;
    return TeamController().handleRequestManyFromQuery(
        isRaw: request.isRaw, sqlQuery: teamsQuery, substitutionValues: {'id': id}, obfuscate: obfuscate);
  }

  Future<Response> requestMemberships(Request request, User? user, String id) async {
    return MembershipController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['club_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }
}
