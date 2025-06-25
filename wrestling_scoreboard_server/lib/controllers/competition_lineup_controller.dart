import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class CompetitionLineupController extends ShelfController<CompetitionLineup> {
  static final CompetitionLineupController _singleton = CompetitionLineupController._internal();

  factory CompetitionLineupController() {
    return _singleton;
  }

  CompetitionLineupController._internal() : super();
}
