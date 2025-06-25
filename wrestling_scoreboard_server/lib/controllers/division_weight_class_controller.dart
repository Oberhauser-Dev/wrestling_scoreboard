import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';

class DivisionWeightClassController extends ShelfController<DivisionWeightClass>
    with OrganizationalController<DivisionWeightClass>, OrderableController<DivisionWeightClass> {
  static final DivisionWeightClassController _singleton = DivisionWeightClassController._internal();

  factory DivisionWeightClassController() {
    return _singleton;
  }

  DivisionWeightClassController._internal() : super();
}
