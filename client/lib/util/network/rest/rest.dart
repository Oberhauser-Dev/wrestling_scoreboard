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
import 'package:wrestling_scoreboard/util/serialize.dart';

final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080/api';

String _getPathFromClass<T>() {
  switch (T) {
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
      throw UnimplementedError('Path for "${T.toString()}" not found');
  }
}

Future<T> fetchSingle<T>(int id, {String prepend = ''}) async {
  final response = await http.get(Uri.parse('$apiUrl$prepend${_getPathFromClass<T>()}/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return deserialize<T>(json);
  } else {
    throw Exception('Failed to load single ${T.toString()}');
  }
}

Future<List<T>> fetchMany<T>({String prepend = ''}) async {
  try {
    final response = await http.get(Uri.parse('$apiUrl$prepend${_getPathFromClass<T>()}s'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map((e) => deserialize<T>(e)).toList();
    } else {
      throw Exception('Failed to load many ${T.toString()}');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}
