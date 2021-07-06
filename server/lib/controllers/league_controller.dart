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
    final many = await TeamController().getManyRest(conditions: ['league_id = $id']);
    return Response.ok(betterJsonEncode(many.toList()));
  }
}
