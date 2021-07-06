import 'package:common/common.dart';
import 'package:server/controllers/club_controller.dart';

import 'entity_controller.dart';
import 'league_controller.dart';

class TeamController extends EntityController<Team> {
  static final TeamController _singleton = TeamController._internal();

  factory TeamController() {
    return _singleton;
  }

  TeamController._internal() : super(tableName: 'team');

  @override
  Future<Team> parseToClass(Map<String, dynamic> e) async {
    final club = await ClubController().getSingle(e['club_id'] as int);
    final leagueId = e['league_id'] as int?;
    final league = leagueId == null ? null : await LeagueController().getSingle(leagueId);
    return Team(
        id: e['id'] as int?,
        name: e['name'] as String,
        club: club!,
        description: e['description'] as String?,
        league: league);
  }
}
