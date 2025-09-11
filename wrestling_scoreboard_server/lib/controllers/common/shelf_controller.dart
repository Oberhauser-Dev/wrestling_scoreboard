import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/age_category_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/athlete_bout_state_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_action_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_config_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/websocket_handler.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_age_category_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_system_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_weight_category_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_team_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/membership_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_lineup_participation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_bout_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/user_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

final _logger = Logger('shelf_controller');

abstract class ShelfController<T extends DataObject> extends EntityController<T> {
  ShelfController({super.primaryKeyName});

  Future<Response> getRequestSingle(Request request, User? user, String id) async {
    return handleGetRequestSingle(int.parse(id), isRaw: request.isRaw, obfuscate: user?.obfuscate ?? true);
  }

  Future<Response> getRequestMany(Request request, User? user) async {
    return handleGetRequestMany(isRaw: request.isRaw, obfuscate: user?.obfuscate ?? true);
  }

  Future<Response> handleGetRequestSingle(int id, {bool isRaw = false, bool obfuscate = false}) async {
    if (isRaw) {
      final single = await getSingleRaw(id, obfuscate: obfuscate);
      return Response.ok(rawJsonEncode(single));
    } else {
      final single = await getSingle(id, obfuscate: obfuscate);
      return Response.ok(jsonEncode(single));
    }
  }

  Future<Response> handleGetRequestMany({
    bool isRaw = false,
    List<String>? conditions,
    Conjunction conjunction = Conjunction.and,
    Map<String, dynamic>? substitutionValues,
    List<String> orderBy = const [],
    required bool obfuscate,
  }) async {
    if (isRaw) {
      final many = await getManyRaw(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        orderBy: orderBy,
        obfuscate: obfuscate,
      );
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await getMany(
        conditions: conditions,
        conjunction: conjunction,
        substitutionValues: substitutionValues,
        orderBy: orderBy,
        obfuscate: obfuscate,
      );
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  Future<Response> handleGetRequestManyFromQuery({
    bool isRaw = false,
    required String sqlQuery,
    Map<String, dynamic>? substitutionValues,
    required bool obfuscate,
  }) async {
    if (isRaw) {
      final many = await getManyRawFromQuery(sqlQuery, substitutionValues: substitutionValues);
      return Response.ok(rawJsonEncode(many.toList()));
    } else {
      final many = await getManyFromQuery(sqlQuery, substitutionValues: substitutionValues, obfuscate: obfuscate);
      return Response.ok(jsonEncode(many.toList()));
    }
  }

  Future<Response> postRequestSingle(Request request, User? user) async {
    final message = await request.readAsString();
    try {
      return handlePostRequestSingle(jsonDecode(message));
    } on FormatException catch (e) {
      final errMessage =
          'The data object of table "$tableName" could not be created. Check the format: $message'
          '\nFormatException: ${e.message}';
      _logger.warning(errMessage.toString());
      return Response.badRequest(body: errMessage);
    }
  }

  Future<Response> handlePostRequestSingle(Map<String, Object?> json) async {
    final id = await handleJson<T>(
      json,
      handleSingle: handleSingle,
      handleMany: handleMany,
      handleSingleRaw: handleSingleRaw,
      handleManyRaw: handleManyRaw,
    );
    return Response.ok(jsonEncode(id));
  }

  static ShelfController? getControllerFromDataType(Type t) {
    switch (t) {
      case const (AgeCategory):
        return AgeCategoryController();
      case const (Bout):
        return BoutController();
      case const (BoutAction):
        return BoutActionController();
      case const (BoutConfig):
        return BoutConfigController();
      case const (BoutResultRule):
        return BoutResultRuleController();
      case const (Club):
        return ClubController();
      case const (Competition):
        return CompetitionController();
      case const (CompetitionPerson):
        return CompetitionPersonController();
      case const (CompetitionBout):
        return CompetitionBoutController();
      case const (CompetitionLineup):
        return CompetitionLineupController();
      case const (CompetitionSystemAffiliation):
        return CompetitionSystemAffiliationController();
      case const (CompetitionAgeCategory):
        return CompetitionAgeCategoryController();
      case const (CompetitionWeightCategory):
        return CompetitionWeightCategoryController();
      case const (CompetitionParticipation):
        return CompetitionParticipationController();
      case const (Organization):
        return OrganizationController();
      case const (Division):
        return DivisionController();
      case const (DivisionWeightClass):
        return DivisionWeightClassController();
      case const (League):
        return LeagueController();
      case const (LeagueTeamParticipation):
        return LeagueTeamParticipationController();
      case const (LeagueWeightClass):
        return LeagueWeightClassController();
      case const (TeamLineup):
        return TeamLineupController();
      case const (Membership):
        return MembershipController();
      case const (TeamLineupParticipation):
        return TeamLineupParticipationController();
      case const (AthleteBoutState):
        return AthleteBoutStateController();
      case const (Person):
        return PersonController();
      case const (SecuredUser):
        return SecuredUserController();
      case const (Team):
        return TeamController();
      case const (TeamClubAffiliation):
        return TeamClubAffiliationController();
      case const (TeamMatch):
        return TeamMatchController();
      case const (TeamMatchBout):
        return TeamMatchBoutController();
      case const (TeamMatchPerson):
        return TeamMatchPersonController();
      case const (WeightClass):
        return WeightClassController();
      default:
        return null;
    }
  }

  UserPrivilege get controllerPrivilege => UserPrivilege.none;
}
