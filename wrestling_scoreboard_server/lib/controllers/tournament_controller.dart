import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'bout_controller.dart';

class TournamentController extends EntityController<Tournament> {
  static final TournamentController _singleton = TournamentController._internal();

  factory TournamentController() {
    return _singleton;
  }

  TournamentController._internal() : super(tableName: 'tournament');

  Future<Response> requestBouts(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(BoutController(),
        isRaw: isRaw(request), sqlQuery: '''
        SELECT f.* 
        FROM bout as f 
        JOIN tournament_bout AS tof ON tof.bout_id = f.id
        WHERE tof.tournament_id = $id;''');
  }

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {'comment': PostgreSQLDataType.text};
  }
}
