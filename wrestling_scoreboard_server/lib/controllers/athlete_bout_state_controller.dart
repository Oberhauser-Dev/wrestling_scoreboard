import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;

import 'entity_controller.dart';

class AthleteBoutStateController extends ShelfController<AthleteBoutState> {
  static final AthleteBoutStateController _singleton = AthleteBoutStateController._internal();

  factory AthleteBoutStateController() {
    return _singleton;
  }

  AthleteBoutStateController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'classification_points': psql.Type.smallInteger};
  }
}
