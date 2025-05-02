import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';

import 'bout_action_controller.dart';

class BoutController extends OrganizationalController<Bout> {
  static final BoutController _singleton = BoutController._internal();

  factory BoutController() {
    return _singleton;
  }

  BoutController._internal() : super();

  @override
  Future<bool> deleteSingle(int id) async {
    final boutRaw = await getSingleRaw(id, obfuscate: false);
    final redParticipantState = boutRaw['red_id'] as int?;
    final blueParticipantState = boutRaw['blue_id'] as int?;
    if (redParticipantState != null) await AthleteBoutStateController().deleteSingle(redParticipantState);
    if (blueParticipantState != null) await AthleteBoutStateController().deleteSingle(blueParticipantState);
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
