import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:pub_semver/pub_semver.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

const _isReleaseMode = bool.fromEnvironment('dart.vm.product');
const definitionDatabasePath = './database/dump/wrestling_scoreboard-definition-dump.sql';
const prepopulatedDatabasePath = './database/dump/wrestling_scoreboard-prepopulated-dump.sql';

class PostgresDb {
  final log = Logger('PostgresDb');
  final String postgresHost = env.databaseHost ?? 'localhost';
  final int postgresPort = env.databasePort ?? 5432;
  final String dbUser = env.databaseUser ?? 'postgres';
  final String dbPW = env.databasePassword ?? '';
  final String postgresDatabaseName = env.databaseName ?? 'wrestling_scoreboard';

  static final PostgresDb _singleton = PostgresDb._internal();

  psql.Connection? _connection;

  psql.Connection get connection =>
      _connection != null
          ? _connection!
          : throw Exception('Database connection has not yet been initialized. Plz call `open()` first.');

  factory PostgresDb() {
    return _singleton;
  }

  PostgresDb._internal();

  Future<void> open() async {
    _connection ??= await psql.Connection.open(
      psql.Endpoint(
        host: postgresHost,
        port: postgresPort,
        database: postgresDatabaseName,
        username: dbUser,
        password: dbPW,
      ),
      settings: psql.ConnectionSettings(
        sslMode: _isReleaseMode ? psql.SslMode.require : psql.SslMode.disable,
        // Increase connection timeout while debugging
        connectTimeout: Duration(seconds: _isReleaseMode ? 15 : 180),
        timeZone: 'UTC',
      ),
    );
  }

  Future<void> close() async {
    await connection.close();
    _connection = null;
  }
}

extension DatabaseExt on PostgresDb {
  /*Future<void> createIfNotExists([String dumpPath = defaultDatabasePath]) async {
    await open(usePostgresDb: true);
    final res = await connection.execute("SELECT 1 FROM pg_database WHERE datname='$postgresDatabaseName';");
    if (res.isEmpty) {
      await connection.execute("CREATE DATABASE $postgresDatabaseName;");
      await close();
      await open(usePostgresDb: false);
      await restore(dumpPath);
    }
    await close();
  }*/

  Future<Migration> getMigration() async {
    final res = await connection.execute('SELECT * FROM ${Migration.cTableName} LIMIT 1;');
    final row = res.single;
    return await Migration.fromRaw(row.toColumnMap());
  }

  Future<void> migrate({bool skipPreparation = false, Future<void> Function(Version version)? onMigrate}) async {
    String semver;
    try {
      final migration = await getMigration();
      semver = migration.semver;
    } catch (_) {
      // DB has not yet been initialized
      await restorePrepopulated();
      return;
    }
    final databaseVersion = Version.parse(semver);

    final migrationMap = await readMigrationScripts(folderPath: 'database/migration');
    int migrationStartIndex = 0;
    while (migrationStartIndex < migrationMap.length) {
      if (databaseVersion.compareTo(migrationMap[migrationStartIndex].key) < 0) {
        break;
      }
      migrationStartIndex++;
    }
    final migrationRange = migrationMap.sublist(migrationStartIndex, migrationMap.length);
    if (migrationRange.isNotEmpty) {
      for (var migration in migrationRange) {
        await executeSqlFile(migration.value.path);
        log.info('Migrated DB to ${migration.key}');
        await onMigrate?.call(migration.key);
      }
      await connection.execute("UPDATE migration SET semver = '${migrationRange.last.key.toString()}';");
    }
    if (!skipPreparation) await _prepare();
  }

  static Future<List<MapEntry<Version, FileSystemEntity>>> readMigrationScripts({required String folderPath}) async {
    final dir = Directory(folderPath);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final migrationMap =
        entities.map((entity) {
          final migrationVersion = entity.uri.pathSegments.last.split('_')[0];
          return MapEntry(Version.parse(migrationVersion.replaceFirst('v', '')), entity);
        }).toList();
    migrationMap.sort((a, b) => a.key.compareTo(b.key));
    return migrationMap;
  }

  Future<void> clear() async {
    await connection.execute('DROP SCHEMA IF EXISTS public CASCADE;');
  }

  Future<void> restorePrepopulated() async {
    await restore(prepopulatedDatabasePath);
    await _prepare();
  }

  Future<void> reset() async {
    await restore(definitionDatabasePath);
    await _prepare();
  }

  Future<void> restore(String dumpPath) async {
    await clear();
    await executeSqlFile(dumpPath);
  }

  Future<void> restoreFromString(String sqlString) async {
    final File file = File(
      '${Directory.systemTemp.path}/${sqlString.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0')}.sql',
    );
    await file.writeAsString(sqlString);
    await restore(file.path);
  }

  Future<void> executeSqlFile(String sqlFilePath) async {
    await close();

    final args = <String>[
      '--set',
      'ON_ERROR_STOP=1',
      '--file',
      sqlFilePath,
      '--username',
      dbUser,
      '--host',
      postgresHost,
      '--port',
      postgresPort.toString(),
      postgresDatabaseName,
    ];
    final processResult = await Process.run(
      'psql',
      args,
      environment: {'PGPASSWORD': dbPW},
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    if (processResult.exitCode != 0) {
      throw processResult.stderr;
    }

    await open();
  }

  /// Prepare should only be called after migration or on an up-to-date database,
  /// as DataObjects may not in sync with the tables.
  Future<void> _prepare() async {
    await EntityController.initAll();
  }

  Future<String> export() async {
    final args = <String>[
      // '--file',
      // './database/dump/${DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll(RegExp(r'\.[0-9]{3}'), '')}-'
      //     'wrestling_scoreboard-definition-dump.sql',
      '--username',
      dbUser,
      '--host',
      postgresHost,
      '--port',
      postgresPort.toString(),
      '--dbname',
      postgresDatabaseName,
      '--schema',
      'public',
    ];
    final process = await Process.run(
      'pg_dump',
      args,
      environment: {'PGPASSWORD': dbPW},
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    if (process.exitCode == 0) {
      return process.stdout;
    } else {
      throw Exception(process.stderr);
    }
  }

  static String sanitizeSql(String sqlString) {
    sqlString = sqlString.replaceAll('\r\n', '\n');
    // Compatibility to PostgreSQL Fix:
    // https://www.postgresql.org/about/news/postgresql-176-1610-1514-1419-1322-and-18-beta-3-released-3118/
    sqlString = sqlString.replaceAll(RegExp(r'\nCOPY public.api_metadata.*?\\\.\n', dotAll: true), '');
    sqlString = sqlString.replaceAll(RegExp(r'\n\\restrict.*\n'), '');
    sqlString = sqlString.replaceAll(RegExp(r'\n\\unrestrict.*\n'), '');
    return sqlString
        .split('\n')
        .where((line) {
          return !(line.startsWith('-- Dumped') || line.startsWith('SET transaction_timeout'));
        })
        .join('\n');
  }
}
