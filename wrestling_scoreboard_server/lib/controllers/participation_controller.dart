import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';

import 'entity_controller.dart';

class ParticipationController extends ShelfController<Participation> {
  static final ParticipationController _singleton = ParticipationController._internal();

  factory ParticipationController() {
    return _singleton;
  }

  ParticipationController._internal() : super(tableName: 'participation');

  Future<List<Participation>> getByMembership(User? user, int id) async {
    return await getMany(
      conditions: ['membership_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {'weight': psql.Type.numeric};
  }
}
