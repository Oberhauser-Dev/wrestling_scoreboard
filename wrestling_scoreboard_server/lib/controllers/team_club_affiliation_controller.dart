import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';

class TeamClubAffiliationController extends ShelfController<TeamClubAffiliation> {
  static final TeamClubAffiliationController _singleton = TeamClubAffiliationController._internal();

  factory TeamClubAffiliationController() {
    return _singleton;
  }

  TeamClubAffiliationController._internal() : super(tableName: 'team_club_affiliation');
}
