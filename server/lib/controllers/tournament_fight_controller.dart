import 'package:common/common.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';
import 'tournament_controller.dart';

class TournamentFightController extends EntityController<TournamentFight> {
  static final TournamentFightController _singleton = TournamentFightController._internal();

  factory TournamentFightController() {
    return _singleton;
  }

  TournamentFightController._internal() : super(tableName: 'tournament_fight');

  @override
  Future<TournamentFight> parseToClass(Map<String, dynamic> e) async {
    final tournament = await TournamentController().getSingle(e['tournament_id'] as int);
    final fight = await FightController().getSingle(e['fight_id'] as int);

    return TournamentFight(
      id: e[primaryKeyName] as int?,
      tournament: tournament!,
      fight: fight!,
    );
  }

  @override
  PostgresMap parseFromClass(TournamentFight e) {
    return PostgresMap({
      if (e.id != null) primaryKeyName: e.id,
      'tournament_id': e.tournament.id,
      'fight_id': e.fight.id,
    });
  }
}
