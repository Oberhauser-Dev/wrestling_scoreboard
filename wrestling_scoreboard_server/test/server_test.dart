import 'dart:io';

import 'package:test/test.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

void main() {
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
    final defaultDump = await File(defaultDatabasePath).readAsString();
    final databaseExport = await db.export();
    expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
    await instance.close();
  });

  test('Start server and migrate', () async {
    final db = PostgresDb();
    await db.open();
    await db.restore('./database/migration/v0.0.0_Setup-DB.sql');
    final instance = await server.init();
    // At this point the database should already be migrated
    final defaultDump = await File(defaultDatabasePath).readAsString();
    final databaseExport = await db.export();
    expect(DatabaseExt.sanitizeSql(databaseExport), DatabaseExt.sanitizeSql(defaultDump));
    await instance.close();
  });
}
