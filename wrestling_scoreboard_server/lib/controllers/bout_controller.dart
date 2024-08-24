import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/participant_state_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'bout_action_controller.dart';
import 'entity_controller.dart';

class BoutController extends ShelfController<Bout> {
  static final BoutController _singleton = BoutController._internal();

  factory BoutController() {
    return _singleton;
  }

  BoutController._internal() : super(tableName: 'bout');

  Future<Response> requestBoutActions(Request request, String id) async {
    return BoutActionController()
        .handleRequestMany(isRaw: request.isRaw, conditions: ['bout_id = @id'], substitutionValues: {'id': id});
  }

  @override
  Future<bool> deleteSingle(int id) async {
    final boutRaw = await getSingleRaw(id);
    final redParticipantState = boutRaw['red_id'] as int?;
    final blueParticipantState = boutRaw['blue_id'] as int?;
    if (redParticipantState != null) await ParticipantStateController().deleteSingle(redParticipantState);
    if (blueParticipantState != null) await ParticipantStateController().deleteSingle(blueParticipantState);
    await BoutActionController().deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': id});
    return super.deleteSingle(id);
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'winner_role': null,
      'bout_result': null,
    };
  }
}
