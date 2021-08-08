import 'package:common/common.dart';

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
      duration: e['duration'],
      role: FightRoleParser.valueOf(e['role']),
      pointCount: e['point_count'] as int?,
    );
  }

  @override
  Map<String, dynamic> parseFromClass(FightAction e) {
    return {
      if (e.id != null) primaryKeyName: e.id,
      'action_type': e.actionType.name,
      'duration': e.duration,
      'role': e.role.name,
      'point_count': e.pointCount,
    };
  }
}
