import 'package:common/common.dart';
import 'package:postgres/postgres.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';

class FightActionController extends EntityController<FightAction> {
  static final FightActionController _singleton = FightActionController._internal();

  factory FightActionController() {
    return _singleton;
  }

  FightActionController._internal() : super(tableName: 'fight_action');

  @override
  Future<FightAction> parseFromRaw(Map<String, dynamic> e) async {
    return FightAction(
      id: e[primaryKeyName] as int?,
      actionType: FightActionTypeParser.valueOf(e['action_type']),
      duration: Duration(milliseconds: e['duration_millis']),
      role: FightRoleParser.valueOf(e['fight_role']),
      pointCount: e['point_count'] as int?,
      fight: (await FightController().getSingle(e['fight_id'] as int))!,
    );
  }

  @override
  Map<String, PostgreSQLDataType> getPostgresDataTypes() {
    return {
      'point_count': PostgreSQLDataType.smallInteger
    };
  }
}
