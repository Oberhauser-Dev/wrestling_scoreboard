import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../controllers/club_controller.dart';
import '../controllers/fight_action_controller.dart';
import '../controllers/fight_controller.dart';
import '../controllers/league_controller.dart';
import '../controllers/lineup_controller.dart';
import '../controllers/membership_controller.dart';
import '../controllers/participant_state_controller.dart';
import '../controllers/participation_controller.dart';
import '../controllers/person_controller.dart';
import '../controllers/team_controller.dart';
import '../controllers/team_match_controller.dart';
import '../controllers/team_match_fight_controller.dart';
import '../controllers/tournament_controller.dart';
import '../controllers/tournament_fight_controller.dart';
import '../controllers/weight_class_controller.dart';
import '../middleware/content_type.dart';

class ApiRoute {
  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    final clubController = ClubController();
    // A handler can have more that one route.
    router.get('/clubs', clubController.requestMany);
    router.get('/club/<id|[0-9]+>', clubController.requestSingle);
    router.get('/club/<id|[0-9]+>/teams', clubController.requestTeams);
    // router.get('/club/<no|[0-9]{5}>', clubRequest);

    final leagueController = LeagueController();
    router.get('/leagues', leagueController.requestMany);
    router.get('/league/<id|[0-9]+>', leagueController.requestSingle);
    router.get('/league/<id|[0-9]+>/teams', leagueController.requestTeams);

    final lineupController = LineupController();
    router.get('/lineups', lineupController.requestMany);
    router.get('/lineup/<id|[0-9]+>', lineupController.requestSingle);
    router.get('/lineup/<id|[0-9]+>/participations', lineupController.requestParticipations);

    final matchController = TeamMatchController();
    router.get('/team_matchs', matchController.requestMany);
    router.get('/team_matches', matchController.requestMany);
    router.get('/team_match/<id|[0-9]+>', matchController.requestSingle);
    router.post('/team_match/<id|[0-9]+>/fights/generate', matchController.generateFights);
    router.get('/team_match/<id|[0-9]+>/fights', matchController.requestFights);

    final tournamentController = TournamentController();
    router.get('/tournaments', tournamentController.requestMany);
    router.get('/tournament/<id|[0-9]+>', tournamentController.requestSingle);
    router.get('/tournament/<id|[0-9]+>/fights', tournamentController.requestFights);

    final membershipController = MembershipController();
    router.get('/memberships', membershipController.requestMany);
    router.get('/membership/<id|[0-9]+>', membershipController.requestSingle);

    final participationController = ParticipationController();
    router.get('/participations', participationController.requestMany);
    router.get('/participation/<id|[0-9]+>', participationController.requestSingle);

    final personController = PersonController();
    router.get('/persons', personController.requestMany);
    router.get('/person/<id|[0-9]+>', personController.requestSingle);

    final teamController = TeamController();
    router.get('/teams', teamController.requestMany);
    router.get('/team/<id|[0-9]+>', teamController.requestSingle);
    router.get('/team/<id|[0-9]+>/team_matchs', teamController.requestTeamMatches);

    final weightClassController = WeightClassController();
    router.get('/weight_classs', weightClassController.requestMany);
    router.get('/weight_classes', weightClassController.requestMany);
    router.get('/weight_class/<id|[0-9]+>', weightClassController.requestSingle);

    final fightController = FightController();
    router.get('/fights', fightController.requestMany);
    router.get('/fight/<id|[0-9]+>', fightController.requestSingle);

    // TeamMatchFightController currently not used!
    final teamMatchFightController = TeamMatchFightController();
    router.get('/team_match_fights', teamMatchFightController.requestMany);
    router.get('/team_match_fight/<id|[0-9]+>', teamMatchFightController.requestSingle);

    // TournamentFightController currently not used!
    final tournamentFightController = TournamentFightController();
    router.get('/tournament_fights', tournamentFightController.requestMany);
    router.get('/tournament_fight/<id|[0-9]+>', tournamentFightController.requestSingle);

    final participantStateController = ParticipantStateController();
    router.get('/participant_states', participantStateController.requestMany);
    router.get('/participant_state/<id|[0-9]+>', participantStateController.requestSingle);

    final fightActionController = FightActionController();
    router.get('/fight_actions', fightActionController.requestMany);
    router.get('/fight_action/<id|[0-9]+>', fightActionController.requestSingle);

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
