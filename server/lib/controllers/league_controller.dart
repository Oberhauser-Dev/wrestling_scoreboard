import 'package:common/common.dart';
import 'package:server/controllers/entity_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:shelf/shelf.dart';

class LeagueController extends EntityController<League> {
  static final LeagueController _singleton = LeagueController._internal();

  factory LeagueController() {
    return _singleton;
  }

  LeagueController._internal() : super(tableName: 'league');

  Future<Response> requestTeams(Request request, String id) async {
    return EntityController.handleRequestManyOfController(TeamController(),
        isRaw: isRaw(request), conditions: ['league_id = $id']);
  }

  @override
  Future<League> parseToClass(Map<String, dynamic> e) async {
    return League(id: e['id'] as int?, name: e['name'] as String, startDate: e['startDate'] as DateTime);
  }
}
