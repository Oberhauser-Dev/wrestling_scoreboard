import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class CompetitionSystemAffiliationController extends ShelfController<CompetitionSystemAffiliation> {
  static final CompetitionSystemAffiliationController _singleton = CompetitionSystemAffiliationController._internal();

  factory CompetitionSystemAffiliationController() {
    return _singleton;
  }

  CompetitionSystemAffiliationController._internal() : super();
}
