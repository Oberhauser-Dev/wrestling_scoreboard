import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';

import '../controllers/bout_config_controller.dart';
import '../controllers/club_controller.dart';
import '../controllers/bout_action_controller.dart';
import '../controllers/bout_controller.dart';
import '../controllers/league_controller.dart';
import '../controllers/lineup_controller.dart';
import '../controllers/membership_controller.dart';
import '../controllers/participant_state_controller.dart';
import '../controllers/participation_controller.dart';
import '../controllers/person_controller.dart';
import '../controllers/team_controller.dart';
import '../controllers/team_match_controller.dart';
import '../controllers/team_match_bout_controller.dart';
import '../controllers/tournament_controller.dart';
import '../controllers/tournament_bout_controller.dart';
import '../controllers/weight_class_controller.dart';
import '../middleware/content_type.dart';

class ApiRoute {
  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    final boutConfigController = BoutConfigController();
    router.post('/bout_config', boutConfigController.postSingle);
    router.get('/bout_configs', boutConfigController.requestMany);
    router.get('/bout_config/<id|[0-9]+>', boutConfigController.requestSingle);

    final clubController = ClubController();
    // A handler can have more that one route.
    router.post('/club', clubController.postSingle);
    router.get('/clubs', clubController.requestMany);
    router.get('/club/<id|[0-9]+>', clubController.requestSingle);
    router.get('/club/<id|[0-9]+>/teams', clubController.requestTeams);
    router.get('/club/<id|[0-9]+>/memberships', clubController.requestMemberships);
    // router.get('/club/<no|[0-9]{5}>', clubRequest);

    final boutController = BoutController();
    router.post('/bout', boutController.postSingle);
    router.get('/bouts', boutController.requestMany);
    router.get('/bout/<id|[0-9]+>', boutController.requestSingle);
    router.get('/bout/<id|[0-9]+>/bout_actions', boutController.requestBoutActions);

    final boutActionController = BoutActionController();
    router.post('/bout_action', boutActionController.postSingle);
    router.get('/bout_actions', boutActionController.requestMany);
    router.get('/bout_action/<id|[0-9]+>', boutActionController.requestSingle);

    final leagueController = LeagueController();
    router.post('/league', leagueController.postSingle);
    router.get('/leagues', leagueController.requestMany);
    router.get('/league/<id|[0-9]+>', leagueController.requestSingle);
    router.get('/league/<id|[0-9]+>/teams', leagueController.requestTeams);
    router.get('/league/<id|[0-9]+>/weight_classs', leagueController.requestWeightClasses);
    router.get('/league/<id|[0-9]+>/league_weight_classs', leagueController.requestLeagueWeightClasses);
    router.get('/league/<id|[0-9]+>/league_team_participations', leagueController.requestLeagueTeamParticipations);
    router.get('/league/<id|[0-9]+>/team_matchs', leagueController.requestTeamMatchs);

    final leagueWeightClassController = LeagueWeightClassController();
    router.post('/league_weight_class', leagueWeightClassController.postSingle);
    router.get('/league_weight_classs', leagueWeightClassController.requestMany);
    router.get('/league_weight_class/<id|[0-9]+>', leagueWeightClassController.requestSingle);

    final leagueTeamParticipationController = LeagueTeamParticipationController();
    router.post('/league_team_participation', leagueTeamParticipationController.postSingle);
    router.get('/league_team_participations', leagueTeamParticipationController.requestMany);
    router.get('/league_team_participation/<id|[0-9]+>', leagueTeamParticipationController.requestSingle);

    final lineupController = LineupController();
    router.post('/lineup', lineupController.postSingle);
    router.get('/lineups', lineupController.requestMany);
    router.get('/lineup/<id|[0-9]+>', lineupController.requestSingle);
    router.get('/lineup/<id|[0-9]+>/participations', lineupController.requestParticipations);

    final membershipController = MembershipController();
    router.post('/membership', membershipController.postSingle);
    router.get('/memberships', membershipController.requestMany);
    router.get('/membership/<id|[0-9]+>', membershipController.requestSingle);

    final participantStateController = ParticipantStateController();
    router.post('/participant_state', participantStateController.postSingle);
    router.get('/participant_states', participantStateController.requestMany);
    router.get('/participant_state/<id|[0-9]+>', participantStateController.requestSingle);

    final participationController = ParticipationController();
    router.post('/participation', participationController.postSingle);
    router.get('/participations', participationController.requestMany);
    router.get('/participation/<id|[0-9]+>', participationController.requestSingle);

    final personController = PersonController();
    router.post('/person', personController.postSingle);
    router.get('/persons', personController.requestMany);
    router.get('/person/<id|[0-9]+>', personController.requestSingle);

    final teamController = TeamController();
    router.post('/team', teamController.postSingle);
    router.get('/teams', teamController.requestMany);
    router.get('/team/<id|[0-9]+>', teamController.requestSingle);
    router.get('/team/<id|[0-9]+>/team_matchs', teamController.requestTeamMatches);

    final matchController = TeamMatchController();
    router.post('/team_match', matchController.postSingle);
    router.get('/team_matchs', matchController.requestMany);
    router.get('/team_matches', matchController.requestMany);
    router.get('/team_match/<id|[0-9]+>', matchController.requestSingle);
    router.post('/team_match/<id|[0-9]+>/bouts/generate', matchController.generateBouts);
    router.get('/team_match/<id|[0-9]+>/bouts', matchController.requestBouts);

    final teamMatchBoutController = TeamMatchBoutController();
    router.post('/team_match_bout', teamMatchBoutController.postSingle);
    router.get('/team_match_bouts', teamMatchBoutController.requestMany);
    router.get('/team_match_bout/<id|[0-9]+>', teamMatchBoutController.requestSingle);

    final tournamentController = TournamentController();
    router.post('/tournament', tournamentController.postSingle);
    router.get('/tournaments', tournamentController.requestMany);
    router.get('/tournament/<id|[0-9]+>', tournamentController.requestSingle);
    router.get('/tournament/<id|[0-9]+>/bouts', tournamentController.requestBouts);

    final tournamentBoutController = TournamentBoutController();
    router.post('/tournament_bout', tournamentBoutController.postSingle);
    router.get('/tournament_bouts', tournamentBoutController.requestMany);
    router.get('/tournament_bout/<id|[0-9]+>', tournamentBoutController.requestSingle);

    final weightClassController = WeightClassController();
    router.post('/weight_class', weightClassController.postSingle);
    router.get('/weight_classs', weightClassController.requestMany);
    router.get('/weight_classes', weightClassController.requestMany);
    router.get('/weight_class/<id|[0-9]+>', weightClassController.requestSingle);

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
