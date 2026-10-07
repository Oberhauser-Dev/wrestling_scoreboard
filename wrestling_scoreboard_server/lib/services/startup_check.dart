import 'dart:io';

import 'package:logging/logging.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

enum StartupCheckSeverity { ok, warning, error }

class StartupCheckResult {
  final String name;
  final StartupCheckSeverity severity;
  final String message;

  const StartupCheckResult(this.name, this.severity, this.message);

  const StartupCheckResult.ok(this.name, this.message) : severity = StartupCheckSeverity.ok;

  const StartupCheckResult.warning(this.name, this.message) : severity = StartupCheckSeverity.warning;

  const StartupCheckResult.error(this.name, this.message) : severity = StartupCheckSeverity.error;
}

final _logger = Logger('StartupCheck');

/// Checks whether the server can be started with the current configuration and logs the results.
///
/// Returns `false`, if any check failed with [StartupCheckSeverity.error].
Future<bool> runStartupChecks() async {
  final results = [
    checkConfigFiles(),
    checkJwtSecret(),
    await checkPostgresExecutable('psql', neededFor: 'migrating and restoring the database'),
    await checkPostgresExecutable('pg_dump', neededFor: 'exporting (backing up) the database'),
    await checkDatabaseConnection(),
    await checkPort(),
  ];
  for (final result in results) {
    final message = '${result.name}: ${result.message}';
    switch (result.severity) {
      case StartupCheckSeverity.ok:
        _logger.info(message);
      case StartupCheckSeverity.warning:
        _logger.warning(message);
      case StartupCheckSeverity.error:
        _logger.severe(message);
    }
  }
  return results.every((result) => result.severity != StartupCheckSeverity.error);
}

StartupCheckResult checkConfigFiles() {
  const name = 'Config';
  if (env.loadedConfigFiles.isEmpty) {
    return StartupCheckResult.error(
      name,
      'No config file found. Create one at "$configFilePath" by running `wrestling-scoreboard-server config` '
      'in a terminal, or see `.env.example` for the available options.',
    );
  }
  return StartupCheckResult.ok(name, 'Loaded ${env.loadedConfigFiles.map((path) => '"$path"').join(', ')}.');
}

StartupCheckResult checkJwtSecret() {
  const name = 'JWT secret';
  final jwtSecret = env.jwtSecret;
  if (jwtSecret == null || jwtSecret.isEmpty) {
    return StartupCheckResult.error(name, '`JWT_SECRET` is not specified.');
  }
  if (jwtSecret == exampleJwtSecret) {
    return StartupCheckResult.warning(name, '`JWT_SECRET` uses the example value, replace it with a random secret.');
  }
  return StartupCheckResult.ok(name, '`JWT_SECRET` is specified.');
}

/// Checks whether a PostgreSQL client executable can be run.
///
/// A missing executable is fatal: `psql` migrates the database on startup, whenever a new server version comes with
/// migration scripts, and `pg_dump` creates the backups, which otherwise would fail unnoticed in the client.
Future<StartupCheckResult> checkPostgresExecutable(String executableName, {required String neededFor}) async {
  final name = 'PostgreSQL client `$executableName`';
  final executable = postgresExecutable(executableName);
  try {
    final result = await Process.run(executable, ['--version']);
    if (result.exitCode != 0) {
      return StartupCheckResult.error(name, '"$executable --version" failed: ${result.stderr}');
    }
    return StartupCheckResult.ok(name, (result.stdout as String).trim());
  } on ProcessException catch (_) {
    return StartupCheckResult.error(
      name,
      '"$executable" not found, which is needed for $neededFor. '
      'Set `POSTGRES_BIN_DIR` to the `bin` directory of your PostgreSQL installation or add it to the `PATH`.',
    );
  }
}

Future<StartupCheckResult> checkDatabaseConnection() async {
  const name = 'Database';
  final db = PostgresDb();
  final target = '"${db.postgresDatabaseName}" as user "${db.dbUser}" at ${db.postgresHost}:${db.postgresPort}';
  try {
    await db.open();
    await db.close();
    return StartupCheckResult.ok(name, 'Connected to $target.');
  } on SocketException catch (e) {
    return StartupCheckResult.error(
      name,
      'Cannot reach PostgreSQL at ${db.postgresHost}:${db.postgresPort}. '
      'Is it installed and running? (${e.message})',
    );
  } catch (e) {
    return StartupCheckResult.error(name, 'Cannot connect to $target. $e');
  }
}

Future<StartupCheckResult> checkPort() async {
  const name = 'Port';
  final host = env.host ?? InternetAddress.anyIPv4;
  final port = env.port ?? 8080;
  final address = '${host is InternetAddress ? host.address : host}:$port';
  try {
    final socket = await ServerSocket.bind(host, port);
    await socket.close();
    return StartupCheckResult.ok(name, '$address is available.');
  } on SocketException catch (e) {
    return StartupCheckResult.error(
      name,
      'Cannot listen on $address. Is another server instance already running? (${e.message})',
    );
  }
}
