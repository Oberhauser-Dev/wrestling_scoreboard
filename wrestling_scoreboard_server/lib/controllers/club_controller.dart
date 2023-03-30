import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:shelf/shelf.dart';

class ClubController extends EntityController<Club> {
  static final ClubController _singleton = ClubController._internal();

  factory ClubController() {
    return _singleton;
  }

  ClubController._internal() : super(tableName: 'club');

  Future<Response> requestTeams(Request request, String id) async {
    return EntityController.handleRequestManyOfController(TeamController(),
        isRaw: isRaw(request), conditions: ['club_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestMemberships(Request request, String id) async {
    return EntityController.handleRequestManyOfController(MembershipController(),
        isRaw: isRaw(request), conditions: ['club_id = @id'], substitutionValues: {'id': id});
  }
}
