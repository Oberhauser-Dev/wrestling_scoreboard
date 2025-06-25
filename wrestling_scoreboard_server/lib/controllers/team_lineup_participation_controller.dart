import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class TeamLineupParticipationController extends ShelfController<TeamLineupParticipation> {
  static final TeamLineupParticipationController _singleton = TeamLineupParticipationController._internal();

  factory TeamLineupParticipationController() {
    return _singleton;
  }

  TeamLineupParticipationController._internal() : super();

  Future<List<TeamLineupParticipation>> getByMembership(User? user, int id) async {
    return await getMany(
      conditions: ['membership_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<TeamLineupParticipation>> getByLineup(User? user, int id) async {
    return await getMany(
      conditions: ['lineup_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'weight': psql.Type.numeric};
  }
}
