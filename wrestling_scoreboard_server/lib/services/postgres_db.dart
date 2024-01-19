import 'package:postgres/postgres.dart' as psql;
import 'package:wrestling_scoreboard_server/server.dart';

const _isReleaseMode = bool.fromEnvironment("dart.vm.product");

class PostgresDb {
  final String postgresHost = env['DATABASE_HOST'] ?? 'localhost';
  final int postgresPort = int.parse(env['DATABASE_PORT'] ?? '5432');
  final String dbUser = env['DATABASE_USER'] ?? 'postgres';
  final String dbPW = env['DATABASE_PASSWORD'] ?? '';
  final String postgresDatabaseName = env['DATABASE_NAME'] ?? 'wrestling_scoreboard';

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
