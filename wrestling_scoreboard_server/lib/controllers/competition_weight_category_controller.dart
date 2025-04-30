import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionWeightCategoryController extends ShelfController<CompetitionWeightCategory> {
  static final CompetitionWeightCategoryController _singleton = CompetitionWeightCategoryController._internal();

  factory CompetitionWeightCategoryController() {
    return _singleton;
  }

  CompetitionWeightCategoryController._internal() : super();
}
