import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';

class FightActionController extends EntityController<FightAction> {
  static final FightActionController _singleton = FightActionController._internal();

  factory FightActionController() {
    return _singleton;
  }

  FightActionController._internal() : super(tableName: 'fight_action');

  @override
  Map<String, PostgreSQLDataType?> getPostgresDataTypes() {
    return {
      'point_count': PostgreSQLDataType.smallInteger,
      'fight_role': null,
      'action_type': null,
    };
  }
}
