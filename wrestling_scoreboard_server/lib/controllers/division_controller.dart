import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class DivisionController extends EntityController<Division> {
  static final DivisionController _singleton = DivisionController._internal();

  factory DivisionController() {
    return _singleton;
  }

  DivisionController._internal() : super(tableName: 'division');

  Future<Response> requestLeagues(Request request, String id) async {
    return EntityController.handleRequestManyOfController(LeagueController(),
        isRaw: request.isRaw, conditions: ['division_id = @id'], substitutionValues: {'id': id});
  }

  static String _weightClassesQuery(bool filterBySeasonPartition) => '''
        SELECT wc.* 
        FROM weight_class as wc
        JOIN division_weight_class AS dwc ON dwc.weight_class_id = wc.id
        WHERE dwc.league_id = @id ${filterBySeasonPartition ? 'AND dwc.season_partition = @season_partition' : ''}
        ORDER BY dwc.pos;''';

  Future<Response> requestWeightClasses(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(WeightClassController(),
        isRaw: request.isRaw, sqlQuery: _weightClassesQuery(false), substitutionValues: {'id': id});
  }

  Future<List<WeightClass>> getWeightClasses(String id, {int? seasonPartition}) {
    return WeightClassController().getManyFromQuery(_weightClassesQuery(seasonPartition != null), substitutionValues: {
      'id': id,
      if (seasonPartition != null) 'season_partition': seasonPartition,
    });
  }

  Future<Response> requestDivisionWeightClasses(Request request, String id) async {
    return EntityController.handleRequestManyOfController(DivisionWeightClassController(),
        isRaw: request.isRaw,
        conditions: ['division_id = @id'],
        substitutionValues: {'id': id},
        orderBy: ['season_partition', 'pos']);
  }

  Future<Response> requestChildDivisions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(DivisionController(),
        isRaw: request.isRaw, conditions: ['parent_id = @id'], substitutionValues: {'id': id});
  }

  @override
  Set<String> getSearchableAttributes() => {'name'};
}
