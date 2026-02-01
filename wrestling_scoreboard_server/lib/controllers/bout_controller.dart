import 'package:postgres/postgres.dart' as psql;
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';

class BoutController extends ShelfController<Bout> with OrganizationalController<Bout> {
  static final BoutController _singleton = BoutController._internal();

  factory BoutController() {
    return _singleton;
  }

  BoutController._internal() : super();

  @override
  Future<bool> deleteSingle(int id) async {
    final boutRaw = await getSingleRaw(id, obfuscate: false);
    // Delete entities referencing the bout
    await BoutActionController().deleteMany(conditions: ['bout_id=@id'], substitutionValues: {'id': id});
    final success = await super.deleteSingle(id);
    // Delete entities referenced by the bout
    final redParticipantState = boutRaw['red_id'] as int?;
    final blueParticipantState = boutRaw['blue_id'] as int?;
    if (redParticipantState != null) await AthleteBoutStateController().deleteSingle(redParticipantState);
    if (blueParticipantState != null) await AthleteBoutStateController().deleteSingle(blueParticipantState);
    return success;
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'winner_role': null, 'bout_result': null, 'comment': psql.Type.text};
  }

  @override
  Future<Response> handlePostRequestSingle(Map<String, Object?> json) async {
    final res = await super.handlePostRequestSingle(json);
    final updatedBout = parseSingleJson<Bout>(json);
    await processOnResult(updatedBout);
    return res;
  }

  Future<void> processOnResult(Bout updatedBout) async {
    final obfuscate = false;
    if (updatedBout.id != null && updatedBout.result != null) {
      // Take action after a bout has finished
      final teamMatchBouts = await TeamMatchBoutController().getByBout(updatedBout.id!, obfuscate: obfuscate);
      if (teamMatchBouts.isNotEmpty) {
        await TeamMatchBoutController().processOnResult(teamMatchBouts.first);
      } else {
        final competitionBouts = await CompetitionBoutController().getByBout(updatedBout.id!, obfuscate: obfuscate);
        if (competitionBouts.isNotEmpty) {
          await CompetitionBoutController().processOnResult(competitionBouts.first);
        }
      }
    }
  }
}
