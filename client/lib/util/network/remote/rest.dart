import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard/data/data_object.dart';
import 'package:wrestling_scoreboard/ui/settings/settings.dart';
import 'package:wrestling_scoreboard/util/environment.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/network/remote/url.dart';

import 'web_socket.dart';


class RestDataProvider extends DataProvider {
  static const rawQueryParameter = {
    'raw': 'true',
  };

  var _apiUrl = adaptLocalhost(
      Settings.getValue<String>(CustomSettingsScreen.keyApiUrl, env(apiUrl, fallBack: 'http://localhost:8080/api'))!);
  late final WebSocketManager _webSocketManager;

  RestDataProvider() {
    CustomSettingsScreen.onChangeApiUrl.stream.listen((event) {
      _apiUrl = adaptLocalhost(event);
    });
    _initUpdateStream();
  }

  String _getPathFromType(Type t) {
    return '/${getTableNameFromType(getBaseType(t))}';
  }

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    final json = await readRawSingle<T>(id, isRaw: false);
    return toClientObject(getBaseType(T).fromJson(json)) as T;
  }

  @override
  Future<List<T>> readMany<T extends DataObject>({DataObject? filterObject}) async {
    final json = await readRawMany<T>(filterObject: filterObject, isRaw: false);
    return json.map((e) => (toClientObject(getBaseType(T).fromJson(e)) as T)).toList();
  }

  @override
  Future<Map<String, dynamic>> readRawSingle<T extends DataObject>(int id, {bool isRaw = true}) async {
    final uri = Uri.parse('$_apiUrl${_getPathFromType(T)}/$id');
    if (isRaw) uri.queryParameters.addAll(rawQueryParameter);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to READ single ${getBaseType(T).toString()}: ' +
          (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  @override
  Future<Iterable<Map<String, dynamic>>> readRawMany<T extends DataObject>(
      {DataObject? filterObject, bool isRaw = true}) async {
    try {
      var prepend = '';
      if (filterObject != null) {
        prepend = '${_getPathFromType(filterObject.runtimeType)}/${filterObject.id}';
      }
      final uri = Uri.parse('$_apiUrl$prepend${_getPathFromType(T)}s');
      if (isRaw) uri.queryParameters.addAll(rawQueryParameter);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List json = jsonDecode(response.body);
        return json.map((e) => e as Map<String, dynamic>);
      } else {
        throw Exception('Failed to READ many ${getBaseType(T).toString()}: ' +
            (response.reasonPhrase ?? response.statusCode.toString()));
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Stream<T> streamSingle<T extends DataObject>(Type t, int id) {
    return getOrCreateSingleStreamController<T>(t).stream;
  }

  _initUpdateStream() {
    void handleSingle<T extends DataObject>({required CRUD operation, required T single}) {
      final tmp = toClientObject<T>(single);
      if (operation == CRUD.update) {
        getSingleStreamController<T>(single.runtimeType)?.sink.add(tmp);
      }
    }

    void handleMany<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) {
      final tmp = ManyDataObject<T>(
          data: many.data.map((e) => toClientObject<T>(e)), filterId: many.filterId, filterType: many.filterType);
      final filterType = many.filterType;
      if (tmp.data.isEmpty) return;
      getManyStreamController<T>(many.data.first.runtimeType, filterType: filterType)?.sink.add(tmp);
    }

    _webSocketManager = WebSocketManager((message) {
      final json = jsonDecode(message);
      handleFromJson(json, handleSingle, handleMany);
    });
  }

  @override
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]) async {
    final prepend = '${_getPathFromType(wrestlingEvent.runtimeType)}/${wrestlingEvent.id}';
    final response = await http.post(Uri.parse('$_apiUrl$prepend/fights/generate'), body: {'reset': reset.toString()});

    if (response.statusCode != 200) {
      throw Exception('Failed to CREATE generated fights ${wrestlingEvent.toString()}: ' +
          (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  @override
  Future<void> createOrUpdateSingle(DataObject obj) async {
    _webSocketManager.addToSink(jsonEncode(singleToJson(obj, obj.id != null ? CRUD.update : CRUD.create)));
  }

  @override
  Future<void> deleteSingle(DataObject obj) async {
    _webSocketManager.addToSink(jsonEncode(singleToJson(obj, CRUD.delete)));
  }
}
