import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'bout_controller.dart';

class CompetitionController extends EntityController<Competition> {
  static final CompetitionController _singleton = CompetitionController._internal();

  factory CompetitionController() {
    return _singleton;
  }

  CompetitionController._internal() : super(tableName: 'competition');

  Future<Response> requestBouts(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(BoutController(),
        isRaw: isRaw(request), sqlQuery: '''
        SELECT f.* 
        FROM bout as f 
        JOIN competition_bout AS tof ON tof.bout_id = f.id
        WHERE tof.competition_id = $id;''');
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'comment': psql.Type.text};
  }
}
