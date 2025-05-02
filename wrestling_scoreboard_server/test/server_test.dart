import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';
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
    test('GET', () async {
      final db = PostgresDb();
      await db.open();
      await db.clear();

      final instance = await server.init();

      for (final dataType in dataTypes) {
        if (dataType == User) continue;
        if (dataType == SecuredUser) continue;
        final tableName = getTableNameFromType(dataType);
        final url = 'http://${instance.address.address}:${instance.port}/api/${tableName}s';
        print('Test url: $url');
        final res = await http.get(Uri.parse(url));
        expect(res.statusCode, 200);
      }

      await instance.close();
    });
  });

  test('Controllers', () async {
    for (final dataType in dataTypes) {
      if (dataType == User) continue;
      expect(ShelfController.getControllerFromDataType(dataType)?.runtimeType.toString(), '${dataType}Controller');
    }
  });
}
