import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/orderable_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/database_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/search_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/middleware/content_type.dart';
import 'package:wrestling_scoreboard_server/middleware/error.dart';
import 'package:wrestling_scoreboard_server/request.dart';
import 'package:wrestling_scoreboard_server/routes/data_object_relations.dart';
import 'package:wrestling_scoreboard_server/routes/router.dart';

class ApiRoute {
  // By exposing a [Router] for an object, it can be mounted in other routers.
  Router get router {
    final router = Router();

    // Generate POST single, GET single and GET all objects of the dataTypes
    for (var dataType in dataTypes) {
      if (dataType == User) continue;
      if (dataType == SecuredUser) continue;
      if (dataType == ScratchBout) continue;

      final controller = ShelfController.getControllerFromDataType(dataType)!;
      final typeRoute = '/${controller.tableName}';
      if (controller is OrderableController) {
        router.restrictedPostOne('$typeRoute/<id|[0-9]+>/reorder', controller.postRequestReorder);
      }
      router.restrictedPost(typeRoute, controller.postRequestSingle);
      router.restrictedDeleteOne('$typeRoute/<id|[0-9]+>', controller.deleteRequestSingle);
      router.restrictedGet('${typeRoute}s', controller.getRequestMany);
      router.restrictedGetOne('$typeRoute/<id|[0-9]+>', controller.getRequestSingle);
    }

    // Generate GET endpoints simple object relations
    directDataObjectRelations.forEach((dataObjectType, relationMap) {
      relationMap.forEach((propertyType, propertyConfig) {
        final (tableRef, orderBy) = propertyConfig;
        router.restrictedGetOne(
          '/${getTableNameFromType(propertyType)}/<id|[0-9]+>/${getTableNameFromType(dataObjectType)}s',
          (Request request, User? user, String id) =>
              ShelfController.getControllerFromDataType(dataObjectType)!.handleGetRequestMany(
                isRaw: request.isRaw,
                conditions: ['$tableRef = @id'],
                substitutionValues: {'id': id},
                orderBy: orderBy,
                obfuscate: user?.obfuscate ?? true,
              ),
        );
      });
    });

    // Specify specific API endpoints

    final databaseController = DatabaseController();
    router.restrictedGet('/database/export', databaseController.export, UserPrivilege.admin);
    router.restrictedPost('/database/reset', databaseController.reset, UserPrivilege.admin);
    router.restrictedPost('/database/restore', databaseController.restore, UserPrivilege.admin);
    router.restrictedPost('/database/restore_default', databaseController.restorePrepopulated, UserPrivilege.admin);
    router.get('/database/${Migration.cTableName}', databaseController.getMigration);

    final authController = AuthController();
    router.restrictedGet('/auth/user', authController.requestUser);
    router.post('/auth/sign_in', authController.signIn);
    router.post('/auth/sign_up', authController.signUp);
    router.restrictedPost('/auth/user', authController.updateSingle);

    final userController = SecuredUserController();
    router.restrictedPost('/user', userController.postSingleUser, UserPrivilege.admin); // Create
    router.restrictedPost(
      '/${SecuredUser.cTableName}',
      userController.postRequestSingle,
      UserPrivilege.admin,
    ); // Update
    router.restrictedGet('/${SecuredUser.cTableName}s', userController.getRequestMany, UserPrivilege.admin);
    router.restrictedGetOne(
      '/${SecuredUser.cTableName}s/<id|[0-9]+>',
      userController.getRequestSingle,
      UserPrivilege.admin,
    );

    final searchController = SearchController();
    router.restrictedGet('/search', searchController.search);
    router.restrictedPost('/search', searchController.search);

    final clubController = ClubController();
    router.restrictedGetOne('/${Club.cTableName}/<id|[0-9]+>/${Team.cTableName}s', clubController.requestTeams);
    // router.restrictedGet('/${Club.cTableName}/<no|[0-9]{5}>', clubRequest);

    final organizationController = OrganizationController();
    router.restrictedPostOne('/${Organization.cTableName}/<id|[0-9]+>/api/import', organizationController.postImport);
    router.restrictedGetOne(
      '/${Organization.cTableName}/<id|[0-9]+>/api/last_import',
      organizationController.requestLastImportUtcDateTime,
    );
    // Need to use post, as credentials are appended in body
    router.restrictedPostOne(
      '/${Organization.cTableName}/<id|[0-9]+>/api/check_credentials',
      organizationController.postCheckCredentials,
    );

    final divisionController = DivisionController();
    router.restrictedGetOne(
      '/${Division.cTableName}/<id|[0-9]+>/${WeightClass.cTableName}s',
      divisionController.requestWeightClasses,
    );

    final leagueController = LeagueController();
    router.restrictedPostOne('/${League.cTableName}/<id|[0-9]+>/api/import', leagueController.postImport);
    router.restrictedGetOne(
      '/${League.cTableName}/<id|[0-9]+>/api/last_import',
      leagueController.requestLastImportUtcDateTime,
    );
    router.restrictedGetOne(
      '/${League.cTableName}/<id|[0-9]+>/${WeightClass.cTableName}s',
      leagueController.requestWeightClasses,
    );

    final membershipController = MembershipController();
    router.restrictedGetOne(
      '/${Membership.cTableName}/<id|[0-9]+>/${TeamMatchBout.cTableName}s',
      membershipController.requestTeamMatchBouts,
    );
    router.restrictedGetOne(
      '/${Membership.cTableName}/<id|[0-9]+>/${CompetitionBout.cTableName}s',
      membershipController.requestCompetitionBouts,
    );

    final personController = PersonController();
    router.restrictedPost('/${Person.cTableName}s/merge', personController.postMerge);

    final teamController = TeamController();
    router.restrictedPostOne('/${Team.cTableName}/<id|[0-9]+>/api/import', teamController.postImport);
    router.restrictedGetOne(
      '/${Team.cTableName}/<id|[0-9]+>/api/last_import',
      teamController.requestLastImportUtcDateTime,
    );
    router.restrictedGetOne(
      '/${Team.cTableName}/<id|[0-9]+>/${TeamMatch.cTableName}s',
      teamController.requestTeamMatches,
    );
    router.restrictedGetOne('/${Team.cTableName}/<id|[0-9]+>/${Club.cTableName}s', teamController.requestClubs);

    final matchController = TeamMatchController();
    router.restrictedPostOne('/${TeamMatch.cTableName}/<id|[0-9]+>/api/import', matchController.postImport);
    router.restrictedGetOne(
      '/${TeamMatch.cTableName}/<id|[0-9]+>/api/last_import',
      matchController.requestLastImportUtcDateTime,
    );
    router.restrictedPostOne(
      '/${TeamMatch.cTableName}/<id|[0-9]+>/${Bout.cTableName}s/generate',
      matchController.generateBouts,
    );
    router.restrictedGetOne('/${TeamMatch.cTableName}/<id|[0-9]+>/${Bout.cTableName}s', matchController.requestBouts);

    final competitionController = CompetitionController();
    router.restrictedPostOne('/${Competition.cTableName}/<id|[0-9]+>/api/import', competitionController.postImport);
    router.restrictedGetOne(
      '/${Competition.cTableName}/<id|[0-9]+>/api/last_import',
      competitionController.requestLastImportUtcDateTime,
    );

    final competitionWeightCategoryController = CompetitionWeightCategoryController();
    router.restrictedPostOne(
      '/${CompetitionWeightCategory.cTableName}/<id|[0-9]+>/${Bout.cTableName}s/generate',
      competitionWeightCategoryController.generateBouts,
    );

    // This nested catch-all, will only catch /api/.* when mounted above.
    // Notice that ordering if annotated handlers and mounts is significant.
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }

  Handler get pipeline {
    final pipeline = Pipeline()
        .addMiddleware(errorPipelineConfig)
        .addMiddleware(contentTypeJsonConfig)
        .addHandler(router.call);
    return pipeline;
  }
}
