import 'package:common/common.dart';
import 'package:server/controllers/person_controller.dart';

import 'entity_controller.dart';
import 'lineup_controller.dart';

class TeamMatchController extends EntityController<TeamMatch> {
  static final TeamMatchController _singleton = TeamMatchController._internal();

  factory TeamMatchController() {
    return _singleton;
  }

  TeamMatchController._internal() : super(tableName: 'team_match');

  @override
  Future<TeamMatch> parseToClass(Map<String, dynamic> e) async {
    final home = await LineupController().getSingle(e['home_id'] as int);
    final guest = await LineupController().getSingle(e['guest_id'] as int);
    final referee = await PersonController().getSingle(e['referee_id'] as int);

    return TeamMatch(
      id: e['id'] as int?,
      no: e['no'] as String?,
      home: home!,
      guest: guest!,
      referees: [referee!],
      location: e['location'] as String?,
      date: e['date'] as DateTime?,
    );
  }
}
