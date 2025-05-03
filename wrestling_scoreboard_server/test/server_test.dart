import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_common/src/mocked_data.dart';
import 'package:wrestling_scoreboard_server/controllers/entity_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

void main() {
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);

  test('DB import and export match', () async {
    final db = PostgresDb();
    await db.open();
    final defaultDump = await File(defaultDatabasePath).readAsString();
    await db.restore(defaultDatabasePath);
    final databaseExport = await db.export();
    expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
  });

  test('Start server and load default database', () async {
    final db = PostgresDb();
    await db.open();
    await db.clear();

    final instance = await server.init();
    await instance.close();

    final defaultDump = await File(defaultDatabasePath).readAsString();
    final databaseExport = await db.export();
    expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
  });

  test('Start server and migrate', () async {
    final db = PostgresDb();
    await db.open();
    await db.restore('./database/migration/v0.0.0_Setup-DB.sql');

    final instance = await server.init();
    await instance.close();

    // At this point the database should already be migrated
    final defaultDump = await File(defaultDatabasePath).readAsString();
    final databaseExport = await db.export();
    expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
  });

  Future<String> executeMockedImport(PostgresDb db, Organization org) async {
    final apiProvider = await OrganizationController().initApiProvider(organization: org);
    if (apiProvider == null) {
      throw Exception('ApiProvider for organization $org not found!');
    }
    apiProvider.isMock = true;

    await OrganizationController().import(entity: org, obfuscate: false, apiProvider: apiProvider);

    final league = await LeagueController().getSingleOfOrg('2023_Bayernliga_Süd', orgId: org.id!, obfuscate: false);
    await LeagueController().import(entity: league, obfuscate: false, apiProvider: apiProvider);

    final teamMatch = await TeamMatchController().getSingleOfOrg('005029c', orgId: org.id!, obfuscate: false);
    await TeamMatchController().import(entity: teamMatch, obfuscate: false, apiProvider: apiProvider);

    return await db.export();
  }

  test('Import External API twice', () async {
    final db = PostgresDb();
    await db.open();
    await db.reset();

    final org = await OrganizationController().createSingleReturn(
        Organization(name: 'BaRiVe', abbreviation: 'BRV', apiProvider: WrestlingApiProvider.deByRingenApi));

    final firstImportSql = await executeMockedImport(db, org);
    final secondImportSql = await executeMockedImport(db, org);

    expect(DatabaseExt.sanitizeSql(firstImportSql), DatabaseExt.sanitizeSql(secondImportSql));
  });

  test('Changes in external API import', () async {
    final db = PostgresDb();
    await db.open();
    await db.restore('./test/outdated_api_import.sql');
    await db.migrate();

    final org = (await OrganizationController().getMany(obfuscate: false)).single;
    // This should update the outdated import:
    final updatedImportSql = await executeMockedImport(db, org);

    await db.restore('./test/expected_api_import.sql');
    await db.migrate();
    final expectedSql = await db.export();

    expect(DatabaseExt.sanitizeSql(updatedImportSql), DatabaseExt.sanitizeSql(expectedSql));
  });

  group('API', () {
    Future<Map<String, String>> getAuthHeaders(String apiUrl) async {
      final defaultHeaders = {
        "Content-Type": "application/json",
      };

      Future<String> signIn(BasicAuthService authService) async {
        final uri = Uri.parse('$apiUrl/auth/sign_in');
        final response = await http.post(uri, headers: {
          ...authService.header,
          ...defaultHeaders,
        });
        return response.body;
      }

      final token = await signIn(BasicAuthService(username: 'admin', password: 'admin'));

      return {
        "Content-Type": "application/json",
        ...BearerAuthService(token: token).header,
      };
    }

    test('GET all', () async {
      final db = PostgresDb();
      await db.open();
      await db.clear();

      final instance = await server.init();

      for (final dataType in dataTypes) {
        if (dataType == User) continue;
        if (dataType == SecuredUser) continue;
        final tableName = getTableNameFromType(dataType);
        final url = 'http://${instance.address.address}:${instance.port}/api/${tableName}s';
        final res = await http.get(Uri.parse(url));
        expect(res.statusCode, 200);
      }

      await instance.close();
    });

    test('POST and GET single', () async {
      final db = PostgresDb();
      await db.open();
      await db.reset();

      final instance = await server.init();
      final mockedData = MockedData();

      final apiUrl = 'http://${instance.address.address}:${instance.port}/api';

      DataObject getMockedDataObject(Type type) {
        return switch (type) {
          const (AgeCategory) => mockedData.ageCategoryAJuniors,
          const (Bout) => mockedData.bout1,
          const (BoutAction) => mockedData.boutAction1,
          const (BoutConfig) => mockedData.boutConfig,
          const (BoutResultRule) => mockedData.boutResultRule,
          const (Club) => mockedData.homeClub,
          const (Competition) => mockedData.competition,
          const (CompetitionPerson) => mockedData.competitionPerson,
          const (CompetitionBout) => mockedData.competitionBout1,
          const (CompetitionLineup) => mockedData.competitionLineup1,
          const (CompetitionSystemAffiliation) => mockedData.competitionSystemAffiliationTwoPools,
          const (CompetitionWeightCategory) => mockedData.competitionWeightCategory,
          const (CompetitionParticipation) => mockedData.competitionParticipation1,
          const (Organization) => mockedData.organization,
          const (Division) => mockedData.adultDivision,
          const (DivisionWeightClass) => mockedData.divisionWc57,
          const (League) => mockedData.leagueMenRPW,
          const (LeagueTeamParticipation) => mockedData.htMenRPW,
          const (LeagueWeightClass) => mockedData.leagueWc57,
          const (TeamLineup) => mockedData.menRpwHomeTeamLineup,
          const (Membership) => mockedData.r1,
          const (TeamLineupParticipation) => mockedData.menRpwHomeTeamLineupParticipation,
          const (AthleteBoutState) => mockedData.boutState1R,
          const (Person) => mockedData.p1,
          const (Team) => mockedData.homeTeam,
          const (TeamClubAffiliation) => mockedData.homeTeamAffiliation,
          const (TeamMatch) => mockedData.menRPWMatch,
          const (TeamMatchBout) => mockedData.tmb1,
          const (WeightClass) => mockedData.wc57,
          _ => throw UnimplementedError(),
        };
      }

      final authHeaders = await getAuthHeaders(apiUrl);

      for (final dataType in dataTypes.reversed) {
        if (dataType == User) continue;
        if (dataType == SecuredUser) continue;

        DataObject obj = getMockedDataObject(dataType);
        final body = jsonEncode(singleToJson(obj, dataType, CRUD.create));
        final tableUrl = '$apiUrl/${obj.tableName}';
        final uri = Uri.parse(tableUrl);
        final postRes = await http.post(uri, headers: authHeaders, body: body);
        expect(postRes.statusCode, 200, reason: postRes.body);

        final objectId = jsonDecode(postRes.body);
        obj = obj.copyWithId(objectId);

        final getRes = await http.get(Uri.parse('$tableUrl/$objectId'), headers: authHeaders);
        expect(getRes.statusCode, 200);
        expect(jsonDecode(getRes.body), obj.toJson());
      }

      await instance.close();
    });
  });

  test('Controllers', () async {
    for (final dataType in dataTypes) {
      if (dataType == User) continue;
      final controller = ShelfController.getControllerFromDataType(dataType)!;
      expect(controller.runtimeType.toString(), '${dataType}Controller');
      expect(controller.tableName, getTableNameFromType(dataType));
    }
  });
}
