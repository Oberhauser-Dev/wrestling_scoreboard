import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';

class TeamClubAffiliationController extends ShelfController<TeamClubAffiliation> {
  static final TeamClubAffiliationController _singleton = TeamClubAffiliationController._internal();

  factory TeamClubAffiliationController() {
    return _singleton;
  }

  Future<TeamClubAffiliation?> getByTeamAndClubId({
    required int teamId,
    required int clubId,
    required obfuscate,
  }) async {
    final many = await getMany(
        conditions: ['team_id = @teamId', 'club_id = @clubId'],
        substitutionValues: {'teamId': teamId, 'clubId': clubId},
        obfuscate: obfuscate);
    return many.singleOrNull;
  }

  TeamClubAffiliationController._internal() : super(tableName: 'team_club_affiliation');
}
