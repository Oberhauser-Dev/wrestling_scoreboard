import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/fight.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/membership.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/serialize.dart';

final _apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080/api';

class RestDataProvider extends DataProvider {

  static const rawQueryParameter = {
    'raw': 'true',
  };

  String _getPathFromClass(Type t) {
    switch (t) {
      case ClientClub:
        return '/club';
      case ClientFight:
        return '/fight';
      case ClientLeague:
        return '/league';
      case ClientLineup:
        return '/lineup';
      case ClientMembership:
        return '/membership';
      case Participation:
        return '/participation';
      case ClientTeam:
        return '/team';
      case ClientTeamMatch:
        return '/team_match';
      default:
        throw UnimplementedError('Path for "${t.toString()}" not found.');
    }
  }

  Future<T> readSingle<T extends DataObject>(int id) async {
    final json = await readRawSingle(id, isRaw: false);
    return deserialize<T>(json);
  }

  Future<List<T>> readMany<T extends DataObject>({DataObject? filterObject}) async {
    final json = await readRawMany(filterObject: filterObject, isRaw: false);
    return json.map((e) => deserialize<T>(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> readRawSingle<T extends DataObject>(int id, {bool isRaw = true}) async {
    final uri = Uri.parse('$_apiUrl${_getPathFromClass(T)}/$id');
    if(isRaw) uri.queryParameters.addAll(rawQueryParameter);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to READ single ${T.toString()}: ' + (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  @override
  Future<Iterable<Map<String, dynamic>>> readRawMany<T extends DataObject>({DataObject? filterObject, bool isRaw = true}) async {
    try {
      var prepend = '';
      if (filterObject != null) {
        prepend = '${_getPathFromClass(filterObject.runtimeType)}/${filterObject.id}';
      }
      final uri = Uri.parse('$_apiUrl$prepend${_getPathFromClass(T)}s');
      if(isRaw) uri.queryParameters.addAll(rawQueryParameter);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to READ many ${T.toString()}: ' + (response.reasonPhrase ?? response.statusCode.toString()));
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Stream<T> readSingleStream<T extends DataObject>(int id) {
    // TODO: implement readSingleStream
    throw UnimplementedError();
  }

  @override
  Stream<List<T>> readManyStream<T extends DataObject>({DataObject? filterObject}) {
    // TODO: implement readManyStream
    throw UnimplementedError();
  }

  @override
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]) async {
    final prepend = '${_getPathFromClass(wrestlingEvent.runtimeType)}/${wrestlingEvent.id}';
    final response = await http.post(Uri.parse('$_apiUrl$prepend/fights/generate'), body: {'reset': reset.toString()});

    if (response.statusCode != 200) {
      throw Exception('Failed to CREATE generated fights ${wrestlingEvent.toString()}: ' +
          (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  @override
  Future<int> createOrUpdateSingle(DataObject obj) async {
    throw DataUnimplementedError(CRUD.create, obj.runtimeType);
  }

  @override
  Future<void> deleteSingle(DataObject obj) {
    throw DataUnimplementedError(CRUD.create, obj.runtimeType);
  }
}
