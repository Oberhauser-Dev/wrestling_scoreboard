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
import '../controllers/membership_controller.dart';
import '../controllers/organization_controller.dart';
import '../controllers/participant_state_controller.dart';
import '../controllers/participation_controller.dart';
import '../controllers/person_controller.dart';
import '../controllers/search_controller.dart';
import '../controllers/team_club_affiliation_controller.dart';
import '../controllers/team_controller.dart';
import '../controllers/team_lineup_controller.dart';
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
    router.restrictedPost('/${SecuredUser.cTableName}', userController.postSingle, UserPrivilege.admin); // Update
    router.restrictedGet('/${SecuredUser.cTableName}s', userController.requestMany, UserPrivilege.admin);
    router.restrictedGetOne(
        '/${SecuredUser.cTableName}s/<id|[0-9]+>', userController.requestSingle, UserPrivilege.admin);

    final searchController = SearchController();
    router.restrictedGet('/search', searchController.search);
    router.restrictedPost('/search', searchController.search);

    final boutConfigController = BoutConfigController();
    router.restrictedPost('/${BoutConfig.cTableName}', boutConfigController.postSingle);
    router.restrictedGet('/${BoutConfig.cTableName}s', boutConfigController.requestMany);
    router.restrictedGetOne('/${BoutConfig.cTableName}/<id|[0-9]+>', boutConfigController.requestSingle);
    router.restrictedGetOne(
        '/${BoutConfig.cTableName}/<id|[0-9]+>/bout_result_rules', boutConfigController.requestBoutResultRules);

    final boutResultRuleController = BoutResultRuleController();
    router.restrictedPost('/${BoutResultRule.cTableName}', boutResultRuleController.postSingle);
    router.restrictedGet('/${BoutResultRule.cTableName}s', boutResultRuleController.requestMany);
    router.restrictedGetOne('/${BoutResultRule.cTableName}/<id|[0-9]+>', boutResultRuleController.requestSingle);

    final clubController = ClubController();
    router.restrictedPost('/${Club.cTableName}', clubController.postSingle);
    router.restrictedGet('/${Club.cTableName}s', clubController.requestMany);
    router.restrictedGetOne('/${Club.cTableName}/<id|[0-9]+>', clubController.requestSingle);
    router.restrictedGetOne('/${Club.cTableName}/<id|[0-9]+>/teams', clubController.requestTeams);
    router.restrictedGetOne('/${Club.cTableName}/<id|[0-9]+>/memberships', clubController.requestMemberships);
    // router.restrictedGet('/${Club.cTableName}/<no|[0-9]{5}>', clubRequest);

    final boutController = BoutController();
    router.restrictedPost('/${Bout.cTableName}', boutController.postSingle);
    router.restrictedGet('/${Bout.cTableName}s', boutController.requestMany);
    router.restrictedGetOne('/${Bout.cTableName}/<id|[0-9]+>', boutController.requestSingle);
    router.restrictedGetOne('/${Bout.cTableName}/<id|[0-9]+>/bout_actions', boutController.requestBoutActions);

    final boutActionController = BoutActionController();
    router.restrictedPost('/${BoutAction.cTableName}', boutActionController.postSingle);
    router.restrictedGet('/${BoutAction.cTableName}s', boutActionController.requestMany);
    router.restrictedGetOne('/${BoutAction.cTableName}/<id|[0-9]+>', boutActionController.requestSingle);

    final organizationController = OrganizationController();
    router.restrictedPostOne('/${Organization.cTableName}/<id|[0-9]+>/api/import', organizationController.postImport);
    router.restrictedGetOne(
        '/${Organization.cTableName}/<id|[0-9]+>/api/last_import', organizationController.requestLastImportUtcDateTime);
    router.restrictedPost('/${Organization.cTableName}', organizationController.postSingle);
    router.restrictedGet('/${Organization.cTableName}s', organizationController.requestMany);
    router.restrictedGetOne('/${Organization.cTableName}/<id|[0-9]+>', organizationController.requestSingle);
    router.restrictedGetOne(
        '/${Organization.cTableName}/<id|[0-9]+>/organizations', organizationController.requestChildOrganizations);
    router.restrictedGetOne(
        '/${Organization.cTableName}/<id|[0-9]+>/divisions', organizationController.requestDivisions);
    router.restrictedGetOne('/${Organization.cTableName}/<id|[0-9]+>/clubs', organizationController.requestClubs);
    router.restrictedGetOne('/${Organization.cTableName}/<id|[0-9]+>/persons', organizationController.requestPersons);
    router.restrictedGetOne(
        '/${Organization.cTableName}/<id|[0-9]+>/competitions', organizationController.requestCompetitions);

    final divisionController = DivisionController();
    router.restrictedPost('/${Division.cTableName}', divisionController.postSingle);
    router.restrictedGet('/${Division.cTableName}s', divisionController.requestMany);
    router.restrictedGetOne('/${Division.cTableName}/<id|[0-9]+>', divisionController.requestSingle);
    router.restrictedGetOne('/${Division.cTableName}/<id|[0-9]+>/leagues', divisionController.requestLeagues);
    router.restrictedGetOne('/${Division.cTableName}/<id|[0-9]+>/divisions', divisionController.requestChildDivisions);
    router.restrictedGetOne(
        '/${Division.cTableName}/<id|[0-9]+>/weight_classs', divisionController.requestWeightClasses);
    router.restrictedGetOne(
        '/${Division.cTableName}/<id|[0-9]+>/division_weight_classs', divisionController.requestDivisionWeightClasses);

    final leagueController = LeagueController();
    router.restrictedPostOne('/${League.cTableName}/<id|[0-9]+>/api/import', leagueController.postImport);
    router.restrictedGetOne(
        '/${League.cTableName}/<id|[0-9]+>/api/last_import', leagueController.requestLastImportUtcDateTime);
    router.restrictedPost('/${League.cTableName}', leagueController.postSingle);
    router.restrictedGet('/${League.cTableName}s', leagueController.requestMany);
    router.restrictedGetOne('/${League.cTableName}/<id|[0-9]+>', leagueController.requestSingle);
    router.restrictedGetOne('/${League.cTableName}/<id|[0-9]+>/teams', leagueController.requestTeams);
    router.restrictedGetOne('/${League.cTableName}/<id|[0-9]+>/league_team_participations',
        leagueController.requestLeagueTeamParticipations);
    router.restrictedGetOne('/${League.cTableName}/<id|[0-9]+>/team_matchs', leagueController.requestTeamMatchs);
    router.restrictedGetOne('/${League.cTableName}/<id|[0-9]+>/weight_classs', leagueController.requestWeightClasses);
    router.restrictedGetOne(
        '/${League.cTableName}/<id|[0-9]+>/league_weight_classs', leagueController.requestLeagueWeightClasses);

    final divisionWeightClassController = DivisionWeightClassController();
    router.restrictedPost('/${DivisionWeightClass.cTableName}', divisionWeightClassController.postSingle);
    router.restrictedGet('/${DivisionWeightClass.cTableName}s', divisionWeightClassController.requestMany);
    router.restrictedGetOne(
        '/${DivisionWeightClass.cTableName}/<id|[0-9]+>', divisionWeightClassController.requestSingle);

    final leagueTeamParticipationController = LeagueTeamParticipationController();
    router.restrictedPost('/${LeagueTeamParticipation.cTableName}', leagueTeamParticipationController.postSingle);
    router.restrictedGet('/${LeagueTeamParticipation.cTableName}s', leagueTeamParticipationController.requestMany);
    router.restrictedGetOne(
        '/${LeagueTeamParticipation.cTableName}/<id|[0-9]+>', leagueTeamParticipationController.requestSingle);

    final leagueWeightClassController = LeagueWeightClassController();
    router.restrictedPost('/league_weight_class', leagueWeightClassController.postSingle);
    router.restrictedGet('/league_weight_classs', leagueWeightClassController.requestMany);
    router.restrictedGetOne('/league_weight_class/<id|[0-9]+>', leagueWeightClassController.requestSingle);

    final lineupController = TeamLineupController();
    router.restrictedPost('/${TeamLineup.cTableName}', lineupController.postSingle);
    router.restrictedGet('/${TeamLineup.cTableName}s', lineupController.requestMany);
    router.restrictedGetOne('/${TeamLineup.cTableName}/<id|[0-9]+>', lineupController.requestSingle);
    router.restrictedGetOne(
        '/${TeamLineup.cTableName}/<id|[0-9]+>/participations', lineupController.requestParticipations);

    final membershipController = MembershipController();
    router.restrictedPost('/${Membership.cTableName}', membershipController.postSingle);
    router.restrictedGet('/${Membership.cTableName}s', membershipController.requestMany);
    router.restrictedGetOne('/${Membership.cTableName}/<id|[0-9]+>', membershipController.requestSingle);
    router.restrictedGetOne(
        '/${Membership.cTableName}/<id|[0-9]+>/participations', membershipController.requestParticipations);
    router.restrictedGetOne(
        '/${Membership.cTableName}/<id|[0-9]+>/team_match_bouts', membershipController.requestTeamMatchBouts);

    final participantStateController = ParticipantStateController();
    router.restrictedPost('/${AthleteBoutState.cTableName}', participantStateController.postSingle);
    router.restrictedGet('/${AthleteBoutState.cTableName}s', participantStateController.requestMany);
    router.restrictedGetOne('/${AthleteBoutState.cTableName}/<id|[0-9]+>', participantStateController.requestSingle);

    final participationController = ParticipationController();
    router.restrictedPost('/${TeamLineupParticipation.cTableName}', participationController.postSingle);
    router.restrictedGet('/${TeamLineupParticipation.cTableName}s', participationController.requestMany);
    router.restrictedGetOne(
        '/${TeamLineupParticipation.cTableName}/<id|[0-9]+>', participationController.requestSingle);

    final personController = PersonController();
    router.restrictedPost('/${Person.cTableName}', personController.postSingle);
    router.restrictedGet('/${Person.cTableName}s', personController.requestMany);
    router.restrictedPost('/${Person.cTableName}/merge', personController.postMerge);
    router.restrictedGetOne('/${Person.cTableName}/<id|[0-9]+>', personController.requestSingle);
    router.restrictedGetOne('/${Person.cTableName}/<id|[0-9]+>/memberships', personController.requestMemberships);

    final teamController = TeamController();
    router.restrictedPostOne('/${Team.cTableName}/<id|[0-9]+>/api/import', teamController.postImport);
    router.restrictedGetOne(
        '/${Team.cTableName}/<id|[0-9]+>/api/last_import', teamController.requestLastImportUtcDateTime);
    router.restrictedPost('/${Team.cTableName}', teamController.postSingle);
    router.restrictedGet('/${Team.cTableName}s', teamController.requestMany);
    router.restrictedGetOne('/${Team.cTableName}/<id|[0-9]+>', teamController.requestSingle);
    router.restrictedGetOne('/${Team.cTableName}/<id|[0-9]+>/team_matchs', teamController.requestTeamMatches);
    router.restrictedGetOne('/${Team.cTableName}/<id|[0-9]+>/clubs', teamController.requestClubs);

    final teamClubAffiliationController = TeamClubAffiliationController();
    router.restrictedPost('/${TeamClubAffiliation.cTableName}', teamClubAffiliationController.postSingle);
    router.restrictedGet('/${TeamClubAffiliation.cTableName}s', teamClubAffiliationController.requestMany);
    router.restrictedGetOne(
        '/${TeamClubAffiliation.cTableName}/<id|[0-9]+>', teamClubAffiliationController.requestSingle);

    final matchController = TeamMatchController();
    router.restrictedPostOne('/${TeamMatch.cTableName}/<id|[0-9]+>/api/import', matchController.postImport);
    router.restrictedGetOne(
        '/${TeamMatch.cTableName}/<id|[0-9]+>/api/last_import', matchController.requestLastImportUtcDateTime);
    router.restrictedPost('/${TeamMatch.cTableName}', matchController.postSingle);
    router.restrictedGet('/${TeamMatch.cTableName}s', matchController.requestMany);
    router.restrictedGet('/${TeamMatch.cTableName}es', matchController.requestMany);
    router.restrictedGetOne('/${TeamMatch.cTableName}/<id|[0-9]+>', matchController.requestSingle);
    router.restrictedPostOne('/${TeamMatch.cTableName}/<id|[0-9]+>/bouts/generate', matchController.generateBouts);
    router.restrictedGetOne('/${TeamMatch.cTableName}/<id|[0-9]+>/bouts', matchController.requestBouts);
    router.restrictedGetOne(
        '/${TeamMatch.cTableName}/<id|[0-9]+>/team_match_bouts', matchController.requestTeamMatchBouts);

    final teamMatchBoutController = TeamMatchBoutController();
    router.restrictedPost('/${TeamMatchBout.cTableName}', teamMatchBoutController.postSingle);
    router.restrictedGet('/${TeamMatchBout.cTableName}s', teamMatchBoutController.requestMany);
    router.restrictedGetOne('/${TeamMatchBout.cTableName}/<id|[0-9]+>', teamMatchBoutController.requestSingle);

    final competitionController = CompetitionController();
    router.restrictedPostOne('/${Competition.cTableName}/<id|[0-9]+>/api/import', competitionController.postImport);
    router.restrictedGetOne(
        '/${Competition.cTableName}/<id|[0-9]+>/api/last_import', competitionController.requestLastImportUtcDateTime);
    router.restrictedPost('/${Competition.cTableName}', competitionController.postSingle);
    router.restrictedGet('/${Competition.cTableName}s', competitionController.requestMany);
    router.restrictedGetOne('/${Competition.cTableName}/<id|[0-9]+>', competitionController.requestSingle);
    router.restrictedGetOne('/${Competition.cTableName}/<id|[0-9]+>/bouts', competitionController.requestBouts);

    final competitionBoutController = CompetitionBoutController();
    router.restrictedPost('/${CompetitionBout.cTableName}', competitionBoutController.postSingle);
    router.restrictedGet('/${CompetitionBout.cTableName}s', competitionBoutController.requestMany);
    router.restrictedGetOne('/${CompetitionBout.cTableName}/<id|[0-9]+>', competitionBoutController.requestSingle);

    final weightClassController = WeightClassController();
    router.restrictedPost('/${WeightClass.cTableName}', weightClassController.postSingle);
    router.restrictedGet('/${WeightClass.cTableName}s', weightClassController.requestMany);
    router.restrictedGet('/${WeightClass.cTableName}es', weightClassController.requestMany);
    router.restrictedGetOne('/${WeightClass.cTableName}/<id|[0-9]+>', weightClassController.requestSingle);

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
