import 'package:common/common.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'fight_controller.dart';

class TournamentController extends EntityController<Tournament> {
  static final TournamentController _singleton = TournamentController._internal();

  factory TournamentController() {
    return _singleton;
  }

  TournamentController._internal() : super(tableName: 'tournament');

  Future<Response> requestFights(Request request, String id) async {
    return EntityController.handleRequestManyOfControllerFromQuery(FightController(),
        isRaw: isRaw(request), sqlQuery: '''
        SELECT f.* 
        FROM fight as f 
        JOIN tournament_fight AS tof ON tof.fight_id = f.id
        WHERE tof.tournament_id = $id;''');
  }

  @override
  Future<Tournament> parseToClass(Map<String, dynamic> e) async {
    // TODO fetch lineups, referees, weightClasses, etc.
    return Tournament(
      id: e[primaryKeyName] as int?,
      name: e['name'],
      lineups: [],
      referees: [],
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
      weightClasses: [],
    );
  }

  @override
  Map<String, dynamic> parseFromClass(Tournament e) {
    return {
      if (e.id != null) primaryKeyName: e.id,
      'name': e.name,
      'location': e.location,
      'date': e.date,
    };
  }
}
