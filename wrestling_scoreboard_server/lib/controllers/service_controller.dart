import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';

class ServiceController {
  GetSingleOfProvider getSingle = <T extends DataObject>(String providerId) async {
    switch (T) {
      case const (Club):
        throw UnimplementedError();
      default:
        throw UnimplementedError();
    }
  };

  Future<Response> import(Request request, String organizationId) async {
    try {
      final organization = await OrganizationController().getSingle(int.parse(organizationId));
      final apiProvider = organization.getApi(getSingle);
      if (apiProvider == null) throw Exception('No API provider selected');

      final divisions = await apiProvider.importDivisions();
      await DivisionController().createMany(divisions.toList());

      final clubs = await apiProvider.importClubs();
      await ClubController().createMany(clubs.toList());
      
      final clubs = await apiProvider.importTeams(club: club);
      await ClubController().createMany(clubs.toList());

      // Iterable<EntityController> entityControllers =
      //     dataTypes.map((t) => EntityController.getControllerFromDataType(t));
      // await Future.forEach(entityControllers, (e) => e.deleteMany());
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }
}
