import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'bout_controller.dart';
import 'entity_controller.dart';

class CompetitionController extends ShelfController<Competition> with ImportController {
  static final CompetitionController _singleton = CompetitionController._internal();

  factory CompetitionController() {
    return _singleton;
  }

  CompetitionController._internal() : super(tableName: 'competition');

  Future<Response> requestBouts(Request request, User? user, String id) async {
    return BoutController().handleRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: '''
        SELECT f.* 
        FROM bout as f 
        JOIN competition_bout AS tof ON tof.bout_id = f.id
        WHERE tof.competition_id = $id;''',
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Future<Response> import(Request request, User? user, String entityId) async {
    updateLastImportUtcDateTime(entityId);
    return Response.notFound('This operation is not supported yet!');
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'comment': psql.Type.text};
  }
}
