import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../controllers/bout_action_controller.dart';
import '../controllers/bout_config_controller.dart';
import '../controllers/bout_controller.dart';
import '../controllers/club_controller.dart';
import '../controllers/competition_bout_controller.dart';
import '../controllers/competition_controller.dart';
import '../controllers/database_controller.dart';
import '../controllers/organization_controller.dart';
import '../controllers/division_controller.dart';
import '../controllers/league_controller.dart';
import '../controllers/league_team_participation_controller.dart';
import '../controllers/league_weight_class_controller.dart';
import '../controllers/lineup_controller.dart';
import '../controllers/membership_controller.dart';
import '../controllers/participant_state_controller.dart';
import '../controllers/participation_controller.dart';
import '../controllers/person_controller.dart';
import '../controllers/service_controller.dart';
import '../controllers/team_controller.dart';
import '../controllers/team_match_bout_controller.dart';
import '../controllers/team_match_controller.dart';
import '../controllers/weight_class_controller.dart';
import '../middleware/content_type.dart';

class ApiRoute {
  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    final databaseController = DatabaseController();
    router.get('/database/export', databaseController.export);
    router.post('/database/reset', databaseController.reset);
    router.post('/database/restore', databaseController.restore);
    router.post('/database/restore_default', databaseController.restoreDefault);

    final serviceController = ServiceController();
    router.post('/service/api/<provider>/import', serviceController.import);

    final boutConfigController = BoutConfigController();
    router.post('/bout_config', boutConfigController.postSingle);
    router.get('/bout_configs', boutConfigController.requestMany);
    router.get('/bout_config/<id|[0-9]+>', boutConfigController.requestSingle);

    final clubController = ClubController();
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

    final organizationController = OrganizationController();
    router.post('/organization', organizationController.postSingle);
    router.get('/organizations', organizationController.requestMany);
    router.get('/organization/<id|[0-9]+>', organizationController.requestSingle);
    router.get('/organization/<id|[0-9]+>/organizations', organizationController.requestChildOrganizations);
    router.get('/organization/<id|[0-9]+>/divisions', organizationController.requestDivisions);
    router.get('/organization/<id|[0-9]+>/clubs', organizationController.requestClubs);
    router.get('/organization/<id|[0-9]+>/competitions', organizationController.requestCompetitions);

    final divisionController = DivisionController();
    router.post('/division', divisionController.postSingle);
    router.get('/divisions', divisionController.requestMany);
    router.get('/division/<id|[0-9]+>', divisionController.requestSingle);
    router.get('/division/<id|[0-9]+>/leagues', divisionController.requestLeagues);
    router.get('/division/<id|[0-9]+>/divisions', divisionController.requestChildDivisions);
    router.get('/division/<id|[0-9]+>/weight_classs', divisionController.requestWeightClasses);
    router.get('/division/<id|[0-9]+>/division_weight_classs', divisionController.requestDivisionWeightClasses);

    final leagueController = LeagueController();
    router.post('/league', leagueController.postSingle);
    router.get('/leagues', leagueController.requestMany);
    router.get('/league/<id|[0-9]+>', leagueController.requestSingle);
    router.get('/league/<id|[0-9]+>/teams', leagueController.requestTeams);
    router.get('/league/<id|[0-9]+>/league_team_participations', leagueController.requestLeagueTeamParticipations);
    router.get('/league/<id|[0-9]+>/team_matchs', leagueController.requestTeamMatchs);

    final divisionWeightClassController = DivisionWeightClassController();
    router.post('/division_weight_class', divisionWeightClassController.postSingle);
    router.get('/division_weight_classs', divisionWeightClassController.requestMany);
    router.get('/division_weight_class/<id|[0-9]+>', divisionWeightClassController.requestSingle);

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
    router.get('/team_match/<id|[0-9]+>/team_match_bouts', matchController.requestTeamMatchBouts);

    final teamMatchBoutController = TeamMatchBoutController();
    router.post('/team_match_bout', teamMatchBoutController.postSingle);
    router.get('/team_match_bouts', teamMatchBoutController.requestMany);
    router.get('/team_match_bout/<id|[0-9]+>', teamMatchBoutController.requestSingle);

    final competitionController = CompetitionController();
    router.post('/competition', competitionController.postSingle);
    router.get('/competitions', competitionController.requestMany);
    router.get('/competition/<id|[0-9]+>', competitionController.requestSingle);
    router.get('/competition/<id|[0-9]+>/bouts', competitionController.requestBouts);

    final competitionBoutController = CompetitionBoutController();
    router.post('/competition_bout', competitionBoutController.postSingle);
    router.get('/competition_bouts', competitionBoutController.requestMany);
    router.get('/competition_bout/<id|[0-9]+>', competitionBoutController.requestSingle);

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
