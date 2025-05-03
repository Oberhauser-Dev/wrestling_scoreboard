import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionWeightCategoryController extends ShelfController<CompetitionWeightCategory> {
  static final CompetitionWeightCategoryController _singleton = CompetitionWeightCategoryController._internal();

  factory CompetitionWeightCategoryController() {
    return _singleton;
  }

  CompetitionWeightCategoryController._internal() : super();

  @override
  Map<String, psql.Type?> getPostgresDataTypes() {
    return {
      'paired_round': psql.Type.smallInteger,
    };
  }
}
