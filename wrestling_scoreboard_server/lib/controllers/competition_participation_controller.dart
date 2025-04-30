import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';

import 'entity_controller.dart';

class CompetitionParticipationController extends ShelfController<TeamLineupParticipation> {
  static final CompetitionParticipationController _singleton = CompetitionParticipationController._internal();

  factory CompetitionParticipationController() {
    return _singleton;
  }

  CompetitionParticipationController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'weight': psql.Type.numeric};
  }
}
