import 'package:wrestling_scoreboard_common/common.dart';

import 'organizational_controller.dart';

class DivisionWeightClassController extends OrganizationalController<DivisionWeightClass> {
  static final DivisionWeightClassController _singleton = DivisionWeightClassController._internal();

  factory DivisionWeightClassController() {
    return _singleton;
  }

  DivisionWeightClassController._internal() : super(tableName: 'division_weight_class');
}
