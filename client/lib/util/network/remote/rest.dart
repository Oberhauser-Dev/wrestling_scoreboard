import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard/data/data_object.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/serialize.dart';

import 'web_socket.dart';

final _apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080/api';

class RestDataProvider extends DataProvider {
  RestDataProvider() {
    _initUpdateStream();
  }

  static const rawQueryParameter = {
    'raw': 'true',
  };

  String _getPathFromType(Type t) {
    return '/${getTableNameFromType(getBaseType(t))}';
  }

  Future<T> readSingle<T extends DataObject>(int id) async {
    final json = await readRawSingle<T>(id, isRaw: false);
    return deserialize<T>(json);
  }

  Future<List<T>> readMany<T extends DataObject>({DataObject? filterObject}) async {
    final json = await readRawMany<T>(filterObject: filterObject, isRaw: false);
    return json.map((e) => deserialize<T>(e)).toList();
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
      throw e;
    }
  }

  @override
  Stream<T> readSingleStream<T extends DataObject>(int id) {
    return getOrCreateSingleStreamController<T>().stream;
  }

  @override
  Stream<Iterable<T>> readManyStream<T extends DataObject>({DataObject? filterObject}) {
    final filterType = filterObject == null ? Object : filterObject.getBaseType();
    var stream = getOrCreateManyStreamController<T>(filterType: filterType).stream;
    if (filterObject != null) {
      stream = stream.where((e) {
        if (e is List<Team>) {
          if (filterObject is Club)
            return (e as List<Team>).where((element) => element.club == filterObject).isNotEmpty;
        } else if (e is List<Participation>) {
          if (filterObject is Lineup)
            return (e as List<Participation>).where((element) => element.lineup == filterObject).isNotEmpty;
        }
        throw DataUnimplementedError(CRUD.read, T, filterObject);
      });
    }
    return stream;
  }

  _initUpdateStream() {
    final handleSingle = ({required CRUD operation, required DataObject single}) {
      if (operation == CRUD.update) {
        if (single is Club) return getSingleStreamController<Club>()?.sink.add(single);
        if (single is Fight) return getSingleStreamController<Fight>()?.sink.add(single);
        if (single is League) return getSingleStreamController<League>()?.sink.add(single);
        if (single is Lineup) return getSingleStreamController<Lineup>()?.sink.add(single);
        if (single is Membership) return getSingleStreamController<Membership>()?.sink.add(single);
        if (single is Participation) return getSingleStreamController<Participation>()?.sink.add(single);
        if (single is Team) return getSingleStreamController<Team>()?.sink.add(single);
        if (single is TeamMatch) return getSingleStreamController<TeamMatch>()?.sink.add(single);
        if (single is Tournament) return getSingleStreamController<Tournament>()?.sink.add(single);
        throw DataUnimplementedError(CRUD.read, single.runtimeType);
      }
    };

    final handleMany =
        ({required CRUD operation, required Iterable<DataObject> many, Type filterType = Object, int? filterId}) {
      if (many.isEmpty) return;
      if (many.first is Club) {
        return getManyStreamController<Club>(filterType: filterType)?.sink.add(many as Iterable<Club>);
      }
      if (many.first is Fight) {
        return getManyStreamController<Fight>(filterType: filterType)?.sink.add(many as Iterable<Fight>);
      }
      if (many.first is League) {
        return getManyStreamController<League>(filterType: filterType)?.sink.add(many as Iterable<League>);
      }
      if (many.first is Lineup) {
        return getManyStreamController<Lineup>(filterType: filterType)?.sink.add(many as Iterable<Lineup>);
      }
      if (many.first is Membership) {
        return getManyStreamController<Membership>(filterType: filterType)?.sink.add(many as Iterable<Membership>);
      }
      if (many.first is Participation) {
        return getManyStreamController<Participation>(filterType: filterType)?.sink.add(many as Iterable<Participation>);
      }
      if (many.first is Team) {
        return getManyStreamController<Team>(filterType: filterType)?.sink.add(many as Iterable<Team>);
      }
      if (many.first is TeamMatch) {
        return getManyStreamController<TeamMatch>(filterType: filterType)?.sink.add(many as Iterable<TeamMatch>);
      }
      if (many.first is Tournament) {
        return getManyStreamController<Tournament>()?.sink.add(many as Iterable<Tournament>);
      }
      throw DataUnimplementedError(operation, many.first.runtimeType);
    };

    getSinkStream().listen((message) {
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
    addToSink(jsonEncode(singleToJson(obj, obj.id != null ? CRUD.update : CRUD.create)));
  }

  @override
  Future<void> deleteSingle(DataObject obj) async {
    addToSink(jsonEncode(singleToJson(obj, CRUD.delete)));
  }
}
