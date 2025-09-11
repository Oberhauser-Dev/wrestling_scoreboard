import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class TeamMatchPersonController extends ShelfController<TeamMatchPerson> {
  static final TeamMatchPersonController _singleton = TeamMatchPersonController._internal();

  factory TeamMatchPersonController() {
    return _singleton;
  }

  Future<List<TeamMatchPerson>> getByPerson(User? user, int id) async {
    return await getMany(
      conditions: ['person_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  TeamMatchPersonController._internal() : super();
}
