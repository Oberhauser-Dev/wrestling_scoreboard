import 'package:common/common.dart';

import 'entity_controller.dart';

class TournamentController extends EntityController<Tournament> {
  static final TournamentController _singleton = TournamentController._internal();

  factory TournamentController() {
    return _singleton;
  }

  TournamentController._internal() : super(tableName: 'tournament');

  @override
  Future<Tournament> parseToClass(Map<String, dynamic> e) async {
    // TODO fetch lineups, referees, weightClasses, etc.
    return Tournament(
      id: e['id'] as int?,
      name: e['name'],
      lineups: [],
      referees: [],
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
      weightClasses: [],
    );
  }
}
