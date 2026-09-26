import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

class TeamLineupController extends ShelfController<TeamLineup> {
  static final TeamLineupController _singleton = TeamLineupController._internal();

  factory TeamLineupController() {
    return _singleton;
  }

  static final teamIdStmt = PostgresDb().connection.prepare(
    psql.Sql.named('SELECT team_id FROM ${TeamLineup.cTableName} WHERE id = @id'),
  );

  TeamLineupController._internal() : super();
}
