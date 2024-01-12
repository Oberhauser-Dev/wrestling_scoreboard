import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';
import 'package:wrestling_scoreboard_client/util/network/data_provider.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/url.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class RestDataProvider extends DataProvider {
  static const rawQueryParameter = {
    'isRaw': 'true',
  };
  static const headers = {"Content-Type": "application/json"};

  String _apiUrl = Env.apiUrl.fromString();
  late final WebSocketManager _webSocketManager;

  RestDataProvider() {
    Preferences.getString(Preferences.keyApiUrl).then((value) {
      _apiUrl = adaptLocalhost((value ?? Env.apiUrl.fromString()));
      _initUpdateStream();
    });
    Preferences.onChangeApiUrl.stream.listen((event) {
      _apiUrl = adaptLocalhost(event);
    });
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
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to READ single ${T.toString()}: ${response.reasonPhrase ?? response.statusCode.toString()}');
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
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => e as Map<String, dynamic>).toList(); // TODO check order
    } else {
      throw Exception(
          'Failed to READ many ${T.toString()}: ${response.reasonPhrase ?? response.statusCode.toString()}');
    }
  }

  _initUpdateStream() {
    Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
      if (operation == CRUD.update) {
        getSingleStreamController<T>()?.sink.add(single);
      }
      return single.id!;
    }

    Future<int> handleSingleRaw<T extends DataObject>(
        {required CRUD operation, required Map<String, dynamic> single}) async {
      if (operation == CRUD.update) {
        getSingleRawStreamController<T>()?.sink.add(single);
      }
      return single['id'];
    }

    Future<void> handleMany<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) async {
      final tmp = ManyDataObject<T>(data: many.data, filterId: many.filterId, filterType: many.filterType);
      final filterType = many.filterType;
      if (tmp.data.isEmpty) return;
      getManyStreamController<T>(filterType: filterType)?.sink.add(tmp);
    }

    Future<void> handleManyRaw<T extends DataObject>(
        {required CRUD operation, required ManyDataObject<Map<String, dynamic>> many}) async {
      final tmp =
          ManyDataObject<Map<String, dynamic>>(data: many.data, filterId: many.filterId, filterType: many.filterType);
      final filterType = many.filterType;
      if (tmp.data.isEmpty) return;
      getManyRawStreamController<T>(filterType: filterType)?.sink.add(tmp);
    }

    _webSocketManager = WebSocketManager((message) {
      final json = jsonDecode(message);
      handleFromJson(json,
          handleSingle: handleSingle,
          handleMany: handleMany,
          handleSingleRaw: handleSingleRaw,
          handleManyRaw: handleManyRaw);
    });
  }

  @override
  Future<void> generateBouts<T extends WrestlingEvent>(WrestlingEvent wrestlingEvent, [bool isReset = false]) async {
    final prepend = '${_getPathFromType(T)}/${wrestlingEvent.id}';
    final uri = Uri.parse('$_apiUrl$prepend/bouts/generate')
        .replace(queryParameters: isReset ? const {'isReset': 'true'} : null);
    final response = await http.post(uri, headers: headers);

    if (response.statusCode >= 400) {
      throw Exception(
          'Failed to CREATE generated bouts ${wrestlingEvent.toString()}: \n${response.reasonPhrase ?? response.statusCode.toString()}\nBody: ${response.body}');
    }
  }

  @override

  /// As we need the return value immediately, we need to use the rest API.
  Future<int> createOrUpdateSingle<T extends DataObject>(T obj) async {
    final body = jsonEncode(singleToJson(obj, T, obj.id != null ? CRUD.update : CRUD.create));
    final uri = Uri.parse('$_apiUrl/${obj.tableName}');
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode < 400) {
      return jsonDecode(response.body);
    } else {
      throw RestException(
          'Failed to ${obj.id != null ? 'UPDATE' : 'CREATE'} single ${obj.tableName}: \n${response.reasonPhrase ?? response.statusCode.toString()}\nBody: ${response.body}');
    }
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    _webSocketManager.addToSink(jsonEncode(singleToJson(single, T, CRUD.delete)));
  }
}

class RestException implements Exception {
  String message;

  RestException(this.message);
}
