import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart' as psql;
import 'package:pub_semver/pub_semver.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/controllers/common/entity_controller.dart';
import 'package:wrestling_scoreboard_server/services/base_dir.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';

const _isReleaseMode = bool.fromEnvironment('dart.vm.product');

String get definitionDatabasePath => resolvePath('database/dump/wrestling_scoreboard-definition-dump.sql');

String get prepopulatedDatabasePath => resolvePath('database/dump/wrestling_scoreboard-prepopulated-dump.sql');

/// Resolves a PostgreSQL client executable (e.g. `psql`) in `POSTGRES_BIN_DIR`, or falls back to the `PATH`.
String postgresExecutable(String name) {
  final binDir = env.postgresBinDir;
  if (binDir == null || binDir.isEmpty) return name;
  return '$binDir${Platform.pathSeparator}$name${Platform.isWindows ? '.exe' : ''}';
}

class PostgresDb {
  final log = Logger('PostgresDb');
  final String postgresHost = env.databaseHost ?? 'localhost';
  final int postgresPort = env.databasePort ?? 5432;
  final String dbUser = env.databaseUser ?? 'postgres';
  final String dbPW = env.databasePassword ?? '';
  final String postgresDatabaseName = env.databaseName ?? 'wrestling_scoreboard';
  final psql.SslMode postgresDatabaseSslMode = switch (env.databaseSslMode?.toUpperCase()) {
    'DISABLE' => psql.SslMode.disable,
    'VERIFY_FULL' => psql.SslMode.verifyFull,
    'REQUIRE' => psql.SslMode.require,
    _ => psql.SslMode.require,
  };

  static final PostgresDb _singleton = PostgresDb._internal();

  psql.Connection? _connection;

  psql.Connection get connection => _connection != null
      ? _connection!
      : throw Exception('Database connection has not yet been initialized. Plz call `open()` first.');

  factory PostgresDb() {
    return _singleton;
  }

  PostgresDb._internal();

  Future<void> open() async {
    if (_connection != null) return;
    final connection = await psql.Connection.open(
      psql.Endpoint(
        host: postgresHost,
        port: postgresPort,
        database: postgresDatabaseName,
        username: dbUser,
        password: dbPW,
      ),
      settings: psql.ConnectionSettings(
        sslMode: postgresDatabaseSslMode,
        // Increase connection timeout while debugging
        connectTimeout: Duration(seconds: _isReleaseMode ? 15 : 180),
        timeZone: 'UTC',
      ),
    );
    if (_connection != null) {
      // Another caller opened a connection concurrently.
      await connection.close();
      return;
    }
    _connection = connection;
    unawaited(connection.closed.catchError((_) {}).then((_) => _onConnectionClosed(connection)));
  }

  Future<void> close() async {
    final connection = _connection;
    // Unset before closing, so the close is not treated as a connection loss.
    _connection = null;
    await connection?.close();
  }

  /// Reconnects, if the connection was closed unexpectedly, e.g. by a database restart or network failure.
  Future<void> _onConnectionClosed(psql.Connection connection) async {
    // Closed intentionally via [close] or already replaced.
    if (_connection != connection) return;
    _connection = null;
    log.warning('Database connection was closed unexpectedly. Reconnecting...');

    var delay = const Duration(seconds: 1);
    while (_connection == null) {
      try {
        await open();
        log.info('Reconnected to database.');
      } catch (e, st) {
        log.severe('Reconnecting to database failed. Retrying in ${delay.inSeconds}s.', e, st);
        await Future.delayed(delay);
        // Retry at least once a day.
        if (delay < const Duration(days: 1)) delay *= 2;
      }
    }

    try {
      await _prepare();
    } catch (e, st) {
      // Schema may not be ready yet (e.g. during migration); the regular prepare will follow.
      log.warning('Re-preparing statements after reconnect failed.', e, st);
    }
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

  Future<void> migrate({bool prepare = true, Future<void> Function(Version version)? onMigrate}) async {
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

    final migrationMap = await readMigrationScripts(folderPath: resolvePath('database/migration'));
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
    if (prepare) await _prepare();
  }

  static Future<List<MapEntry<Version, FileSystemEntity>>> readMigrationScripts({required String folderPath}) async {
    final dir = Directory(folderPath);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final migrationMap = entities.map((entity) {
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
  }

  Future<void> reset() async {
    await restore(definitionDatabasePath);
  }

  Future<void> restore(String dumpPath, {bool prepare = true}) async {
    await clear();
    await executeSqlFile(dumpPath);
    if (prepare) await _prepare();
  }

  Future<void> restoreFromString(String sqlString, {bool prepare = true}) async {
    final File file = File(
      '${Directory.systemTemp.path}/${sqlString.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0')}.sql',
    );
    await file.writeAsString(sqlString);
    await restore(file.path, prepare: prepare);
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
      postgresExecutable('psql'),
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
      postgresExecutable('pg_dump'),
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
    // PostgreSQL 18 dumps non-default names of NOT NULL constraints, e.g. of renamed tables or columns.
    sqlString = sqlString.replaceAll(RegExp(r'CONSTRAINT \w+_not_null NOT NULL'), 'NOT NULL');
    return sqlString
        .split('\n')
        .where((line) {
          return !(line.startsWith('-- Dumped') || line.startsWith('SET transaction_timeout'));
        })
        .join('\n');
  }
}
