import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class TournamentBoutController extends EntityController<TournamentBout> {
  static final TournamentBoutController _singleton = TournamentBoutController._internal();

  factory TournamentBoutController() {
    return _singleton;
  }

  TournamentBoutController._internal() : super(tableName: 'tournament_bout');
}
