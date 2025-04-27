import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';

class TeamMatchBoutController extends OrganizationalController<TeamMatchBout> {
  static final TeamMatchBoutController _singleton = TeamMatchBoutController._internal();

  factory TeamMatchBoutController() {
    return _singleton;
  }

  Future<List<TeamMatchBout>> getByTeamMatch(User? user, int id) async {
    return await getMany(
      conditions: ['team_match_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['pos'],
      obfuscate: user?.obfuscate ?? true,
    );
  }

  TeamMatchBoutController._internal() : super();
}
