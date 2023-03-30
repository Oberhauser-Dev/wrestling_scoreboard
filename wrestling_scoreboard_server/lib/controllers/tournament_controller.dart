import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';

class TournamentController extends EntityController<Tournament> {
  static final TournamentController _singleton = TournamentController._internal();

  factory TournamentController() {
    return _singleton;
  }

  TournamentController._internal() : super(tableName: 'tournament');

  Future<Response> requestFights(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(FightController(),
        isRaw: isRaw(request), sqlQuery: '''
        SELECT f.* 
        FROM fight as f 
        JOIN tournament_fight AS tof ON tof.fight_id = f.id
        WHERE tof.tournament_id = $id;''');
  }

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {'comment': PostgreSQLDataType.text};
  }
}
