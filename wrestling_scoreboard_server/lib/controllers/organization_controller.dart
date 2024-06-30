import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'bout_config_controller.dart';
import 'league_controller.dart';

class OrganizationController extends EntityController<Organization> {
  static final OrganizationController _singleton = OrganizationController._internal();

  factory OrganizationController() {
    return _singleton;
  }

  OrganizationController._internal() : super(tableName: 'organization');

  Future<Response> requestDivisions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(DivisionController(),
        isRaw: request.isRaw, conditions: ['organization_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestClubs(Request request, String id) async {
    return EntityController.handleRequestManyOfController(ClubController(),
        isRaw: request.isRaw, conditions: ['organization_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestCompetitions(Request request, String id) async {
    return EntityController.handleRequestManyOfController(CompetitionController(),
        isRaw: request.isRaw, conditions: ['organization_id = @id'], substitutionValues: {'id': id});
  }

  Future<Response> requestChildOrganizations(Request request, String id) async {
    return EntityController.handleRequestManyOfController(OrganizationController(),
        isRaw: request.isRaw, conditions: ['parent_id = @id'], substitutionValues: {'id': id});
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

    final organization = await getSingle(organizationId);
    return organization.getApi(EntityController.getSingleFromDataTypeOfOrg, authService: authService);
  }

  Future<Response> import(Request request, String organizationId) async {
    try {
      final apiProvider = await initApiProvider(request, int.parse(organizationId));
      if (apiProvider == null) {
        throw Exception('No API provider selected for the organization $organizationId.');
      }
      // apiProvider.isMock = true;

      final clubs = await apiProvider.importClubs();
      await Future.forEach(clubs, (club) async {
        club = await ClubController().getOrCreateSingleOfOrg(club);

        final teams = await apiProvider.importTeams(club: club);
        await TeamController().getOrCreateManyOfOrg(teams.toList());
      });

      final divisions = await apiProvider.importDivisions(minDate: DateTime(DateTime.now().year - 1));
      await Future.forEach(divisions, (division) async {
        // TODO: Don't create bout config or delete old one, if division already exists.
        final boutConfig = await BoutConfigController().createSingleReturn(division.boutConfig);
        division = division.copyWith(boutConfig: boutConfig);
        division = await DivisionController().getOrCreateSingleOfOrg(division);

        // TODO: Don't create (division) weight classes or delete old ones, if division already exists.
        final divisionWeightClasses = await apiProvider.importDivisionWeightClasses(division: division);
        await Future.forEach(divisionWeightClasses, (divisionWeightClass) async {
          final weightClass = await WeightClassController().createSingleReturn(divisionWeightClass.weightClass);
          divisionWeightClass = divisionWeightClass.copyWith(weightClass: weightClass);
          divisionWeightClass = await DivisionWeightClassController().createSingleReturn(divisionWeightClass);
        });

        var leagues = await apiProvider.importLeagues(division: division);
        leagues = await LeagueController().getOrCreateManyOfOrg(leagues.toList());
      });

      return Response.ok('{"status": "success"}');
    } catch (err, stackTrace) {
      return Response.internalServerError(body: '{"err": "$err", "stackTrace": "$stackTrace"}');
    }
  }

  Future<List<DataObject>> search(Request request, int id,
      {required String searchStr, required Type searchType}) async {
    final apiProvider = await initApiProvider(request, id);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $id.');
    }
    return await apiProvider.search(searchStr: searchStr, searchType: searchType);
  }

  @override
  Set<String> getSearchableAttributes() => {'name', 'abbreviation'};
}
