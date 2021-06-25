import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ApiRoute {
  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    // A handler can have more that one route.
    router.get('/clubs', clubsRequest);
    router.get('/club/<id|[0-9]{5}>', clubRequest);

    router.get('/teams', teamsRequest);
    router.get('/team/<id|[a-zA-Z0-9_]+>', teamRequest);

    // This nested catch-all, will only catch /api/.* when mounted above.
    // Notice that ordering if annotated handlers and mounts is significant.
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }
}
