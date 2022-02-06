import 'package:common/common.dart';

import 'entity_controller.dart';

class LeagueWeightClassController extends EntityController<LeagueWeightClass> {
  static final LeagueWeightClassController _singleton = LeagueWeightClassController._internal();

  factory LeagueWeightClassController() {
    return _singleton;
  }

  LeagueWeightClassController._internal() : super(tableName: 'league_weight_class');
}
