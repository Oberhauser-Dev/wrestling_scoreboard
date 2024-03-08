import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'entity_controller.dart';

class ServiceController {
  Future<Response> import(Request request, String provider) async {
    final apiProvider = WrestlingApiProvider.values.byName(provider);
    try {
      final leagues = await apiProvider.api.importLeagues(season: 2023);
      // Iterable<EntityController> entityControllers =
      //     dataTypes.map((t) => EntityController.getControllerFromDataType(t));
      // await Future.forEach(entityControllers, (e) => e.deleteMany());
      return Response.ok('{"status": "success"}');
    } catch (err) {
      return Response.internalServerError(body: '{"err": "$err"}');
    }
  }
}
