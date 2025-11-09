import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_config_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/bout_result_rule_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/club_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/import_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/organizational_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/division_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/person_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_club_affiliation_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/weight_class_controller.dart';
import 'package:wrestling_scoreboard_server/services/api.dart';

class OrganizationController extends ShelfController<Organization> with ImportController<Organization> {
  static final OrganizationController _singleton = OrganizationController._internal();

  factory OrganizationController() {
    return _singleton;
  }

  OrganizationController._internal() : super();

  Future<List<Person>> getPersons(bool obfuscate, int id) async {
    return await PersonController().getMany(
      conditions: ['organization_id = @id'],
      substitutionValues: {'id': id},
      obfuscate: obfuscate,
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

    return organization.apiProvider?.getApi(
      organization,
      getSingleOfOrg:
          <T extends Organizational>(orgSyncId, {required int orgId}) =>
              OrganizationalController.getSingleFromDataTypeOfOrg(orgSyncId, orgId: orgId, obfuscate: false),
      getMany:
          <T extends DataObject>({conditions, substitutionValues}) async =>
              await EntityController.getManyFromDataType<T>(
                conditions: conditions,
                substitutionValues: substitutionValues,
                obfuscate: false,
              ),
      authService: authService,
    );
  }

  @override
  Stream<double> import({
    required WrestlingApi apiProvider,
    required Organization entity,
    bool includeSubjacent = false,
  }) async* {
    final totalSteps = 3 + (includeSubjacent ? 1 : 0);
    int step = 0;

    final teamClubAffiliations = await apiProvider.importTeamClubAffiliations();

    await Future.forEach(teamClubAffiliations, (teamClubAffiliation) async {
      // TODO: if a TeamClubAffiliation is removed, it should also be removed here
      final club = await ClubController().updateOrCreateSingleOfOrg(teamClubAffiliation.club);
      final team = await TeamController().updateOrCreateSingleOfOrg(teamClubAffiliation.team);
      teamClubAffiliation = teamClubAffiliation.copyWith(club: club, team: team);

      // Do not add team club affiliations multiple times.
      final previousTeamClubAffiliation = await TeamClubAffiliationController().getByTeamAndClubId(
        teamId: team.id!,
        clubId: club.id!,
        obfuscate: false,
      );
      if (previousTeamClubAffiliation == null) {
        await TeamClubAffiliationController().createSingle(TeamClubAffiliation(team: team, club: club));
      }
    });
    yield (++step) / totalSteps;

    final divisionBoutResultRuleMap = await apiProvider.importDivisions();
    final divisions = await DivisionController().updateOrCreateManyOfOrg(
      divisionBoutResultRuleMap.keys.toList(),
      filterType: Organization,
      filterId: entity.id,
      onUpdateOrCreate: (previousDivision, division) async {
        var boutResultRules = divisionBoutResultRuleMap[division]!;
        final boutConfig = await BoutConfigController().updateOnDiffSingle(
          division.boutConfig,
          previous: previousDivision?.boutConfig,
        );
        boutResultRules = boutResultRules.map((rule) => rule.copyWith(boutConfig: boutConfig));
        await BoutResultRuleController().updateOnDiffMany(
          boutResultRules.toList(),
          filterType: BoutConfig,
          filterId: boutConfig.id,
        );
        return division.copyWith(boutConfig: boutConfig);
      },
      onDeleted: (previous) async {
        await BoutResultRuleController().deleteMany(
          conditions: ['bout_config_id=@id'],
          substitutionValues: {'id': previous.boutConfig.id},
        );
        await BoutConfigController().deleteSingle(previous.boutConfig.id!);
      },
    );
    yield (++step) / totalSteps;

    final leagues = (await forEachFuture(divisions, (division) async {
      var leagues = await apiProvider.importLeagues(division: division);
      leagues = await LeagueController().updateOrCreateManyOfOrg(
        leagues.toList(),
        filterType: Division,
        filterId: division.id,
      );

      final (divisionWeightClasses, leagueWeightClasses) = await apiProvider.importDivisionAndLeagueWeightClasses(
        division: division,
      );

      await DivisionWeightClassController().updateOrCreateManyOfOrg(
        divisionWeightClasses.toList(),
        filterType: Division,
        filterId: division.id,
        onUpdateOrCreate: (previousWeightClass, current) async {
          final weightClass = await WeightClassController().updateOnDiffSingle(
            current.weightClass,
            previous: previousWeightClass?.weightClass,
          );
          return current.copyWith(weightClass: weightClass);
        },
        onDeleted: (toBeDeleted) async => await WeightClassController().deleteSingle(toBeDeleted.weightClass.id!),
      );

      final groupedLeagueWeightClasses = leagueWeightClasses.toList().groupListsBy((lwc) => lwc.league);
      await Future.forEach(groupedLeagueWeightClasses.entries, (entry) async {
        final league = entry.key;
        final currentLeagueWeightClasses = entry.value;

        await LeagueWeightClassController().updateOrCreateManyOfOrg(
          currentLeagueWeightClasses,
          filterType: League,
          filterId: league.id,
          onUpdateOrCreate: (previousWeightClass, current) async {
            final weightClass = await WeightClassController().updateOnDiffSingle(
              current.weightClass,
              previous: previousWeightClass?.weightClass,
            );
            return current.copyWith(weightClass: weightClass);
          },
          onDeleted: (toBeDeleted) async => await WeightClassController().deleteSingle(toBeDeleted.weightClass.id!),
        );
      });

      return leagues;
    })).expand((league) => league);

    yield (++step) / totalSteps;

    updateLastImportUtcDateTime(entity.id!);
    if (includeSubjacent) {
      int subStep = 0;
      for (final league in leagues) {
        final leagueProgress = LeagueController().import(
          entity: league,
          includeSubjacent: includeSubjacent,
          apiProvider: apiProvider,
        );
        await for (final progress in leagueProgress) {
          yield (step + ((subStep + progress) / leagues.length)) / totalSteps;
        }
        yield (step + (++subStep / leagues.length)) / totalSteps;
      }

      yield (++step) / totalSteps;
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
