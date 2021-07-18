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
      id: e['id'] as int?,
      actionType: fightActionTypeDecode(e['action_type']),
      duration: e['duration'],
      role: fightRoleDecode(e['role']),
      pointCount: e['point_count'] as int?,
    );
  }
}
