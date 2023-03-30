import 'package:postgres/postgres.dart';
import 'package:wrestling_scoreboard_server/server.dart';

class PostgresDb {
  final String postgresHost = env['DATABASE_HOST'] ?? 'localhost';
  final int postgresPort = int.parse(env['DATABASE_PORT'] ?? '5432');
  final String dbUser = env['DATABASE_USER'] ?? 'postgres';
  final String dbPW = env['DATABASE_PASSWORD'] ?? '';
  final String postgresDatabaseName = env['DATABASE_NAME'] ?? 'wrestling_scoreboard';

  static final PostgresDb _singleton = PostgresDb._internal();
  late final PostgreSQLConnection connection;

  factory PostgresDb() {
    return _singleton;
  }

  PostgresDb._internal() {
    connection =
        PostgreSQLConnection(postgresHost, postgresPort, postgresDatabaseName, username: dbUser, password: dbPW);
  }
}
