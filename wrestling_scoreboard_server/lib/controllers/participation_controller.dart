import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;

import 'entity_controller.dart';

class ParticipationController extends ShelfController<Participation> {
  static final ParticipationController _singleton = ParticipationController._internal();

  factory ParticipationController() {
    return _singleton;
  }

  ParticipationController._internal() : super(tableName: 'participation');

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'weight': psql.Type.numeric};
  }
}
