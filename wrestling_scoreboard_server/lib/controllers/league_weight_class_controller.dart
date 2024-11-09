import 'package:wrestling_scoreboard_common/common.dart';

import 'organizational_controller.dart';

class LeagueWeightClassController extends OrganizationalController<LeagueWeightClass> {
  static final LeagueWeightClassController _singleton = LeagueWeightClassController._internal();

  factory LeagueWeightClassController() {
    return _singleton;
  }

  LeagueWeightClassController._internal() : super(tableName: 'league_weight_class');
}
