import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:shelf/shelf.dart';

class LeagueController extends EntityController<League> {
  static final LeagueController _singleton = LeagueController._internal();

  factory LeagueController() {
    return _singleton;
  }

  LeagueController._internal() : super(tableName: 'league');

  Future<Response> requestTeams(Request request, String id) async {
    return EntityController.handleRequestManyOfController(TeamController(),
        isRaw: isRaw(request), conditions: ['league_id = @id'], substitutionValues: {'id': id});
  }

  static const _weightClassesQuery = '''
        SELECT wc.* 
        FROM weight_class as wc
        JOIN league_weight_class AS lwc ON lwc.weight_class_id = wc.id
        WHERE lwc.league_id = @id
        ORDER BY lwc.pos;''';

  Future<Response> requestWeightClasses(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(WeightClassController(),
        isRaw: isRaw(request), sqlQuery: _weightClassesQuery, substitutionValues: {'id': id});
  }

  Future<List<WeightClass>> getWeightClasses(String id) {
    return WeightClassController().getManyFromQuery(_weightClassesQuery, substitutionValues: {'id': id});
  }

  Future<Response> requestLeagueWeightClasses(Request request, String id) async {
    return EntityController.handleRequestManyOfController(LeagueWeightClassController(),
        isRaw: isRaw(request), conditions: ['league_id = @id'], substitutionValues: {'id': id}, orderBy: 'pos');
  }

  Future<Response> requestLeagueTeamParticipations(Request request, String id) async {
    return EntityController.handleRequestManyOfController(LeagueTeamParticipationController(),
        isRaw: isRaw(request), conditions: ['league_id = @id'], substitutionValues: {'id': id});
  }
}
