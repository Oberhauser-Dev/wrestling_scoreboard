import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:logging/logging.dart';
import 'package:wrestling_scoreboard_common/common.dart';

final env = Environment();

class Environment {
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
  late final String? corsAllowOrigin;
  late final int? webSocketPingIntervalSecs;

  late final String? smtpHost;
  late final String? smtpUser;
  late final String? smtpPassword;
  late final int? smtpPort;
  late final String? smtpFrom;

  Environment() {
    final dotEnv = DotEnv();
    dotEnv.load(); // Load dotenv variables
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
