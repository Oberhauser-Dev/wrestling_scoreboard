import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/shelf_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/league_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/organization_controller.dart';
import 'package:wrestling_scoreboard_server/controllers/team_match_controller.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

import 'common.dart';

void main() {
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);
  MockableRandom.isMocked = true;

  group('Database', () {
    late PostgresDb db;
    setUp(() async {
      db = PostgresDb();
      await db.open();
    });

    tearDown(() async {
      await db.close();
    });

    test('DB import and export match', () async {
      final defaultDump = await File(prepopulatedDatabasePath).readAsString();
      await db.restore(prepopulatedDatabasePath);
      final databaseExport = await db.export();
      expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
    });

    test('Start server and load the prepopulated database', () async {
      final db = PostgresDb();
      await db.open();
      await db.clear();

      // Server init loads the prepopulated database, if no db exists yet.
      final instance = await server.init();
      await instance.close();

      final prepopulatedDump = await File(prepopulatedDatabasePath).readAsString();
      final databaseExport = await db.export();
      expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(prepopulatedDump));
    });

    test('Start server and migrate definition database', () async {
      final db = PostgresDb();
      await db.open();
      await db.restore('./database/migration/v0.0.0_Setup-DB.sql');

      final instance = await server.init();
      await instance.close();

      // At this point the database should already be migrated
      final defaultDump = await File(definitionDatabasePath).readAsString();
      final databaseExport = await db.export();
      expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
    });

    test('Migrate data to match prepopulated database', () async {
      final db = PostgresDb();
      await db.open();
      await db.restore('./database/migration/v0.0.0_Setup-DB.sql');

      final dataMigratonMap = Map.fromEntries(
        await DatabaseExt.readMigrationScripts(folderPath: './test/res/migration'),
      );
      await db.executeSqlFile('./test/res/migration/v0.0.0_Setup-DB.sql');

      // On each migration step, one can add additional data, which should be present for testing.
      // This data then is also migrated by the following scripts.
      await db.migrate(
        skipPreparation: true,
        onMigrate: (version) async {
          if (dataMigratonMap.containsKey(version)) {
            await db.executeSqlFile(dataMigratonMap[version]!.path);
          }
        },
      );

      // At this point the database should already be migrated
      final expectedDump = await File(prepopulatedDatabasePath).readAsString();
      final databaseExport = await db.export();
      expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(expectedDump));
    });

    Future<String> executeMockedImport(PostgresDb db, Organization org) async {
      final apiProvider = await OrganizationController().initApiProvider(organization: org);
      if (apiProvider == null) {
        throw Exception('ApiProvider for organization $org not found!');
      }
      apiProvider.isMock = true;

      await OrganizationController().import(entity: org, apiProvider: apiProvider);

      final league = await LeagueController().getSingleOfOrg('2023_Bayernliga_Süd', orgId: org.id!, obfuscate: false);
      await LeagueController().import(entity: league, apiProvider: apiProvider);

      final teamMatch = await TeamMatchController().getSingleOfOrg('005029c', orgId: org.id!, obfuscate: false);
      await TeamMatchController().import(entity: teamMatch, apiProvider: apiProvider);

      return await db.export();
    }

    test('Import External API twice', () async {
      final db = PostgresDb();
      await db.open();
      await db.reset();

      final org = await OrganizationController().createSingleReturn(
        Organization(name: 'BaRiVe', abbreviation: 'BRV', apiProvider: WrestlingApiProvider.deByRingenApi),
      );

      final firstImportSql = await executeMockedImport(db, org);
      final secondImportSql = await executeMockedImport(db, org);

      expect(DatabaseExt.sanitizeSql(firstImportSql), DatabaseExt.sanitizeSql(secondImportSql));
    });

    test('Changes in external API import', () async {
      final db = PostgresDb();
      await db.open();
      await db.restore('./test/res/outdated_api_import.sql');
      await db.migrate(/*skipPreparation: true*/); // Skip preparation, if need to squash old migration scripts

      final org = (await OrganizationController().getMany(obfuscate: false)).single;
      // This should update the outdated import:
      final updatedImportSql = await executeMockedImport(db, org);

      await db.restore('./test/res/expected_api_import.sql');
      await db.migrate();
      final expectedSql = await db.export();

      expect(DatabaseExt.sanitizeSql(updatedImportSql), DatabaseExt.sanitizeSql(expectedSql));
    });

    group('API', () {
      test('GET all', () async {
        final db = PostgresDb();
        await db.open();
        await db.clear();

        final instance = await server.init();

        for (final dataType in dataTypes) {
          if (dataType == User) continue;
          if (dataType == SecuredUser) continue;
          if (dataType == ScratchBout) continue;

          final tableName = getTableNameFromType(dataType);
          final url = 'http://${instance.address.address}:${instance.port}/api/${tableName}s';
          final res = await http.get(Uri.parse(url));
          expect(res.statusCode, 200);
        }

        await instance.close();
      });

      test('POST, GET, DELETE single', () async {
        final db = PostgresDb();
        await db.open();
        await db.reset();

        final instance = await server.init();
        final apiUrl = 'http://${instance.address.address}:${instance.port}/api';
        final authHeaders = await getAuthHeaders(apiUrl);

        // CREATE and READ
        for (final dataType in dataTypes.reversed) {
          if (dataType == User) continue;
          if (dataType == SecuredUser) continue;
          if (dataType == ScratchBout) continue;

          final objs = getMockedDataObjects(dataType);
          if (objs.isEmpty) throw 'No mocked datatypes provided for $dataType';
          for (var obj in objs) {
            final body = jsonEncode(singleToJson(obj, dataType, CRUD.create));
            final tableUrl = '$apiUrl/${obj.tableName}';
            final uri = Uri.parse(tableUrl);
            final postRes = await http.post(uri, headers: authHeaders, body: body);
            expect(postRes.statusCode, 200, reason: postRes.body);

            final objectId = jsonDecode(postRes.body);
            expect(obj.id, objectId);

            final getRes = await http.get(Uri.parse('$tableUrl/$objectId'), headers: authHeaders);
            expect(getRes.statusCode, 200);
            expect(jsonDecode(getRes.body), obj.toJson());
          }
        }

        // DELETE
        for (final dataType in dataTypes) {
          if (dataType == User) continue;
          if (dataType == SecuredUser) continue;
          if (dataType == ScratchBout) continue;

          // Following entities should get deleted by its providing entity:
          // e.g. Bout is deleted by TeamMatchBout, or CompetitionBout.
          if (dataType == Bout) continue;

          final objs = getMockedDataObjects(dataType);
          if (objs.isEmpty) throw 'No mocked datatypes provided for $dataType';
          // Need to delete in reversed order, as entities can be their own parent.
          for (var obj in objs.reversed) {
            final body = jsonEncode(singleToJson(obj, dataType, CRUD.delete));
            final tableUrl = '$apiUrl/${obj.tableName}';
            final uri = Uri.parse('$tableUrl/${obj.id}');
            final deleteRes = await http.delete(uri, headers: authHeaders, body: body);
            expect(deleteRes.statusCode, 200, reason: deleteRes.body);

            final wasSuccessful = jsonDecode(deleteRes.body);
            expect(wasSuccessful, true);

            final getRes = await http.get(Uri.parse('$tableUrl/${obj.id}'), headers: authHeaders);
            expect(getRes.statusCode, 400);
          }
        }

        // After deletion, no entities should exist any more.
        final expectedDump = await File(definitionDatabasePath).readAsString();
        final databaseExport = await db.export();
        expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(expectedDump));

        await instance.close();
      });
    });
  });

  test('Controllers', () async {
    for (final dataType in dataTypes) {
      if (dataType == User) continue;
      if (dataType == ScratchBout) continue;

      final controller = ShelfController.getControllerFromDataType(dataType)!;
      expect(controller.runtimeType.toString(), '${dataType}Controller');
      expect(controller.tableName, getTableNameFromType(dataType));
    }
  });
}
