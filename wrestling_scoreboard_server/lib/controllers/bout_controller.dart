import 'dart:convert';

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
    final updatedBout = parseSingleJson<Bout>(json);
    // A created bout may also carry an id (e.g. on import), but does not exist yet.
    if (json['operation'] == CRUD.update.name && updatedBout.id != null) {
      // Skip the update (and its side effects), if the bout has not changed
      // We purposely do not process further the result, as e.g. time is autosaved without actively changing the result.
      // Otherwise we would override a customized existing result, by just seeing the bout view.
      // We could probably solve this by calling a dedicated endpoint just when the result is changed,
      // which processes the result (may or may not update the team match points).
      //
      // The result should not update only by changing the actions or the bouts participant states.
      // So it is always ensured the processing of the result is only happening when the bout result has actually changed.
      final oldBout = await getSingle(updatedBout.id!, obfuscate: false);
      if (oldBout == updatedBout) {
        return Response.ok(jsonEncode(updatedBout.id));
      }
    }
    final res = await super.handlePostRequestSingle(json);
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
