import 'package:postgres/postgres.dart' as psql;

import 'environment.dart';

const _isReleaseMode = bool.fromEnvironment("dart.vm.product");

class PostgresDb {
  final String postgresHost = env.databaseHost ?? 'localhost';
  final int postgresPort = env.databasePort ?? 5432;
  final String dbUser = env.databaseUser ?? 'postgres';
  final String dbPW = env.databasePassword ?? '';
  final String postgresDatabaseName = env.databaseName ?? 'wrestling_scoreboard';

  static final PostgresDb _singleton = PostgresDb._internal();
  late psql.Connection connection;

  factory PostgresDb() {
    return _singleton;
  }

  PostgresDb._internal();

  /// Only call this once!
  Future<void> open() async {
    connection = await psql.Connection.open(
        psql.Endpoint(
          host: postgresHost,
          port: postgresPort,
          database: postgresDatabaseName,
          username: dbUser,
          password: dbPW,
        ),
        settings: psql.ConnectionSettings(
          sslMode: _isReleaseMode ? psql.SslMode.require : psql.SslMode.disable,
        ));
  }

  Future<void> close() async {
    await connection.close();
  }
}
