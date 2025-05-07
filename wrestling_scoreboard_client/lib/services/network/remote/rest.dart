import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/url.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class RestDataManager extends DataManager {
  static const rawQueryParameter = {'isRaw': 'true'};

  late final Map<String, String> _headers;

  late final String? _apiUrl;

  late WebSocketManager _webSocketManager;

  final Future<void> Function() onResetAuth;

  RestDataManager({required String? apiUrl, super.authService, required this.onResetAuth}) {
    _apiUrl = apiUrl == null ? null : adaptLocalhost(apiUrl);
    _headers = {"Content-Type": "application/json", ...?authService?.header};
  }

  String _getPathFromType(Type t) {
    return '/${getTableNameFromType(t)}';
  }

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    final json = await readSingleJson<T>(id, isRaw: false);
    return DataObjectParser.fromJson<T>(json);
  }

  @override
  Future<List<T>> readMany<T extends DataObject, S extends DataObject?>({S? filterObject}) async {
    final json = await readManyJson<T, S>(filterObject: filterObject, isRaw: false);
    return json.map((e) => DataObjectParser.fromJson<T>(e)).toList();
  }

  Future<void> _handleResponse(http.Response response, {required String errorMessage}) async {
    if (response.statusCode >= 400) {
      if (response.statusCode == 401) {
        await onResetAuth();
      }
      throw RestException(errorMessage, response: response);
    }
  }

  @override
  Future<Map<String, dynamic>> readSingleJson<T extends DataObject>(int id, {bool isRaw = true}) async {
    final uri = Uri.parse(
      '$_apiUrl${_getPathFromType(T)}/$id',
    ).replace(queryParameters: isRaw ? rawQueryParameter : null);
    final response = await http.get(uri, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to READ single ${T.toString()}');
    return jsonDecode(response.body);
  }

  @override
  Future<List<Map<String, dynamic>>> readManyJson<T extends DataObject, S extends DataObject?>({
    S? filterObject,
    bool isRaw = true,
  }) async {
    var prepend = '';
    if (filterObject != null) {
      prepend = '${_getPathFromType(S)}/${filterObject.id}';
    }
    final uri = Uri.parse(
      '$_apiUrl$prepend${_getPathFromType(T)}s',
    ).replace(queryParameters: isRaw ? rawQueryParameter : null);
    final response = await http.get(uri, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to READ many ${T.toString()}');

    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => e as Map<String, dynamic>).toList(); // TODO check order
  }

  @override
  Future<void> generateBouts<T extends DataObject>(T dataObject, [bool isReset = false]) async {
    final prepend = '${_getPathFromType(T)}/${dataObject.id}';
    final uri = Uri.parse(
      '$_apiUrl$prepend/bouts/generate',
    ).replace(queryParameters: isReset ? const {'isReset': 'true'} : null);
    final response = await http.post(uri, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to CREATE generated bouts for $T (${dataObject.toString()})');
  }

  @override
  /// As we need the return value immediately, we need to use the rest API.
  Future<int> createOrUpdateSingle<T extends DataObject>(T obj) async {
    final body = jsonEncode(singleToJson(obj, T, obj.id != null ? CRUD.update : CRUD.create));
    final uri = Uri.parse('$_apiUrl/${obj.tableName}');
    final response = await http.post(uri, headers: _headers, body: body);

    await _handleResponse(
      response,
      errorMessage: 'Failed to ${obj.id != null ? 'UPDATE' : 'CREATE'} single ${obj.tableName}',
    );
    return jsonDecode(response.body);
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    _webSocketManager.addToSink(jsonEncode(singleToJson(single, T, CRUD.delete)));
  }

  @override
  Future<void> mergeObjects<T extends DataObject>(List<T> objects) async {
    final body = jsonEncode(manyToJson(objects, T, CRUD.update, isRaw: false));
    final uri = Uri.parse('$_apiUrl/${getTableNameFromType(T)}s/merge');
    final response = await http.post(uri, headers: _headers, body: body);
    await _handleResponse(response, errorMessage: 'Failed to merge objects ${getTableNameFromType(T)}');
    return jsonDecode(response.body);
  }

  @override
  Future<Migration> getMigration() async {
    final uri = Uri.parse('$_apiUrl/database/${Migration.cTableName}');
    final response = await http.get(uri, headers: _headers);

    await _handleResponse(response, errorMessage: 'Failed to get the migration versions');
    return Migration.fromJson(jsonDecode(response.body));
  }

  @override
  Future<String> exportDatabase() async {
    final uri = Uri.parse('$_apiUrl/database/export');
    final response = await http.get(uri, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to export the database');
    return response.body;
  }

  @override
  Future<void> resetDatabase() async {
    final uri = Uri.parse('$_apiUrl/database/reset');
    final response = await http.post(uri, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to reset the database');
  }

  @override
  Future<void> restoreDefaultDatabase() async {
    final uri = Uri.parse('$_apiUrl/database/restore_default');
    final response = await http.post(uri, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to restore the default database');
  }

  @override
  Future<void> restoreDatabase(String sqlDump) async {
    final uri = Uri.parse('$_apiUrl/database/restore');
    final response = await http.post(uri, headers: _headers, body: sqlDump);
    await _handleResponse(response, errorMessage: 'Failed to restore the database');
  }

  @override
  set webSocketManager(WebSocketManager manager) {
    _webSocketManager = manager;
  }

  Future<void> _import(int id, String table, {bool includeSubjacent = false, AuthService? authService}) async {
    String? body;
    if (authService != null) {
      if (authService is BasicAuthService) {
        body = jsonEncode(singleToJson(authService, BasicAuthService, CRUD.update));
      }
    }
    final uri = Uri.parse(
      '$_apiUrl/$table/$id/api/import',
    ).replace(queryParameters: {'subjacent': includeSubjacent.toString()});
    final response = await http.post(uri, body: body, headers: _headers);
    await _handleResponse(response, errorMessage: 'Failed to import from $table $id');
  }

  @override
  Future<void> organizationImport(int id, {bool includeSubjacent = false, AuthService? authService}) =>
      _import(id, 'organization', includeSubjacent: includeSubjacent, authService: authService);

  @override
  Future<void> organizationLeagueImport(int id, {bool includeSubjacent = false, AuthService? authService}) =>
      _import(id, 'league', includeSubjacent: includeSubjacent, authService: authService);

  @override
  Future<void> organizationTeamMatchImport(int id, {bool includeSubjacent = false, AuthService? authService}) =>
      _import(id, 'team_match', includeSubjacent: includeSubjacent, authService: authService);

  @override
  Future<void> organizationCompetitionImport(int id, {bool includeSubjacent = false, AuthService? authService}) =>
      _import(id, 'competition', includeSubjacent: includeSubjacent, authService: authService);

  @override
  Future<void> organizationTeamImport(int id, {bool includeSubjacent = false, AuthService? authService}) =>
      _import(id, 'team', includeSubjacent: includeSubjacent, authService: authService);

  Future<DateTime?> _lastImportUtcDateTime(int id, String table) async {
    final uri = Uri.parse('$_apiUrl/$table/$id/api/last_import');
    final response = await http.get(uri, headers: _headers);

    await _handleResponse(response, errorMessage: 'Failed to get the last import date time for $table $id');
    return DateTime.tryParse(response.body);
  }

  @override
  Future<DateTime?> organizationLastImportUtcDateTime(int id) => _lastImportUtcDateTime(id, 'organization');

  @override
  Future<DateTime?> organizationLeagueLastImportUtcDateTime(int id) => _lastImportUtcDateTime(id, 'league');

  @override
  Future<DateTime?> organizationTeamMatchLastImportUtcDateTime(int id) => _lastImportUtcDateTime(id, 'team_match');

  @override
  Future<DateTime?> organizationCompetitionLastImportUtcDateTime(int id) => _lastImportUtcDateTime(id, 'competition');

  @override
  Future<DateTime?> organizationTeamLastImportUtcDateTime(int id) => _lastImportUtcDateTime(id, 'team');

  @override
  Future<Map<String, List<DataObject>>> search({
    required String searchTerm,
    Type? type,
    int? organizationId,
    AuthService? authService,
    bool includeApiProviderResults = false,
  }) async {
    // Auth is only needed for sensitive searches
    String? body;
    if (authService != null) {
      if (authService is BasicAuthService) {
        body = jsonEncode(singleToJson(authService, BasicAuthService, CRUD.read));
      }
    }
    final uri = Uri.parse('$_apiUrl/search').replace(
      queryParameters: {
        if (searchTerm.isNotEmpty) 'like': searchTerm,
        if (type != null) 'type': getTableNameFromType(type),
        if (organizationId != null) 'org': organizationId.toString(),
        if (includeApiProviderResults) 'use_provider': includeApiProviderResults.toString(),
      },
    );
    final response =
        body == null ? await http.get(uri, headers: _headers) : await http.post(uri, body: body, headers: _headers);

    await _handleResponse(response, errorMessage: 'Failed to search $type with term "$searchTerm"');

    final json = jsonDecode(response.body);
    if (json is! List) {
      throw RestException('Search $type with term "$searchTerm" should return a list', response: response);
    }

    final Map<String, List<DataObject>> result = {};

    Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
      throw RestException('There should not be returned single data on a search', response: response);
    }

    Future<int> handleSingleRaw<T extends DataObject>({
      required CRUD operation,
      required Map<String, dynamic> single,
    }) async {
      throw RestException('There should not be returned single raw data on a search', response: response);
    }

    Future<void> handleManyRaw<T extends DataObject>({
      required CRUD operation,
      required ManyDataObject<Map<String, dynamic>> many,
    }) async {
      throw RestException('There should not be returned many raw data on a search', response: response);
    }

    for (final jsonType in json) {
      await handleGenericJson(
        jsonType,
        handleSingle: handleSingle,
        handleMany: <T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) async {
          result[getTableNameFromType(T)] = many.data;
        },
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw,
      );
    }
    return result;
  }

  @override
  Future<void> signUp(User user) async {
    final body = jsonEncode(singleToJson(user, User, user.id != null ? CRUD.update : CRUD.create));
    final uri = Uri.parse('$_apiUrl/auth/sign_up');
    final response = await http.post(uri, headers: _headers, body: body);
    await _handleResponse(
      response,
      errorMessage: 'Failed to ${user.id != null ? 'UPDATE' : 'CREATE'} single ${user.tableName}',
    );
    return jsonDecode(response.body);
  }

  @override
  Future<String> signIn(BasicAuthService authService) async {
    final uri = Uri.parse('$_apiUrl/auth/sign_in');
    final response = await http.post(uri, headers: {...authService.header, ..._headers});

    await _handleResponse(response, errorMessage: 'Failed to sign in with username ${authService.username}');
    return response.body;
  }

  @override
  Future<User?> getUser() async {
    if (authService == null) return null;
    final uri = Uri.parse('$_apiUrl/auth/user');
    final response = await http.get(uri, headers: _headers);

    await _handleResponse(response, errorMessage: 'Failed to sign in with token ${authService?.header}');
    return DataObjectParser.fromJson<User>(jsonDecode(response.body));
  }

  @override
  Future<void> updateUser(User user) async {
    final uri = Uri.parse('$_apiUrl/auth/user');
    final response = await http.post(uri, headers: _headers, body: jsonEncode(user.toJson()));

    await _handleResponse(response, errorMessage: 'Failed to change password');
  }
}

class RestException implements Exception {
  String message;
  http.Response response;

  RestException(this.message, {required this.response});

  @override
  String toString() {
    return 'RestException: $message:\n'
        '\tReason: ${response.reasonPhrase} (${response.statusCode.toString()}):\n'
        '\tBody: ${response.body}';
  }
}
