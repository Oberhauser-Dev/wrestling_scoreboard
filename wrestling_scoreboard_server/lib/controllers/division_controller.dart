import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

class DivisionController extends ShelfController<Division> with OrganizationalController<Division> {
  static final DivisionController _singleton = DivisionController._internal();

  factory DivisionController() {
    return _singleton;
  }

  DivisionController._internal() : super();

  static String _weightClassesQuery(bool filterBySeasonPartition) => '''
        SELECT wc.* 
        FROM weight_class as wc
        JOIN division_weight_class AS dwc ON dwc.weight_class_id = wc.id
        WHERE dwc.division_id = @id ${filterBySeasonPartition ? 'AND dwc.season_partition = @season_partition' : ''}
        ORDER BY dwc.pos;''';

  Future<Response> requestWeightClasses(Request request, User? user, String id) async {
    return WeightClassController().handleGetRequestManyFromQuery(
      isRaw: request.isRaw,
      sqlQuery: _weightClassesQuery(false),
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<List<DivisionWeightClass>> getDivisionWeightClasses(
    String id, {
    int? seasonPartition,
    required bool obfuscate,
  }) {
    return DivisionWeightClassController().getMany(
      conditions: ['division_id = @id', if (seasonPartition != null) 'season_partition = @season_partition'],
      substitutionValues: {'id': id, if (seasonPartition != null) 'season_partition': seasonPartition},
      orderBy: ['season_partition', 'pos'],
      obfuscate: obfuscate,
    );
  }
}
