import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'entity_controller.dart';
import 'participation_controller.dart';

class LineupController extends ShelfController<Lineup> {
  static final LineupController _singleton = LineupController._internal();

  factory LineupController() {
    return _singleton;
  }

  static final teamIdStmt =
      PostgresDb().connection.prepare(psql.Sql.named('SELECT team_id FROM lineup WHERE id = @id'));

  LineupController._internal() : super(tableName: 'lineup');

  Future<Response> requestParticipations(Request request, String id) async {
    return ParticipationController()
        .handleRequestMany(isRaw: request.isRaw, conditions: ['lineup_id = @id'], substitutionValues: {'id': id});
  }
}
