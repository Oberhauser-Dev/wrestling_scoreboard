import 'package:wrestling_scoreboard_common/common.dart';
import 'package:postgres/postgres.dart' as psql;

import 'entity_controller.dart';

class BoutActionController extends EntityController<BoutAction> {
  static final BoutActionController _singleton = BoutActionController._internal();

  factory BoutActionController() {
    return _singleton;
  }

  BoutActionController._internal() : super(tableName: 'bout_action');

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'point_count': psql.Type.smallInteger,
      'bout_role': null,
      'action_type': null,
    };
  }
}
