import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common.dart';

extension NrwGermanyLeague on League {
  static Future<League> fromJson(Map<String, dynamic> e, GetSingleOfTypeCallback getSingle) async {
    final boutConfig = await getSingle<BoutConfig>(e['boutSchemeId'] as int);
    return League(
      id: e['id'] as int?,
      name: e['name'] as String,
      startDate: e['start_date'] as DateTime,
      seasonPartitions: e['season_partitions'] as int,
      boutConfig: boutConfig,
    );
  }
}

class NrwGermanyWrestlingApi extends WrestlingApi {
  final _apiUrl = 'https://www.brv-ringen.de/Api/v1/cs/';

  @override
  Future<List<League>> importLeagues({int? season}) async {
    return await _getLeagueList(seasonId: season?.toString());
  }

  static Future<T> getSingleFromDataType<T extends DataObject>(int id) {
    // return getControllerFromDataType(T).getSingle(id) as Future<T>;
    throw UnimplementedError();
  }

  /// Get all seasons
  Future<List<String>> _getSeasonList() async {
    final uri = Uri.parse(_apiUrl).replace(queryParameters: {
      'op': 'listSaison',
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic> competitionList = json['ligaList'];
      return await Future.wait(competitionList.entries.map((entry) async => entry.value.toString()));
    } else {
      throw Exception('Failed to get the saison list: ${response.reasonPhrase ?? response.statusCode.toString()}');
    }
  }

  /// Get leagues of a season
  Future<List<League>> _getLeagueList({
    String? seasonId,
  }) async {
    seasonId ??= DateTime.now().year.toString();
    final uri = Uri.parse(_apiUrl).replace(queryParameters: {
      'op': 'listLiga',
      'sid': seasonId,
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic> ligaList = json['ligaList'];
      return await Future.wait(
          ligaList.entries.map((entry) => NrwGermanyLeague.fromJson(entry.value, getSingleFromDataType)));
    } else {
      throw Exception(
          'Failed to get the liga list (seasonId: $seasonId): ${response.reasonPhrase ?? response.statusCode.toString()}');
    }
  }

  /// Get team matches of a league
  Future<List<League>> _getCompetitionList({
    String? seasonId,
    String ligaId = 'Gruppenliga',
    String regionId = 'Süd',
  }) async {
    seasonId ??= DateTime.now().year.toString();
    final uri = Uri.parse(_apiUrl).replace(queryParameters: {
      'op': 'listCompetition',
      'sid': seasonId,
      'ligaId': ligaId,
      'rid': regionId,
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic> competitionList = json['competitionList'];
      return await Future.wait(
          competitionList.entries.map((entry) => NrwGermanyLeague.fromJson(entry.value, getSingleFromDataType)));
    } else {
      throw Exception(
          'Failed to get the competition list (seasonId: $seasonId, ligaId: $ligaId, rid: $regionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
    }
  }
}
