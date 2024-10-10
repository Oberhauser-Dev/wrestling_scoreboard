import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class DivisionController extends OrganizationalController<Division> {
  static final DivisionController _singleton = DivisionController._internal();

  factory DivisionController() {
    return _singleton;
  }

  DivisionController._internal() : super(tableName: 'division');

  Future<Response> requestLeagues(Request request, User? user, String id) async {
    return LeagueController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['division_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  static String _weightClassesQuery(bool filterBySeasonPartition) => '''
        SELECT wc.* 
        FROM weight_class as wc
        JOIN division_weight_class AS dwc ON dwc.weight_class_id = wc.id
        WHERE dwc.division_id = @id ${filterBySeasonPartition ? 'AND dwc.season_partition = @season_partition' : ''}
        ORDER BY dwc.pos;''';

  Future<Response> requestWeightClasses(Request request, User? user, String id) async {
    return WeightClassController().handleRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: _weightClassesQuery(false),
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<WeightClass>> getWeightClasses(String id, {int? seasonPartition, required bool obfuscate}) {
    return WeightClassController().getManyFromQuery(_weightClassesQuery(seasonPartition != null),
        substitutionValues: {
          'id': id,
          if (seasonPartition != null) 'season_partition': seasonPartition,
        },
        obfuscate: obfuscate);
  }

  Future<Response> requestDivisionWeightClasses(Request request, User? user, String id) async {
    return DivisionWeightClassController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['division_id = @id'],
      substitutionValues: {'id': id},
      orderBy: ['season_partition', 'pos'],
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestChildDivisions(Request request, User? user, String id) async {
    return DivisionController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['parent_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }
}
