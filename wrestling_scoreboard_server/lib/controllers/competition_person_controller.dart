import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class CompetitionPersonController extends ShelfController<CompetitionPerson> {
  static final CompetitionPersonController _singleton = CompetitionPersonController._internal();

  factory CompetitionPersonController() {
    return _singleton;
  }

  CompetitionPersonController._internal() : super();
}
