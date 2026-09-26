import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_common/common.dart';
import 'package:wrestling_scoreboard_server/services/postgres_db.dart';

Future<Map<String, String>> getAuthHeaders(String apiUrl) async {
  final defaultHeaders = {'Content-Type': 'application/json'};

  Future<String> signIn(BasicAuthService authService) async {
    final uri = Uri.parse('$apiUrl/auth/sign_in');
    final response = await http.post(uri, headers: {...authService.header, ...defaultHeaders});
    return response.body;
  }

  final token = await signIn(BasicAuthService(username: 'admin', password: 'admin'));

  return {'Content-Type': 'application/json', ...BearerAuthService(token: token).header};
}

/// Mocked data is inserted with explicit ids, which doesn't advance the id sequences.
/// Sync them, so new entities can be created without an id afterwards.
Future<void> syncIdSequences(PostgresDb db, Iterable<Type> dataTypes) async {
  for (final dataType in dataTypes) {
    final tableName = getTableNameFromType(dataType);
    await db.connection.execute(
      "SELECT setval(pg_get_serial_sequence('public.$tableName', 'id'), "
      'COALESCE((SELECT MAX(id) FROM public.$tableName), 0) + 1, false);',
    );
  }
}
