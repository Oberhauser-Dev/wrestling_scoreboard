import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/routes/router.dart';

import '../controllers/auth_controller.dart';
import '../controllers/bout_action_controller.dart';
import '../controllers/bout_config_controller.dart';
import '../controllers/bout_controller.dart';
import '../controllers/bout_result_rule_controller.dart';
import '../controllers/club_controller.dart';
import '../controllers/competition_bout_controller.dart';
import '../controllers/competition_controller.dart';
import '../controllers/database_controller.dart';
import '../controllers/division_controller.dart';
import '../controllers/division_weight_class_controller.dart';
import '../controllers/league_controller.dart';
import '../controllers/league_team_participation_controller.dart';
import '../controllers/lineup_controller.dart';
import '../controllers/membership_controller.dart';
import '../controllers/organization_controller.dart';
import '../controllers/participant_state_controller.dart';
import '../controllers/participation_controller.dart';
import '../controllers/person_controller.dart';
import '../controllers/search_controller.dart';
import '../controllers/team_club_affiliation_controller.dart';
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
    router.restrictedGet('/database/export', databaseController.export, UserPrivilege.admin);
    router.restrictedPost('/database/reset', databaseController.reset, UserPrivilege.admin);
    router.restrictedPost('/database/restore', databaseController.restore, UserPrivilege.admin);
    router.restrictedPost('/database/restore_default', databaseController.restoreDefault, UserPrivilege.admin);
    router.get('/database/migration', databaseController.getMigration);

    final authController = AuthController();
    router.restrictedGet('/auth/user', authController.requestUser);
    router.post('/auth/sign_in', authController.signIn);
    router.post('/auth/sign_up', authController.signUp);
    router.restrictedPost('/auth/user', authController.updateSingle);

    final userController = SecuredUserController();
    router.restrictedPost('/user', userController.postSingleUser, UserPrivilege.admin); // Create
    router.restrictedPost('/secured_user', userController.postSingle, UserPrivilege.admin); // Update
    router.restrictedGet('/secured_users', userController.requestMany, UserPrivilege.admin);
    router.restrictedGetOne('/secured_users/<id|[0-9]+>', userController.requestSingle, UserPrivilege.admin);

    final searchController = SearchController();
    router.restrictedGet('/search', searchController.search);
    router.restrictedPost('/search', searchController.search);

    final boutConfigController = BoutConfigController();
    router.restrictedPost('/bout_config', boutConfigController.postSingle);
    router.restrictedGet('/bout_configs', boutConfigController.requestMany);
    router.restrictedGetOne('/bout_config/<id|[0-9]+>', boutConfigController.requestSingle);
    router.restrictedGetOne('/bout_config/<id|[0-9]+>/bout_result_rules', boutConfigController.requestBoutResultRules);

    final boutResultRuleController = BoutResultRuleController();
    router.restrictedPost('/bout_result_rule', boutResultRuleController.postSingle);
    router.restrictedGet('/bout_result_rules', boutResultRuleController.requestMany);
    router.restrictedGetOne('/bout_result_rule/<id|[0-9]+>', boutResultRuleController.requestSingle);

    final clubController = ClubController();
    router.restrictedPost('/club', clubController.postSingle);
    router.restrictedGet('/clubs', clubController.requestMany);
    router.restrictedGetOne('/club/<id|[0-9]+>', clubController.requestSingle);
    router.restrictedGetOne('/club/<id|[0-9]+>/teams', clubController.requestTeams);
    router.restrictedGetOne('/club/<id|[0-9]+>/memberships', clubController.requestMemberships);
    // router.restrictedGet('/club/<no|[0-9]{5}>', clubRequest);

    final boutController = BoutController();
    router.restrictedPost('/bout', boutController.postSingle);
    router.restrictedGet('/bouts', boutController.requestMany);
    router.restrictedGetOne('/bout/<id|[0-9]+>', boutController.requestSingle);
    router.restrictedGetOne('/bout/<id|[0-9]+>/bout_actions', boutController.requestBoutActions);

    final boutActionController = BoutActionController();
    router.restrictedPost('/bout_action', boutActionController.postSingle);
    router.restrictedGet('/bout_actions', boutActionController.requestMany);
    router.restrictedGetOne('/bout_action/<id|[0-9]+>', boutActionController.requestSingle);

    final organizationController = OrganizationController();
    router.restrictedPostOne('/organization/<id|[0-9]+>/api/import', organizationController.postImport);
    router.restrictedGetOne(
        '/organization/<id|[0-9]+>/api/last_import', organizationController.requestLastImportUtcDateTime);
    router.restrictedPost('/organization', organizationController.postSingle);
    router.restrictedGet('/organizations', organizationController.requestMany);
    router.restrictedGetOne('/organization/<id|[0-9]+>', organizationController.requestSingle);
    router.restrictedGetOne(
        '/organization/<id|[0-9]+>/organizations', organizationController.requestChildOrganizations);
    router.restrictedGetOne('/organization/<id|[0-9]+>/divisions', organizationController.requestDivisions);
    router.restrictedGetOne('/organization/<id|[0-9]+>/clubs', organizationController.requestClubs);
    router.restrictedGetOne('/organization/<id|[0-9]+>/persons', organizationController.requestPersons);
    router.restrictedGetOne('/organization/<id|[0-9]+>/competitions', organizationController.requestCompetitions);

    final divisionController = DivisionController();
    router.restrictedPost('/division', divisionController.postSingle);
    router.restrictedGet('/divisions', divisionController.requestMany);
    router.restrictedGetOne('/division/<id|[0-9]+>', divisionController.requestSingle);
    router.restrictedGetOne('/division/<id|[0-9]+>/leagues', divisionController.requestLeagues);
    router.restrictedGetOne('/division/<id|[0-9]+>/divisions', divisionController.requestChildDivisions);
    router.restrictedGetOne('/division/<id|[0-9]+>/weight_classs', divisionController.requestWeightClasses);
    router.restrictedGetOne(
        '/division/<id|[0-9]+>/division_weight_classs', divisionController.requestDivisionWeightClasses);

    final leagueController = LeagueController();
    router.restrictedPostOne('/league/<id|[0-9]+>/api/import', leagueController.postImport);
    router.restrictedGetOne('/league/<id|[0-9]+>/api/last_import', leagueController.requestLastImportUtcDateTime);
    router.restrictedPost('/league', leagueController.postSingle);
    router.restrictedGet('/leagues', leagueController.requestMany);
    router.restrictedGetOne('/league/<id|[0-9]+>', leagueController.requestSingle);
    router.restrictedGetOne('/league/<id|[0-9]+>/teams', leagueController.requestTeams);
    router.restrictedGetOne(
        '/league/<id|[0-9]+>/league_team_participations', leagueController.requestLeagueTeamParticipations);
    router.restrictedGetOne('/league/<id|[0-9]+>/team_matchs', leagueController.requestTeamMatchs);
    router.restrictedGetOne('/league/<id|[0-9]+>/weight_classs', leagueController.requestWeightClasses);
    router.restrictedGetOne('/league/<id|[0-9]+>/league_weight_classs', leagueController.requestLeagueWeightClasses);

    final divisionWeightClassController = DivisionWeightClassController();
    router.restrictedPost('/division_weight_class', divisionWeightClassController.postSingle);
    router.restrictedGet('/division_weight_classs', divisionWeightClassController.requestMany);
    router.restrictedGetOne('/division_weight_class/<id|[0-9]+>', divisionWeightClassController.requestSingle);

    final leagueTeamParticipationController = LeagueTeamParticipationController();
    router.restrictedPost('/league_team_participation', leagueTeamParticipationController.postSingle);
    router.restrictedGet('/league_team_participations', leagueTeamParticipationController.requestMany);
    router.restrictedGetOne('/league_team_participation/<id|[0-9]+>', leagueTeamParticipationController.requestSingle);

    final leagueWeightClassController = LeagueWeightClassController();
    router.restrictedPost('/league_weight_class', leagueWeightClassController.postSingle);
    router.restrictedGet('/league_weight_classs', leagueWeightClassController.requestMany);
    router.restrictedGetOne('/league_weight_class/<id|[0-9]+>', leagueWeightClassController.requestSingle);

    final lineupController = LineupController();
    router.restrictedPost('/lineup', lineupController.postSingle);
    router.restrictedGet('/lineups', lineupController.requestMany);
    router.restrictedGetOne('/lineup/<id|[0-9]+>', lineupController.requestSingle);
    router.restrictedGetOne('/lineup/<id|[0-9]+>/participations', lineupController.requestParticipations);

    final membershipController = MembershipController();
    router.restrictedPost('/membership', membershipController.postSingle);
    router.restrictedGet('/memberships', membershipController.requestMany);
    router.restrictedGetOne('/membership/<id|[0-9]+>', membershipController.requestSingle);
    router.restrictedGetOne('/membership/<id|[0-9]+>/participations', membershipController.requestParticipations);
    router.restrictedGetOne('/membership/<id|[0-9]+>/team_match_bouts', membershipController.requestTeamMatchBouts);

    final participantStateController = ParticipantStateController();
    router.restrictedPost('/participant_state', participantStateController.postSingle);
    router.restrictedGet('/participant_states', participantStateController.requestMany);
    router.restrictedGetOne('/participant_state/<id|[0-9]+>', participantStateController.requestSingle);

    final participationController = ParticipationController();
    router.restrictedPost('/participation', participationController.postSingle);
    router.restrictedGet('/participations', participationController.requestMany);
    router.restrictedGetOne('/participation/<id|[0-9]+>', participationController.requestSingle);

    final personController = PersonController();
    router.restrictedPost('/person', personController.postSingle);
    router.restrictedGet('/persons', personController.requestMany);
    router.restrictedGetOne('/person/<id|[0-9]+>', personController.requestSingle);
    router.restrictedGetOne('/person/<id|[0-9]+>/memberships', personController.requestMemberships);

    final teamController = TeamController();
    router.restrictedPostOne('/team/<id|[0-9]+>/api/import', teamController.postImport);
    router.restrictedGetOne('/team/<id|[0-9]+>/api/last_import', teamController.requestLastImportUtcDateTime);
    router.restrictedPost('/team', teamController.postSingle);
    router.restrictedGet('/teams', teamController.requestMany);
    router.restrictedGetOne('/team/<id|[0-9]+>', teamController.requestSingle);
    router.restrictedGetOne('/team/<id|[0-9]+>/team_matchs', teamController.requestTeamMatches);
    router.restrictedGetOne('/team/<id|[0-9]+>/clubs', teamController.requestClubs);

    final teamClubAffiliationController = TeamClubAffiliationController();
    router.restrictedPost('/team_club_affiliation', teamClubAffiliationController.postSingle);
    router.restrictedGet('/team_club_affiliations', teamClubAffiliationController.requestMany);
    router.restrictedGetOne('/team_club_affiliation/<id|[0-9]+>', teamClubAffiliationController.requestSingle);

    final matchController = TeamMatchController();
    router.restrictedPostOne('/team_match/<id|[0-9]+>/api/import', matchController.postImport);
    router.restrictedGetOne('/team_match/<id|[0-9]+>/api/last_import', matchController.requestLastImportUtcDateTime);
    router.restrictedPost('/team_match', matchController.postSingle);
    router.restrictedGet('/team_matchs', matchController.requestMany);
    router.restrictedGet('/team_matches', matchController.requestMany);
    router.restrictedGetOne('/team_match/<id|[0-9]+>', matchController.requestSingle);
    router.restrictedPostOne('/team_match/<id|[0-9]+>/bouts/generate', matchController.generateBouts);
    router.restrictedGetOne('/team_match/<id|[0-9]+>/bouts', matchController.requestBouts);
    router.restrictedGetOne('/team_match/<id|[0-9]+>/team_match_bouts', matchController.requestTeamMatchBouts);

    final teamMatchBoutController = TeamMatchBoutController();
    router.restrictedPost('/team_match_bout', teamMatchBoutController.postSingle);
    router.restrictedGet('/team_match_bouts', teamMatchBoutController.requestMany);
    router.restrictedGetOne('/team_match_bout/<id|[0-9]+>', teamMatchBoutController.requestSingle);

    final competitionController = CompetitionController();
    router.restrictedPostOne('/competition/<id|[0-9]+>/api/import', competitionController.postImport);
    router.restrictedGetOne(
        '/competition/<id|[0-9]+>/api/last_import', competitionController.requestLastImportUtcDateTime);
    router.restrictedPost('/competition', competitionController.postSingle);
    router.restrictedGet('/competitions', competitionController.requestMany);
    router.restrictedGetOne('/competition/<id|[0-9]+>', competitionController.requestSingle);
    router.restrictedGetOne('/competition/<id|[0-9]+>/bouts', competitionController.requestBouts);

    final competitionBoutController = CompetitionBoutController();
    router.restrictedPost('/competition_bout', competitionBoutController.postSingle);
    router.restrictedGet('/competition_bouts', competitionBoutController.requestMany);
    router.restrictedGetOne('/competition_bout/<id|[0-9]+>', competitionBoutController.requestSingle);

    final weightClassController = WeightClassController();
    router.restrictedPost('/weight_class', weightClassController.postSingle);
    router.restrictedGet('/weight_classs', weightClassController.requestMany);
    router.restrictedGet('/weight_classes', weightClassController.requestMany);
    router.restrictedGetOne('/weight_class/<id|[0-9]+>', weightClassController.requestSingle);

    // This nested catch-all, will only catch /api/.* when mounted above.
    // Notice that ordering if annotated handlers and mounts is significant.
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }

  Handler get pipeline {
    final pipeline = Pipeline().addMiddleware(contentTypeJsonConfig).addHandler(router.call);
    return pipeline;
  }
}
