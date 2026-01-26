import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
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

  @override
  Future<Response> handlePostRequestSingle(Map<String, Object?> json) async {
    final updatedTeamMatchBout = parseSingleJson<TeamMatchBout>(json);
    final obfuscate = false;

    // Update team match result, if every bout has a result.
    if (updatedTeamMatchBout.bout.result != null && updatedTeamMatchBout.teamMatch.id != null) {
      final teamMatchBouts = await TeamMatchBoutController().getByTeamMatch(
        updatedTeamMatchBout.teamMatch.id!,
        obfuscate: obfuscate,
      );
      if (teamMatchBouts.every((tmb) => tmb.bout.result != null)) {
        final teamMatch = await TeamMatchController().getSingle(
          updatedTeamMatchBout.teamMatch.id!,
          obfuscate: obfuscate,
        );
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
            await TeamLineupController().updateSingle(guest);
            await TeamMatchController().updateSingle(
              teamMatch.copyWith(resultRole: resultRole, home: home, guest: guest, endDate: endDate),
            );
          }
        }
      }
    }
    return super.handlePostRequestSingle(json);
  }
}
