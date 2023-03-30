import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class TournamentFightController extends EntityController<TournamentFight> {
  static final TournamentFightController _singleton = TournamentFightController._internal();

  factory TournamentFightController() {
    return _singleton;
  }

  TournamentFightController._internal() : super(tableName: 'tournament_fight');
}
