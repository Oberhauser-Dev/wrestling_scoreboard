import 'dart:io';

import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:logging/logging.dart';
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/base_dir.dart';

/// Environment variable, which overrides the path of the config file.
const configFileEnvVar = 'WRESTLING_SCOREBOARD_SERVER_CONFIG_FILE';

/// Overrides the path of the config file (e.g. via `--config-file`).
/// Must be set before [env] is accessed for the first time.
String? configFileOverride;

/// The default config file.
///
/// On Windows, it is shared by all users of the system, as the installation directory is read-only for MSIX packages.
/// Otherwise, it is the `.env` file in the installation directory.
String get defaultConfigFilePath {
  if (Platform.isWindows) {
    final programData = Platform.environment['ProgramData'] ?? r'C:\ProgramData';
    return '$programData\\WrestlingScoreboard\\Server\\.env';
  }
  return resolvePath('.env');
}

/// The config file, which is written by the `config` command and overrides the values of the bundled `.env` file.
String get configFilePath => configFileOverride ?? Platform.environment[configFileEnvVar] ?? defaultConfigFilePath;

/// The existing config files, from lowest to highest priority.
List<String> get existingConfigFiles =>
    {resolvePath('.env'), configFilePath}.where((path) => File(path).existsSync()).toList();

/// The JWT secret of `.env.example`, which must not be used in production.
const exampleJwtSecret = 'my-ultra-secure-and-ultra-long-secret';

final env = Environment();

class Environment {
  /// The config files, which were loaded, from lowest to highest priority.
  late final List<String> loadedConfigFiles;

  late final Level? logLevel;
  late final String? host;
  late final int? port;
  late final String? issuer;
  late final String? webClientUrl;
  late final String? jwtSecret;
  late final int? jwtExpiresInDays;
  late final String? databaseHost;
  late final int? databasePort;
  late final String? databaseUser;
  late final String? databasePassword;
  late final String? databaseName;
  late final String? databaseSslMode;
  late final String? postgresBinDir;
  late final String? corsAllowOrigin;
  late final int? webSocketPingIntervalSecs;

  late final String? smtpHost;
  late final String? smtpUser;
  late final String? smtpPassword;
  late final int? smtpPort;
  late final String? smtpFrom;

  Environment() {
    // Later files override the values of earlier ones.
    loadedConfigFiles = existingConfigFiles;
    final dotEnv = DotEnv(quiet: true);
    dotEnv.load(loadedConfigFiles); // Load dotenv variables
    logLevel = Level.LEVELS.where((level) => level.name == dotEnv['LOG_LEVEL']?.toUpperCase()).zeroOrOne;
    host = dotEnv['HOST'];
    port = int.tryParse(dotEnv['PORT'] ?? '');
    issuer = dotEnv['ISSUER'];
    jwtSecret = dotEnv['JWT_SECRET'];
    jwtExpiresInDays = int.tryParse(dotEnv['JWT_EXPIRES_IN_DAYS'] ?? '');
    databaseHost = dotEnv['DATABASE_HOST'];
    databasePort = int.tryParse(dotEnv['DATABASE_PORT'] ?? '');
    databaseUser = dotEnv['DATABASE_USER'];
    databasePassword = dotEnv['DATABASE_PASSWORD'];
    databaseName = dotEnv['DATABASE_NAME'];
    databaseSslMode = dotEnv['DATABASE_SSL_MODE'];
    postgresBinDir = dotEnv['POSTGRES_BIN_DIR'];
    corsAllowOrigin = dotEnv['CORS_ALLOW_ORIGIN'];
    webSocketPingIntervalSecs = int.tryParse(dotEnv['WEB_SOCKET_PING_INTERVAL_SECS'] ?? '');
    webClientUrl = dotEnv['WEB_CLIENT_URL'];
    smtpHost = dotEnv['SMTP_HOST'];
    smtpUser = dotEnv['SMTP_USER'];
    smtpPassword = dotEnv['SMTP_PASSWORD'];
    smtpPort = int.tryParse(dotEnv['SMTP_PORT'] ?? '');
    smtpFrom = dotEnv['SMTP_FROM'] ?? smtpUser;
  }
}
