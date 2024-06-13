import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class LeagueController extends EntityController<League> {
  static final LeagueController _singleton = LeagueController._internal();

  factory LeagueController() {
    return _singleton;
  }

  LeagueController._internal() : super(tableName: 'league');

  Future<Response> requestTeams(Request request, String id) async {
    return EntityController.handleRequestManyOfController(TeamController(),
        isRaw: request.isRaw, conditions: ['league_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestLeagueTeamParticipations(Request request, String id) async {
    return EntityController.handleRequestManyOfController(LeagueTeamParticipationController(),
        isRaw: request.isRaw, conditions: ['league_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestTeamMatchs(Request request, String id) async {
    return EntityController.handleRequestManyOfController(TeamMatchController(),
        isRaw: request.isRaw, conditions: ['league_id = @id'], substitutionValues: {'id': id}, orderBy: ['date']);
  }

  @override
  Set<String> getSearchableAttributes() => {'name'};
}
