import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';

class TeamMatchBoutController extends ShelfController<TeamMatchBout>
    with OrganizationalController<TeamMatchBout>, OrderableController<TeamMatchBout> {
  static final TeamMatchBoutController _singleton = TeamMatchBoutController._internal();

  TeamMatchBoutController._internal() : super();

  factory TeamMatchBoutController() {
    return _singleton;
  }

  @override
  Future<bool> deleteSingle(int id) async {
    final teamMatchBoutRaw = await getSingleRaw(id, obfuscate: false);
    final boutId = teamMatchBoutRaw['bout_id'] as int;
    await BoutController().deleteSingle(boutId);
    return super.deleteSingle(id);
  }

  Future<List<TeamMatchBout>> getByTeamMatch(int id, {required bool obfuscate}) async {
    return await getMany(
      conditions: ['team_match_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['pos'],
      obfuscate: obfuscate,
    );
  }

  Future<List<TeamMatchBout>> getByBout(int id, {required bool obfuscate}) async {
    return await getMany(conditions: ['bout_id = @id'], substitutionValues: {'id': id}, obfuscate: obfuscate);
  }

  Future<void> processOnResult(TeamMatchBout teamMatchBout) async {
    // Update team match result, if every bout has a result.
    if (teamMatchBout.bout.result != null && teamMatchBout.teamMatch.id != null) {
      final obfuscate = false;
      final teamMatchBouts = await TeamMatchBoutController().getByTeamMatch(
        teamMatchBout.teamMatch.id!,
        obfuscate: obfuscate,
      );
      if (teamMatchBouts.every((tmb) => tmb.bout.result != null)) {
        var teamMatch = await TeamMatchController().getSingle(teamMatchBout.teamMatch.id!, obfuscate: obfuscate);
        if (teamMatch.resultRole == null ||
            teamMatch.home.classificationPoints == null ||
            teamMatch.guest.classificationPoints == null) {
          final homeClassificationPoints = TeamMatch.getClassificationPoints(teamMatchBouts.map((e) => e.bout.r));
          final guestClassificationPoints = TeamMatch.getClassificationPoints(teamMatchBouts.map((e) => e.bout.b));
          if (homeClassificationPoints > 0 || guestClassificationPoints > 0) {
            final home = teamMatch.home.copyWith(classificationPoints: homeClassificationPoints);
            final guest = teamMatch.guest.copyWith(classificationPoints: guestClassificationPoints);
            final resultRole = MatchResultRole.fromDiff(homeClassificationPoints - guestClassificationPoints);
            final endDate = teamMatch.endDate ?? MockableDateTime.now().toUtc();
            await TeamLineupController().updateSingle(home);
            broadcastUpdateSingle(
              (obfuscate) async =>
                  obfuscate ? (await TeamLineupController().getSingle(teamMatch.home.id!, obfuscate: obfuscate)) : home,
            );
            await TeamLineupController().updateSingle(guest);
            broadcastUpdateSingle(
              (obfuscate) async =>
                  obfuscate
                      ? (await TeamLineupController().getSingle(teamMatch.guest.id!, obfuscate: obfuscate))
                      : guest,
            );
            teamMatch = teamMatch.copyWith(resultRole: resultRole, home: home, guest: guest, endDate: endDate);
            await TeamMatchController().updateSingle(teamMatch);
            broadcastUpdateSingle(
              (obfuscate) async =>
                  obfuscate ? (await TeamMatchController().getSingle(teamMatch.id!, obfuscate: obfuscate)) : teamMatch,
            );
          }
        }
      }
    }
  }
}
