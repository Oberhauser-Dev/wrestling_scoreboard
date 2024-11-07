import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
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

  Future<WrestlingApi?> initApiProvider(String? message, int organizationId) async {
    AuthService? authService;
    if (message != null && message.isNotEmpty) {
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
  Future<void> import(
    int entityId, {
    String? message,
    bool obfuscate = true,
    bool includeSubjacent = false,
    bool useMock = false,
  }) async {
    final apiProvider = await initApiProvider(message, entityId);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $entityId.');
    }
    apiProvider.isMock = useMock;

    final teamClubAffiliations = await apiProvider.importTeamClubAffiliations();
    await Future.forEach(teamClubAffiliations, (teamClubAffiliation) async {
      final club = await ClubController().updateOrCreateSingleOfOrg(teamClubAffiliation.club, obfuscate: obfuscate);
      final team = await TeamController().updateOrCreateSingleOfOrg(teamClubAffiliation.team, obfuscate: obfuscate);
      teamClubAffiliation = teamClubAffiliation.copyWith(club: club, team: team);

      // Do not add team club affiliations multiple times.
      final previousTeamClubAffiliation = await TeamClubAffiliationController()
          .getByTeamAndClubId(teamId: team.id!, clubId: club.id!, obfuscate: obfuscate);
      if (previousTeamClubAffiliation == null) {
        await TeamClubAffiliationController().createSingle(TeamClubAffiliation(team: team, club: club));
      }
    });

    final divisionBoutResultRuleMap = await apiProvider.importDivisions(minDate: DateTime(DateTime.now().year - 1));
    final leagues = (await forEachFuture(divisionBoutResultRuleMap.entries, (divisionBoutResultEntry) async {
      Division division = divisionBoutResultEntry.key;
      var boutResultRules = divisionBoutResultEntry.value;
      division = await DivisionController().updateOrCreateSingleOfOrg(
        division,
        obfuscate: obfuscate,
        onUpdateOrCreate: (previousDivision) async {
          final boutConfig = await BoutConfigController()
              .updateOnDiffSingle(division.boutConfig, previous: previousDivision?.boutConfig);
          boutResultRules = boutResultRules.map((rule) => rule.copyWith(boutConfig: boutConfig));
          final prevRules = await BoutResultRuleController().getMany(
              conditions: ['bout_config_id = @id'], substitutionValues: {'id': boutConfig.id}, obfuscate: obfuscate);
          await BoutResultRuleController().updateOnDiffMany(boutResultRules.toList(), previous: prevRules);
          return division.copyWith(boutConfig: boutConfig);
        },
      );

      final divisionWeightClasses = await apiProvider.importDivisionWeightClasses(division: division);
      await Future.forEach(divisionWeightClasses, (divisionWeightClass) async {
        await DivisionWeightClassController().updateOrCreateSingleOfOrg(
          divisionWeightClass,
          obfuscate: obfuscate,
          onUpdateOrCreate: (previousWeightClass) async {
            final weightClass = await WeightClassController()
                .updateOnDiffSingle(divisionWeightClass.weightClass, previous: previousWeightClass?.weightClass);
            return divisionWeightClass.copyWith(weightClass: weightClass);
          },
        );
      });

      var leagues = await apiProvider.importLeagues(division: division);
      leagues = await LeagueController().updateOrCreateManyOfOrg(leagues.toList(), obfuscate: obfuscate);
      return leagues;
    }))
        .expand((league) => league);

    updateLastImportUtcDateTime(entityId);
    if (includeSubjacent) {
      for (final league in leagues) {
        await LeagueController().import(
          league.id!,
          message: message,
          obfuscate: obfuscate,
          useMock: useMock,
          includeSubjacent: includeSubjacent,
        );
      }
    }
  }

  Future<List<DataObject>> search(
    Request request,
    int id, {
    required String searchStr,
    required Type searchType,
  }) async {
    final message = await request.readAsString();
    final apiProvider = await initApiProvider(message, id);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $id.');
    }
    return await apiProvider.search(searchStr: searchStr, searchType: searchType);
  }
}
