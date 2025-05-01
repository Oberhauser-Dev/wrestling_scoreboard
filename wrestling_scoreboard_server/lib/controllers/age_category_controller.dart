import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class AgeCategoryController extends ShelfController<AgeCategory> {
  static final AgeCategoryController _singleton = AgeCategoryController._internal();

  factory AgeCategoryController() {
    return _singleton;
  }

  AgeCategoryController._internal() : super();
}
