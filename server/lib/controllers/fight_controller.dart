import 'package:common/common.dart';

import 'entity_controller.dart';
import 'participant_state_controller.dart';
import 'weight_class_controller.dart';

class FightController extends EntityController<Fight> {
  static final FightController _singleton = FightController._internal();

  factory FightController() {
    return _singleton;
  }

  FightController._internal() : super(tableName: 'fight');

  @override
  Future<Fight> parseToClass(Map<String, dynamic> e) async {
    final redId = e['red_id'] as int?;
    final blueId = e['blue_id'] as int?;
    final r = redId == null ? null : await ParticipantStateController().getSingle(redId);
    final b = blueId == null ? null : await ParticipantStateController().getSingle(blueId);
    final weightClass = await WeightClassController().getSingle(e['weight_class_id'] as int);
    return Fight(id: e[primaryKeyName] as int?, r: r, b: b, weightClass: weightClass!);
  }

  @override
  PostgresMap parseFromClass(Fight e) {
    return PostgresMap({
      if (e.id != null) primaryKeyName: e.id,
      'red_id': e.r?.id,
      'blue_id': e.b?.id,
      'weight_class_id': e.weightClass.id,
    });
  }
}
