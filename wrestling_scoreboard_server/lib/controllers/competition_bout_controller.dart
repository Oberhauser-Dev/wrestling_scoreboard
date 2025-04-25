import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionBoutController extends ShelfController<CompetitionBout> {
  static final CompetitionBoutController _singleton = CompetitionBoutController._internal();

  factory CompetitionBoutController() {
    return _singleton;
  }

  CompetitionBoutController._internal() : super();
}
