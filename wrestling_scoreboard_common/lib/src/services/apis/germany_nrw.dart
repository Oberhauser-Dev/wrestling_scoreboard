import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../common.dart';

class NrwGermanyWrestlingApi extends WrestlingApi {
  final String apiUrl;
  final _mockPath = './lib/src/services/apis/mocks';

  bool isMock = false;

  @override
  final Organization organization;

  @override
  GetSingleOfProvider getSingle;

  NrwGermanyWrestlingApi(
    this.organization, {
    required this.getSingle,
    this.apiUrl = 'https://www.brv-ringen.de/Api/v1/cs/',
  });

  @override
  Future<Iterable<Division>> importDivisions({DateTime? minDate, DateTime? maxDate}) async {
    final json = await _getLeagueList();
    final year = int.parse(json['year']);
    final Map<String, dynamic> divisionList = json['ligaList'];
    return await Future.wait(divisionList.entries.map(
      (entry) async => Division(
        organization: organization,
        name: entry.key,
        startDate: DateTime(year),
        endDate: DateTime(year + 1),
        boutConfig: BoutConfig(),
        // TODO: get from "boutSchemeId" inside league list
        seasonPartitions: 2,
      ),
    ));
  }

  @override
  Future<Iterable<Club>> importClubs() async {
    final divisions = await importDivisions();
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final clubs = (await Future.wait(leagues.map((league) async {
      final json = await _getCompetitionList(
        ligaId: league.division.name,
        regionId: league.name,
        seasonId: league.startDate.year.toString(),
      );

      final Map<String, dynamic> competitionList = json['competitionList'];
      final listHome = await Future.wait(competitionList.entries.map((entry) async {
        final Map<String, dynamic> values = entry.value;
        return Club(name: values['homeTeamName'], organization: organization);
      }));

      final listGuest = await Future.wait(competitionList.entries.map((entry) async {
        final Map<String, dynamic> values = entry.value;
        return Club(name: values['opponentTeamName'], organization: organization);
      }));

      listHome.addAll(listGuest);
      return listHome;
    })))
        .expand((element) => element);
    return clubs.toSet();
  }

  @override
  Future<Iterable<Team>> importTeams({required Club club}) async {
    final divisions = await importDivisions();
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final teams = (await Future.wait(leagues.map((league) async {
      final json = await _getCompetitionList(
        ligaId: league.division.name,
        regionId: league.name,
        seasonId: league.startDate.year.toString(),
      );

      final Map<String, dynamic> competitionList = json['competitionList'];
      final listHome = await Future.wait(competitionList.entries.map((entry) async {
        final Map<String, dynamic> values = entry.value;
        return Team(name: values['homeTeamName'], club: await getSingle<Club>(values['homeTeamName']));
      }));

      final listGuest = await Future.wait(competitionList.entries.map((entry) async {
        final Map<String, dynamic> values = entry.value;
        return Team(name: values['opponentTeamName'], club: await getSingle<Club>(values['opponentTeamName']));
      }));

      listHome.addAll(listGuest);
      return listHome;
    })))
        .expand((element) => element);
    return teams.toSet().where((element) => element.club == club);
  }

  @override
  Future<Iterable<League>> importLeagues({required Division division}) async {
    final json = await _getLeagueList(seasonId: division.startDate.year.toString());

    final Map<String, dynamic> leagueList = json['ligaList'][division.name];
    return await Future.wait(
      leagueList.entries.map(
        (entry) async => League(
          name: entry.key,
          startDate: division.startDate,
          endDate: division.endDate,
          division: division,
        ),
      ),
    );
  }

  @override
  Future<Iterable<TeamMatch>> importTeamMatches({required League league}) async {
    final json = await _getCompetitionList(
      ligaId: league.division.name,
      regionId: league.name,
      seasonId: league.startDate.year.toString(),
    );

    final Map<String, dynamic> competitionList = json['competitionList'];
    return await Future.wait(competitionList.entries.map((entry) async {
      final Map<String, dynamic> values = entry.value;
      return TeamMatch(
        home: Lineup(
          team: await getSingle<Team>(values['homeTeamName']),
        ),
        guest: Lineup(
          team: await getSingle<Team>(values['opponentTeamName']),
        ),
        date: DateTime.parse(values['boutDate'] + ' ' + values['scaleTime']),
        visitorsCount: int.tryParse(values['audience']),
        location: values['location'],
        referee: Person(
            prename: values['refereeGivenname'].toString().trim(), surname: values['refereeName'].toString().trim()),
        comment: values['editorComment'],
        league: league,
        no: entry.key,
        seasonPartition: double.parse(values['boutday']) / 16 < 0.5 ? 1 : 2, // TODO, also check the max days
      );
    }));
  }

  /// Get all seasons
  Future<Iterable<String>> _getSeasonList() async {
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'listSaison',
    });

    String body;
    if (!isMock) {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Failed to get the saison list: ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = await File('$_mockPath/listSaison.json').readAsString();
    }
    final Map<String, dynamic> json = jsonDecode(body);
    final Map<String, dynamic> competitionList = json['ligaList'];
    return await Future.wait(competitionList.entries.map((entry) async => entry.value.toString()));
  }

  /// Get leagues of a season
  Future<Map<String, dynamic>> _getLeagueList({
    String? seasonId,
  }) async {
    seasonId ??= DateTime.now().year.toString();
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'listLiga',
      'sid': seasonId,
    });
    String body;
    if (!isMock) {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the liga list (seasonId: $seasonId): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = await File('$_mockPath/listLiga.json').readAsString();
    }
    return jsonDecode(body);
  }

  /// Get team matches of a league
  Future<Map<String, dynamic>> _getCompetitionList({
    required String seasonId,
    required String ligaId,
    required String regionId,
  }) async {
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'listCompetition',
      'sid': seasonId,
      'ligaId': ligaId,
      'rid': regionId,
    });

    String body;
    if (!isMock) {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the competition list (seasonId: $seasonId, ligaId: $ligaId, rid: $regionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = await File('$_mockPath/listCompetition.json').readAsString();
    }
    return jsonDecode(body);
  }

// https://www.brv-ringen.de/Api/v1/cs/?op=getCompetition&sid=2019&cid=001006a

// https://www.brv-ringen.de/Api/v1/cs/?op=getSaisonWrestler&passcode=4440
}
