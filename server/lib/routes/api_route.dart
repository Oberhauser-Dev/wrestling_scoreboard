import 'package:server/controllers/club_controller.dart';
import 'package:server/controllers/league_controller.dart';
import 'package:server/controllers/team_controller.dart';
import 'package:server/middleware/content_type.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ApiRoute {
  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    final clubController = ClubController();
    // A handler can have more that one route.
    router.get('/clubs', clubController.requestMany);
    router.get('/club/<id|[0-9]+>', clubController.requestSingle);
    // router.get('/club/<no|[0-9]{5}>', clubRequest);

    final leagueController = LeagueController();
    router.get('/leagues', leagueController.requestMany);
    router.get('/league/<id|[0-9]+>', leagueController.requestSingle);

    final teamController = TeamController();
    router.get('/teams', teamController.requestMany);
    router.get('/team/<id|[0-9]+>', teamController.requestSingle);

    // This nested catch-all, will only catch /api/.* when mounted above.
    // Notice that ordering if annotated handlers and mounts is significant.
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }

  Handler get pipeline {
    final pipeline = Pipeline().addMiddleware(contentTypeJsonConfig).addHandler(router);
    return pipeline;
  }
}
