import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:logging/logging.dart';
import 'package:wrestling_scoreboard_common/common.dart';

final env = Environment();

class Environment {
  late final Level? logLevel;
  late final String? host;
  late final int? port;
  late final String? jwtSecret;
  late final int? jwtExpiresInDays;
  late final String? jwtIssuer;
  late final String? databaseHost;
  late final int? databasePort;
  late final String? databaseUser;
  late final String? databasePassword;
  late final String? databaseName;
  late final String? corsAllowOrigin;
  late final int? webSocketPingIntervalSecs;

  Environment() {
    final dotEnv = DotEnv();
    dotEnv.load(); // Load dotenv variables
    logLevel = Level.LEVELS.where((level) => level.name == dotEnv['LOG_LEVEL']?.toUpperCase()).zeroOrOne;
    host = dotEnv['HOST'];
    port = int.tryParse(dotEnv['PORT'] ?? '');
    jwtSecret = dotEnv['JWT_SECRET'];
    jwtExpiresInDays = int.tryParse(dotEnv['JWT_EXPIRES_IN_DAYS'] ?? '');
    jwtIssuer = dotEnv['JWT_ISSUER'];
    databaseHost = dotEnv['DATABASE_HOST'];
    databasePort = int.tryParse(dotEnv['DATABASE_PORT'] ?? '');
    databaseUser = dotEnv['DATABASE_USER'];
    databasePassword = dotEnv['DATABASE_PASSWORD'];
    databaseName = dotEnv['DATABASE_NAME'];
    corsAllowOrigin = dotEnv['CORS_ALLOW_ORIGIN'];
    webSocketPingIntervalSecs = int.tryParse(dotEnv['WEB_SOCKET_PING_INTERVAL_SECS'] ?? '');
  }
}
