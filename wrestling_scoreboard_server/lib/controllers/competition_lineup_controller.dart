import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionLineupController extends ShelfController<CompetitionLineup> {
  static final CompetitionLineupController _singleton = CompetitionLineupController._internal();

  factory CompetitionLineupController() {
    return _singleton;
  }

  CompetitionLineupController._internal() : super();
}
