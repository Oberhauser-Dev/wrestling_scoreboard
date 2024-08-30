import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/url.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class RestDataManager extends DataManager {
  static const rawQueryParameter = {
    'isRaw': 'true',
  };

  late final Map<String, String> _headers;

  late final String? _apiUrl;

  late WebSocketManager _webSocketManager;

  RestDataManager({required String? apiUrl, super.authService}) {
    _apiUrl = apiUrl == null ? null : adaptLocalhost(apiUrl);
    _headers = {
      "Content-Type": "application/json",
      ...?authService?.header,
    };
  }

  String _getPathFromType(Type t) {
    return '/${getTableNameFromType(t)}';
  }

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    final json = await readSingleJson<T>(id, isRaw: false);
    return DataObject.fromJson<T>(json);
  }

  @override
  Future<List<T>> readMany<T extends DataObject, S extends DataObject?>({S? filterObject}) async {
    final json = await readManyJson<T, S>(filterObject: filterObject, isRaw: false);
    return json.map((e) => DataObject.fromJson<T>(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> readSingleJson<T extends DataObject>(int id, {bool isRaw = true}) async {
    final uri =
        Uri.parse('$_apiUrl${_getPathFromType(T)}/$id').replace(queryParameters: isRaw ? rawQueryParameter : null);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw RestException('Failed to READ single ${T.toString()}', response: response);
    }
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
    final uri =
        Uri.parse('$_apiUrl$prepend${_getPathFromType(T)}s').replace(queryParameters: isRaw ? rawQueryParameter : null);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => e as Map<String, dynamic>).toList(); // TODO check order
    } else {
      throw RestException('Failed to READ many ${T.toString()}', response: response);
    }
  }

  @override
  Future<void> generateBouts<T extends WrestlingEvent>(WrestlingEvent wrestlingEvent, [bool isReset = false]) async {
    final prepend = '${_getPathFromType(T)}/${wrestlingEvent.id}';
    final uri = Uri.parse('$_apiUrl$prepend/bouts/generate')
        .replace(queryParameters: isReset ? const {'isReset': 'true'} : null);
    final response = await http.post(uri, headers: _headers);

    if (response.statusCode >= 400) {
      throw RestException('Failed to CREATE generated bouts ${wrestlingEvent.toString()}', response: response);
    }
  }

  @override

  /// As we need the return value immediately, we need to use the rest API.
  Future<int> createOrUpdateSingle<T extends DataObject>(T obj) async {
    final body = jsonEncode(singleToJson(obj, T, obj.id != null ? CRUD.update : CRUD.create));
    final uri = Uri.parse('$_apiUrl/${obj.tableName}');
    final response = await http.post(uri, headers: _headers, body: body);

    if (response.statusCode < 400) {
      return jsonDecode(response.body);
    } else {
      throw RestException('Failed to ${obj.id != null ? 'UPDATE' : 'CREATE'} single ${obj.tableName}',
          response: response);
    }
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    _webSocketManager.addToSink(jsonEncode(singleToJson(single, T, CRUD.delete)));
  }

  @override
  Future<String> exportDatabase() async {
    final uri = Uri.parse('$_apiUrl/database/export');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw RestException('Failed to export the database', response: response);
    }
  }

  @override
  Future<void> resetDatabase() async {
    final uri = Uri.parse('$_apiUrl/database/reset');
    final response = await http.post(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to reset the database', response: response);
    }
  }

  @override
  Future<void> restoreDefaultDatabase() async {
    final uri = Uri.parse('$_apiUrl/database/restore_default');
    final response = await http.post(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to restore the default database', response: response);
    }
  }

  @override
  Future<void> restoreDatabase(String sqlDump) async {
    final uri = Uri.parse('$_apiUrl/database/restore');
    final response = await http.post(uri, headers: _headers, body: sqlDump);
    if (response.statusCode != 200) {
      throw RestException('Failed to restore the database', response: response);
    }
  }

  @override
  set webSocketManager(WebSocketManager manager) {
    _webSocketManager = manager;
  }

  @override
  Future<void> organizationImport(int id, {AuthService? authService}) async {
    String? body;
    if (authService != null) {
      if (authService is BasicAuthService) {
        body = jsonEncode(singleToJson(authService, BasicAuthService, CRUD.update));
      }
    }
    final uri = Uri.parse('$_apiUrl/organization/$id/api/import');
    final response = await http.post(uri, body: body, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to import from organization $id', response: response);
    }
  }

  @override
  Future<void> organizationLeagueImport(int id, {AuthService? authService}) async {
    String? body;
    if (authService != null) {
      if (authService is BasicAuthService) {
        body = jsonEncode(singleToJson(authService, BasicAuthService, CRUD.update));
      }
    }
    final uri = Uri.parse('$_apiUrl/league/$id/api/import');
    final response = await http.post(uri, body: body, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to import from league $id', response: response);
    }
  }

  @override
  Future<void> organizationCompetitionImport(int id, {AuthService? authService}) async {
    String? body;
    if (authService != null) {
      if (authService is BasicAuthService) {
        body = jsonEncode(singleToJson(authService, BasicAuthService, CRUD.update));
      }
    }
    final uri = Uri.parse('$_apiUrl/competition/$id/api/import');
    final response = await http.post(uri, body: body, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to import from competition $id', response: response);
    }
  }

  @override
  Future<void> organizationTeamImport(int id, {AuthService? authService}) async {
    String? body;
    if (authService != null) {
      if (authService is BasicAuthService) {
        body = jsonEncode(singleToJson(authService, BasicAuthService, CRUD.update));
      }
    }
    final uri = Uri.parse('$_apiUrl/team/$id/api/import');
    final response = await http.post(uri, body: body, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to import from team $id', response: response);
    }
  }

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
    final uri = Uri.parse('$_apiUrl/search').replace(queryParameters: {
      if (searchTerm.isNotEmpty) 'like': searchTerm,
      if (type != null) 'type': getTableNameFromType(type),
      if (organizationId != null) 'org': organizationId.toString(),
      if (includeApiProviderResults) 'use_provider': includeApiProviderResults.toString(),
    });
    final response =
        body == null ? await http.get(uri, headers: _headers) : await http.post(uri, body: body, headers: _headers);
    if (response.statusCode != 200) {
      throw RestException('Failed to search $type with term "$searchTerm"', response: response);
    }

    final json = jsonDecode(response.body);
    if (json is! List) {
      throw RestException('Search $type with term "$searchTerm" should return a list', response: response);
    }

    final Map<String, List<DataObject>> result = {};

    Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
      throw RestException('There should not be returned single data on a search', response: response);
    }

    Future<int> handleSingleRaw<T extends DataObject>(
        {required CRUD operation, required Map<String, dynamic> single}) async {
      throw RestException('There should not be returned single raw data on a search', response: response);
    }

    Future<void> handleManyRaw<T extends DataObject>(
        {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many}) async {
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

    if (response.statusCode < 400) {
      return jsonDecode(response.body);
    } else {
      throw RestException('Failed to ${user.id != null ? 'UPDATE' : 'CREATE'} single ${user.tableName}',
          response: response);
    }
  }

  @override
  Future<String> signIn(BasicAuthService authService) async {
    final uri = Uri.parse('$_apiUrl/auth/sign_in');
    final response = await http.post(uri, headers: {
      ...authService.header,
      ..._headers,
    });

    if (response.statusCode < 400) {
      return response.body;
    } else {
      throw RestException('Failed to sign in with username ${authService.username}', response: response);
    }
  }

  @override
  Future<User?> getUser() async {
    if (authService == null) return null;
    final uri = Uri.parse('$_apiUrl/auth/user');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode < 400) {
      return DataObject.fromJson<User>(jsonDecode(response.body));
    } else {
      throw RestException('Failed to sign in with token ${authService?.header}', response: response);
    }
  }

  @override
  Future<void> updateUser(User user) async {
    final uri = Uri.parse('$_apiUrl/auth/user');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode < 400) {
      return;
    } else {
      throw RestException('Failed to change password', response: response);
    }
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
