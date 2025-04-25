import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;

import 'entity_controller.dart';

class ParticipantStateController extends ShelfController<AthleteBoutState> {
  static final ParticipantStateController _singleton = ParticipantStateController._internal();

  factory ParticipantStateController() {
    return _singleton;
  }

  ParticipantStateController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'classification_points': psql.Type.smallInteger};
  }
}
