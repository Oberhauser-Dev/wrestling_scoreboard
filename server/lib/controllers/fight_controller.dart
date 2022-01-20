import 'package:common/common.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'fight_action_controller.dart';
import 'participant_state_controller.dart';
import 'weight_class_controller.dart';

class FightController extends EntityController<Fight> {
  static final FightController _singleton = FightController._internal();

  factory FightController() {
    return _singleton;
  }

  FightController._internal() : super(tableName: 'fight');

  Future<Response> requestFightActions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(FightActionController(),
        isRaw: isRaw(request), conditions: ['fight_id = @id'], substitutionValues: {'id': id});
  }

  @override
  Future<Fight> parseToClass(Map<String, dynamic> e) async {
    final redId = e['red_id'] as int?;
    final blueId = e['blue_id'] as int?;
    final winner = e['winner'] as String?;
    final fightResult = e['fight_result'] as String?;
    final weightClass = await WeightClassController().getSingle(e['weight_class_id'] as int);
    final durationMillis = e['duration_millis'] as int?;
    return Fight(
      id: e[primaryKeyName] as int?,
      r: redId == null ? null : await ParticipantStateController().getSingle(redId),
      b: blueId == null ? null : await ParticipantStateController().getSingle(blueId),
      weightClass: weightClass!,
      winner: winner == null ? null : FightRoleParser.valueOf(winner),
      result: fightResult == null ? null : FightResultParser.valueOf(fightResult),
      duration: durationMillis == null ? Duration() : Duration(milliseconds: durationMillis),
    );
  }

  @override
  PostgresMap parseFromClass(Fight e) {
    return PostgresMap({
      if (e.id != null) primaryKeyName: e.id,
      'red_id': e.r?.id,
      'blue_id': e.b?.id,
      'weight_class_id': e.weightClass.id,
      'winner': e.winner?.name,
      'fight_result': e.result?.name,
      'duration_millis': e.duration.inMilliseconds,
    });
  }
}
