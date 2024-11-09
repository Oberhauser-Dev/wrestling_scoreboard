import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/auth_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/competition_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/request.dart';

import 'bout_config_controller.dart';
import 'league_controller.dart';

class OrganizationController extends ShelfController<Organization> with ImportController<Organization> {
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

  Future<WrestlingApi?> initApiProvider({String? message, required Organization organization}) async {
    AuthService? authService;
    if (message != null && message.isNotEmpty) {
      final jsonDecodedMessage = jsonDecode(message);
      final authType = getTypeFromTableName(jsonDecodedMessage['tableName']);
      if (authType == BasicAuthService) {
        authService = BasicAuthService.fromJson(jsonDecodedMessage['data']);
      }
    }

    return organization.getApi(
        <T extends Organizational>(orgSyncId, {required int orgId}) =>
            OrganizationalController.getSingleFromDataTypeOfOrg(orgSyncId, orgId: orgId, obfuscate: false),
        authService: authService);
  }

  @override
  Future<void> import({
    required WrestlingApi apiProvider,
    required Organization entity,
    bool obfuscate = true,
    bool includeSubjacent = false,
  }) async {
    final teamClubAffiliations = await apiProvider.importTeamClubAffiliations();

    await Future.forEach(teamClubAffiliations, (teamClubAffiliation) async {
      // TODO: if a TeamClubAffiliation is removed, it should also be removed here
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
    final divisions = await DivisionController().updateOrCreateManyOfOrg(
      divisionBoutResultRuleMap.keys.toList(),
      obfuscate: obfuscate,
      conditions: ['organization_id = @id'],
      substitutionValues: {'id': entity.id},
      onUpdateOrCreate: (previousDivision, division) async {
        var boutResultRules = divisionBoutResultRuleMap[division]!;
        final boutConfig = await BoutConfigController()
            .updateOnDiffSingle(division.boutConfig, previous: previousDivision?.boutConfig);
        boutResultRules = boutResultRules.map((rule) => rule.copyWith(boutConfig: boutConfig));
        final prevRules = await BoutResultRuleController().getMany(
            conditions: ['bout_config_id = @id'], substitutionValues: {'id': boutConfig.id}, obfuscate: obfuscate);
        await BoutResultRuleController().updateOnDiffMany(boutResultRules.toList(), previous: prevRules);
        return division.copyWith(boutConfig: boutConfig);
      },
      onDelete: (previous) async {
        await BoutResultRuleController()
            .deleteMany(conditions: ['bout_config_id=@id'], substitutionValues: {'id': previous.boutConfig.id});
        await BoutConfigController().deleteSingle(previous.boutConfig.id!);
      },
    );

    final leagues = (await forEachFuture(divisions, (division) async {
      var leagues = await apiProvider.importLeagues(division: division);
      leagues = await LeagueController().updateOrCreateManyOfOrg(
        leagues.toList(),
        conditions: ['division_id = @id'],
        substitutionValues: {'id': division.id},
        obfuscate: obfuscate,
      );

      final (divisionWeightClasses, leagueWeightClasses) =
          await apiProvider.importDivisionAndLeagueWeightClasses(division: division);

      await DivisionWeightClassController().updateOrCreateManyOfOrg(
        divisionWeightClasses.toList(),
        conditions: ['division_id = @id'],
        substitutionValues: {'id': division.id},
        obfuscate: obfuscate,
        onUpdateOrCreate: (previousWeightClass, current) async {
          final weightClass = await WeightClassController()
              .updateOnDiffSingle(current.weightClass, previous: previousWeightClass?.weightClass);
          return current.copyWith(weightClass: weightClass);
        },
        onDelete: (toBeDeleted) async => await WeightClassController().deleteSingle(toBeDeleted.weightClass.id!),
      );

      final groupedLeagueWeightClasses = leagueWeightClasses.toList().groupListsBy((lwc) => lwc.league);
      await Future.forEach(groupedLeagueWeightClasses.entries, (entry) async {
        final league = entry.key;
        final currentLeagueWeightClasses = entry.value;

        await LeagueWeightClassController().updateOrCreateManyOfOrg(
          currentLeagueWeightClasses,
          conditions: ['league_id = @id'],
          substitutionValues: {'id': league.id},
          obfuscate: obfuscate,
          onUpdateOrCreate: (previousWeightClass, current) async {
            final weightClass = await WeightClassController()
                .updateOnDiffSingle(current.weightClass, previous: previousWeightClass?.weightClass);
            return current.copyWith(weightClass: weightClass);
          },
          onDelete: (toBeDeleted) async => await WeightClassController().deleteSingle(toBeDeleted.weightClass.id!),
        );
      });

      return leagues;
    }))
        .expand((league) => league);

    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      for (final league in leagues) {
        await LeagueController().import(
          entity: league,
          obfuscate: obfuscate,
          includeSubjacent: includeSubjacent,
          apiProvider: apiProvider,
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
    final organization = await getSingle(id, obfuscate: false);
    final apiProvider = await initApiProvider(message: message, organization: organization);
    if (apiProvider == null) {
      throw Exception('No API provider selected for the organization $id.');
    }
    return await apiProvider.search(searchStr: searchStr, searchType: searchType);
  }

  @override
  Organization? getOrganization(Organization entity) {
    return entity;
  }
}
