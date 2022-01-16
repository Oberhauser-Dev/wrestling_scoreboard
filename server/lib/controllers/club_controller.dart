import 'package:common/common.dart';
import 'package:server/controllers/entity_controller.dart';
import 'package:server/controllers/membership_controller.dart';
import 'package:server/controllers/team_controller.dart';
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

  @override
  Future<Club> parseToClass(Map<String, dynamic> e) async {
    return Club(id: e[primaryKeyName] as int?, no: e['no'] as String?, name: e['name'] as String);
  }

  @override
  PostgresMap parseFromClass(Club e) {
    return PostgresMap({
      if (e.id != null) primaryKeyName: e.id,
      'no': e.no,
      'name': e.name,
    });
  }
}
