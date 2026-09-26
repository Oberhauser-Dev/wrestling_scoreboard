import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class TeamLineupMembershipController extends ShelfController<TeamLineupMembership> {
  static final TeamLineupMembershipController _singleton = TeamLineupMembershipController._internal();

  factory TeamLineupMembershipController() {
    return _singleton;
  }

  TeamLineupMembershipController._internal() : super();

  Future<List<TeamLineupMembership>> getByMembership(User? user, int id) async {
    return await getMany(
      conditions: ['membership_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamLineupMembership>> getByLineup(User? user, int id) async {
    return await getMany(
      conditions: ['lineup_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }
}
