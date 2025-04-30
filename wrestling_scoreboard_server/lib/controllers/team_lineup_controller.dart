import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'entity_controller.dart';
import 'participation_controller.dart';

class TeamLineupController extends ShelfController<TeamLineup> {
  static final TeamLineupController _singleton = TeamLineupController._internal();

  factory TeamLineupController() {
    return _singleton;
  }

  static final teamIdStmt =
      PostgresDb().connection.prepare(psql.Sql.named('SELECT team_id FROM ${TeamLineup.cTableName} WHERE id = @id'));

  TeamLineupController._internal() : super();

  Future<List<TeamLineup>> getByLeader(User? user, int id) async {
    return await getMany(
      conditions: ['leader_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamLineup>> getByCoach(User? user, int id) async {
    return await getMany(
      conditions: ['coach_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestParticipations(Request request, User? user, String id) async {
    return TeamLineupParticipationController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['lineup_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }
}
