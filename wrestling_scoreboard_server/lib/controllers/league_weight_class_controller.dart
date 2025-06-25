import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class LeagueWeightClassController extends ShelfController<LeagueWeightClass>
    with OrganizationalController<LeagueWeightClass>, OrderableController<LeagueWeightClass> {
  static final LeagueWeightClassController _singleton = LeagueWeightClassController._internal();

  factory LeagueWeightClassController() {
    return _singleton;
  }

  LeagueWeightClassController._internal() : super();
}
