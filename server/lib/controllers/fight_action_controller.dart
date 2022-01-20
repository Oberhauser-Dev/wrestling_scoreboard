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
  Future<FightAction> parseToClass(Map<String, dynamic> e) async {
    return FightAction(
      id: e[primaryKeyName] as int?,
      actionType: FightActionTypeParser.valueOf(e['action_type']),
      duration: Duration(milliseconds: e['duration_millis']),
      role: FightRoleParser.valueOf(e['fight_role']),
      pointCount: e['point_count'] as int?,
    );
  }

  @override
  PostgresMap parseFromClass(FightAction e) {
    return PostgresMap({
      if (e.id != null) primaryKeyName: e.id,
      'action_type': e.actionType.name,
      'duration_millis': e.duration.inMilliseconds,
      'fight_role': e.role.name,
      'point_count': e.pointCount,
    }, {
      'point_count': PostgreSQLDataType.smallInteger
    });
  }
}
