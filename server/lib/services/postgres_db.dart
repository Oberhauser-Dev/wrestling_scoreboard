import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

class PostgresDb {
  final String postgresHost = Platform.environment['DATABASE_HOST'] ?? env['DATABASE_HOST'] ?? 'localhost';
  final int postgresPort = int.parse(Platform.environment['DATABASE_PORT'] ?? env['DATABASE_PORT'] ?? '5432');
  final String dbUser = Platform.environment['DATABASE_USER'] ?? env['DATABASE_USER'] ?? 'postgres';
  final String dbPW = Platform.environment['DATABASE_PASSWORD'] ?? env['DATABASE_PASSWORD'] ?? '';
  final String postgresDatabaseName =
      Platform.environment['DATABASE_NAME'] ?? env['DATABASE_NAME'] ?? 'wrestling_scoreboard';

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
