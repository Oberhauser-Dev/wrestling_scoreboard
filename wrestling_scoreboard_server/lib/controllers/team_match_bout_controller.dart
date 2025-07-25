import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class TeamMatchBoutController extends ShelfController<TeamMatchBout>
    with OrganizationalController<TeamMatchBout>, OrderableController<TeamMatchBout> {
  static final TeamMatchBoutController _singleton = TeamMatchBoutController._internal();

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

  TeamMatchBoutController._internal() : super();
}
