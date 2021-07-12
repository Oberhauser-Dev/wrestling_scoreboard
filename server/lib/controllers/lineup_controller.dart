import 'package:common/common.dart';
import 'package:server/controllers/person_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:shelf/shelf.dart';

import 'entity_controller.dart';
import 'participation_controller.dart';

class LineupController extends EntityController<Lineup> {
  static final LineupController _singleton = LineupController._internal();

  factory LineupController() {
    return _singleton;
  }

  LineupController._internal() : super(tableName: 'lineup');

  Future<Response> requestTeams(Request request, String id) async {
    return EntityController.handleRequestManyOfController(ParticipationController(),
        isRaw: isRaw(request), conditions: ['club_id = $id']);
  }

  @override
  Future<Lineup> parseToClass(Map<String, dynamic> e) async {
    final id = e['id'] as int?;
    final team = await TeamController().getSingle(e['team_id'] as int);
    final leaderId = e['leader_id'] as int?;
    final leader = leaderId == null ? null : await PersonController().getSingle(leaderId);
    final coachId = e['coach_id'] as int?;
    final coach = coachId == null ? null : await PersonController().getSingle(coachId);
    return Lineup(id: id, team: team!, leader: leader, coach: coach, tier: e['tier'] as int? ?? 1);
  }
}
