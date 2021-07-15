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
        throw UnimplementedError('Path for "${t.toString()}" not found');
    }
  }

  Future<T> fetchSingle<T extends DataObject>(int id, {DataObject? filterObject}) async {
    var prepend = '';
    if (filterObject != null) {
      prepend = '${_getPathFromClass(filterObject.runtimeType)}/${filterObject.id}';
    }
    final response = await http.get(Uri.parse('$_apiUrl$prepend${_getPathFromClass(T)}/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return deserialize<T>(json);
    } else {
      throw Exception(
          'Failed to load single ${T.toString()}: ' + (response.reasonPhrase ?? response.statusCode.toString()));
    }
  }

  Future<List<T>> fetchMany<T extends DataObject>({DataObject? filterObject}) async {
    try {
      var prepend = '';
      if (filterObject != null) {
        prepend = '${_getPathFromClass(filterObject.runtimeType)}/${filterObject.id}';
      }
      final response = await http.get(Uri.parse('$_apiUrl$prepend${_getPathFromClass(T)}s'));

      if (response.statusCode == 200) {
        List json = jsonDecode(response.body);
        return json.map((e) => deserialize<T>(e)).toList();
      } else {
        throw Exception(
            'Failed to load many ${T.toString()}: ' + (response.reasonPhrase ?? response.statusCode.toString()));
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
