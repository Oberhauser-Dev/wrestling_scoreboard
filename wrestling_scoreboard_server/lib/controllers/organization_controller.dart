import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'bout_config_controller.dart';
import 'league_controller.dart';

class OrganizationController extends ShelfController<Organization> with ImportController {
  static final OrganizationController _singleton = OrganizationController._internal();

  factory OrganizationController() {
    return _singleton;
  }

  OrganizationController._internal() : super(tableName: 'organization');

  Future<Response> requestDivisions(Request request, User? user, String id) async {
    return DivisionController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['organization_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestClubs(Request request, User? user, String id) async {
    return ClubController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['organization_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestCompetitions(Request request, User? user, String id) async {
    return CompetitionController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['organization_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<Response> requestChildOrganizations(Request request, User? user, String id) async {
    return OrganizationController().handleRequestMany(
      isRaw: request.isRaw,
      conditions: ['parent_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: user?.obfuscate ?? true,
    );
  }

  Future<WrestlingApi?> initApiProvider(Request request, int organizationId) async {
    AuthService? authService;
    final message = await request.readAsString();
    if (message.isNotEmpty) {
      final jsonDecodedMessage = jsonDecode(message);
      final authType = getTypeFromTableName(jsonDecodedMessage['tableName']);
      if (authType == BasicAuthService) {
        authService = BasicAuthService.fromJson(jsonDecodedMessage['data']);
      }
    }

    final organization = await getSingle(organizationId, obfuscate: false);
    return organization.getApi(
        <T extends Organizational>(orgSyncId, {required int orgId}) =>
            OrganizationalController.getSingleFromDataTypeOfOrg(orgSyncId, orgId: orgId, obfuscate: false),
        authService: authService);
  }

  @override
  Future<Response> import(Request request, User? user, String entityId) async {
    try {
      final bool obfuscate = user?.obfuscate ?? true;
      final apiProvider = await initApiProvider(request, int.parse(entityId));
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $entityId.');
      }
      // apiProvider.isMock = true;

      final teamClubAffiliations = await apiProvider.importTeamClubAffiliations();
      await Future.forEach(teamClubAffiliations, (teamClubAffiliation) async {
        final club = await ClubController().getOrCreateSingleOfOrg(teamClubAffiliation.club, obfuscate: obfuscate);
        final team = await TeamController().getOrCreateSingleOfOrg(teamClubAffiliation.team, obfuscate: obfuscate);
        teamClubAffiliation = teamClubAffiliation.copyWith(club: club, team: team);

        try {
          await TeamClubAffiliationController().createSingle(TeamClubAffiliation(team: team, club: club));
        } on InvalidParameterException catch (_) {
          // Do not add team club affiliations multiple times.
        }
      });

      final divisions = await apiProvider.importDivisions(minDate: DateTime(DateTime.now().year - 1));
      await Future.forEach(divisions, (division) async {
        division =
            await DivisionController().getOrCreateSingleOfOrg(division, obfuscate: obfuscate, onCreate: () async {
          final boutConfig = await BoutConfigController().createSingleReturn(division.boutConfig);
          return division.copyWith(boutConfig: boutConfig);
        });

        final divisionWeightClasses = await apiProvider.importDivisionWeightClasses(division: division);
        await Future.forEach(divisionWeightClasses, (divisionWeightClass) async {
          await DivisionWeightClassController().getOrCreateSingleOfOrg(divisionWeightClass, obfuscate: obfuscate,
              onCreate: () async {
            final weightClass = await WeightClassController().createSingleReturn(divisionWeightClass.weightClass);
            return divisionWeightClass.copyWith(weightClass: weightClass);
          });
        });

        var leagues = await apiProvider.importLeagues(division: division);
        leagues = await LeagueController().getOrCreateManyOfOrg(leagues.toList(), obfuscate: obfuscate);
      });

      updateLastImportUtcDateTime(entityId);
      return Response.ok('{"status": "success"}');
    } on HttpException catch (err, stackTrace) {
      return Response.badRequest(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }

  Future<List<DataObject>> search(
    Request request,
    int id, {
    required String searchStr,
    required Type searchType,
  }) async {
    final apiProvider = await initApiProvider(request, id);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $id.');
    }
    return await apiProvider.search(searchStr: searchStr, searchType: searchType);
  }
}
