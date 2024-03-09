import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';

class OrganizationController extends EntityController<Organization> {
  static final OrganizationController _singleton = OrganizationController._internal();

  factory OrganizationController() {
    return _singleton;
  }

  OrganizationController._internal() : super(tableName: 'organization');

  Future<Response> requestDivisions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(DivisionController(),
        isRaw: isRaw(request), conditions: ['organization_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestClubs(Request request, String id) async {
    return EntityController.handleRequestManyOfController(ClubController(),
        isRaw: isRaw(request), conditions: ['organization_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestCompetitions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(CompetitionController(),
        isRaw: isRaw(request), conditions: ['organization_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestChildOrganizations(Request request, String id) async {
    return EntityController.handleRequestManyOfController(OrganizationController(),
        isRaw: isRaw(request), conditions: ['parent_id = @id'], substitutionValues: {'id': id});
  }
}
