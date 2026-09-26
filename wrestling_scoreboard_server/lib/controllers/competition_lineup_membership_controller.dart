import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class CompetitionLineupMembershipController extends ShelfController<CompetitionLineupMembership> {
  static final CompetitionLineupMembershipController _singleton = CompetitionLineupMembershipController._internal();

  factory CompetitionLineupMembershipController() {
    return _singleton;
  }

  CompetitionLineupMembershipController._internal() : super();

  Future<List<CompetitionLineupMembership>> getByMembership(User? user, int id) async {
    return await getMany(
      conditions: ['membership_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }
}
