import 'package:common/common.dart';
import 'package:server/controllers/entity_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:server/controllers/weight_class_controller.dart';
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

  @override
  Future<League> parseToClass(Map<String, dynamic> e) async {
    return League(id: e['id'] as int?, name: e['name'] as String, startDate: e['start_date'] as DateTime);
  }
}
