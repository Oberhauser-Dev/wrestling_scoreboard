import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class BoutResultRuleController extends ShelfController<BoutResultRule> {
  static final BoutResultRuleController _singleton = BoutResultRuleController._internal();

  factory BoutResultRuleController() {
    return _singleton;
  }

  BoutResultRuleController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'winner_technical_points': psql.Type.smallInteger,
      'loser_technical_points': psql.Type.smallInteger,
      'technical_points_difference': psql.Type.smallInteger,
      'winner_classification_points': psql.Type.smallInteger,
      'loser_classification_points': psql.Type.smallInteger,
    };
  }
}
