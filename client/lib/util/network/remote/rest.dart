import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:http/http.dart' as http;
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
    return '/${getTableNameFromType(t)}';
  }

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    final json = await readSingleJson<T>(id, isRaw: false);
    return DataObject.fromJson<T>(json);
  }

  @override
  Future<List<T>> readMany<T extends DataObject>({DataObject? filterObject}) async {
    final json = await readManyJson<T>(filterObject: filterObject, isRaw: false);
    return json.map((e) => DataObject.fromJson<T>(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> readSingleJson<T extends DataObject>(int id, {bool isRaw = true}) async {
    final uri = Uri.parse('$_apiUrl${_getPathFromType(T)}/$id');
    if (isRaw) uri.queryParameters.addAll(rawQueryParameter);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to READ single ${T.toString()}: ' + (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readManyJson<T extends DataObject>(
      {DataObject? filterObject, bool isRaw = true}) async {
    var prepend = '';
    if (filterObject != null) {
      prepend = '${_getPathFromType(filterObject.runtimeType)}/${filterObject.id}';
    }
    final uri = Uri.parse('$_apiUrl$prepend${_getPathFromType(T)}s');
    if (isRaw) uri.queryParameters.addAll(rawQueryParameter);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => e as Map<String, dynamic>).toList(); // TODO check order
    } else {
      throw Exception(
          'Failed to READ many ${T.toString()}: ' + (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  _initUpdateStream() {
    Future<int> handleSingle<U extends DataObject>({required CRUD operation, required U single}) async {
      callback<T extends DataObject>(T single) {
        if (operation == CRUD.update) {
          getSingleStreamController<T>()?.sink.add(single);
        }
      }

      if (U == Club) {
        callback<Club>(single as Club);
      } else if (U == Fight) {
        callback<Fight>(single as Fight);
      } else if (U == FightAction) {
        callback<FightAction>(single as FightAction);
      } else if (U == League) {
        callback<League>(single as League);
      } else if (U == Lineup) {
        callback<Lineup>(single as Lineup);
      } else if (U == Membership) {
        callback<Membership>(single as Membership);
      } else if (U == Participation) {
        callback<Participation>(single as Participation);
      } else if (U == Team) {
        callback<Team>(single as Team);
      } else if (U == TeamMatch) {
        callback<TeamMatch>(single as TeamMatch);
      }
      return single.id!;
    }

    Future<void> handleMany<U extends DataObject>({required CRUD operation, required ManyDataObject<U> many}) async {
      callback<T extends DataObject>(ManyDataObject<T> many) {
        final tmp = ManyDataObject<T>(
            data: many.data,
            filterId: many.filterId,
            filterType: many.filterType);
        final filterType = many.filterType;
        if (tmp.data.isEmpty) return;
        getManyStreamController<T>(filterType: filterType)?.sink.add(tmp);
      }

      if (U == Club) {
        callback<Club>(many as ManyDataObject<Club>);
      } else if (U == Fight) {
        callback<Fight>(many as ManyDataObject<Fight>);
      } else if (U == FightAction) {
        callback<FightAction>(many as ManyDataObject<FightAction>);
      } else if (U == League) {
        callback<League>(many as ManyDataObject<League>);
      } else if (U == Lineup) {
        callback<Lineup>(many as ManyDataObject<Lineup>);
      } else if (U == Membership) {
        callback<Membership>(many as ManyDataObject<Membership>);
      } else if (U == Participation) {
        callback<Participation>(many as ManyDataObject<Participation>);
      } else if (U == Team) {
        callback<Team>(many as ManyDataObject<Team>);
      } else if (U == TeamMatch) {
        callback<TeamMatch>(many as ManyDataObject<TeamMatch>);
      }
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
  /// As we need the return value immediately, we need to use the rest API.
  Future<int> createOrUpdateSingle(DataObject obj) async {
    final body = jsonEncode(singleToJson(obj, obj.getBaseType(), obj.id != null ? CRUD.update : CRUD.create));
    final uri = Uri.parse('$_apiUrl/${obj.tableName}');
    final response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to ${obj.id != null ? 'UPDATE' : 'CREATE'} single ${obj.tableName}: ' +
          (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  @override
  Future<void> deleteSingle(DataObject obj) async {
    _webSocketManager.addToSink(jsonEncode(singleToJson(obj, obj.getBaseType(), CRUD.delete)));
  }
}
