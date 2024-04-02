import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:country/country.dart';
import 'package:http/http.dart' as http;

import '../../../common.dart';
import 'mocks/competition.json.dart';
import 'mocks/listCompetition.json.dart';
import 'mocks/listLiga.json.dart';
import 'mocks/listSaison.json.dart';
import 'mocks/wrestler.json.dart';

class NrwGermanyWrestlingApi extends WrestlingApi {
  final String apiUrl;

  @override
  final BasicAuthService? authService;

  bool isMock = false;

  @override
  final Organization organization;

  @override
  GetSingleOfOrg getSingleOfOrg;

  late Future<T> Function<T extends DataObject>(String orgSyncId) _getSingleBySyncId;

  NrwGermanyWrestlingApi(
    this.organization, {
    required this.getSingleOfOrg,
    this.apiUrl = 'https://www.brv-ringen.de/Api/v1/cs/',
    this.authService,
  }) {
    _getSingleBySyncId =
        <T extends DataObject>(String orgSyncId) => getSingleOfOrg<T>(orgSyncId, orgId: organization.id!);
  }

  @override
  Future<Iterable<Division>> importDivisions({DateTime? minDate, DateTime? maxDate}) async {
    maxDate ??= MockableDateTime.now();
    minDate ??= DateTime.utc(maxDate.year - 1);
    final years = List<int>.generate(maxDate.year - minDate.year + 1, (index) => minDate!.year + index);
    final divisions = await Future.wait(years.map((year) async {
      final json = await _getLeagueList(seasonId: year.toString());
      if (json.isEmpty) return <Division>{};
      if (year != int.tryParse(json['year'])) throw "Years don't match: $year & ${json['year']}";
      final divisionList = json['ligaList'];
      Iterable<Division> divisions;
      if (divisionList is Map<String, dynamic>) {
        divisions = await Future.wait(divisionList.entries.map(
          (entry) async => Division(
            organization: organization,
            name: entry.key,
            startDate: DateTime.utc(year),
            endDate: DateTime.utc(year + 1),
            boutConfig: BoutConfig(),
            // TODO: get from "boutSchemeId" inside league list
            seasonPartitions: 2,
            orgSyncId: '${year}_${entry.key}',
          ),
        ));
      } else {
        divisions = <Division>[];
      }
      return divisions;
    }));
    return divisions.expand((element) => element);
  }

  @override
  Future<Iterable<DivisionWeightClass>> importDivisionWeightClasses({required Division division}) async {
    final leagues = await importLeagues(division: division);
    final competitions = await importTeamMatches(league: leagues.first);
    final json = await _getCompetition(
        seasonId: division.startDate.year.toString(), competitionId: competitions.first.orgSyncId!);
    if (json.isEmpty) return <DivisionWeightClass>{};
    final List<dynamic> boutList = json['competition']['_boutList'];
    final weightClassCount = boutList.length;
    final weightClassesPartitition1 = boutList.asMap().entries.map((e) {
      final Map<String, dynamic> item = e.value;
      final String weightClassStr = item['weightClass'];
      final intInStr = RegExp(r'^\d+');
      final weightStr = intInStr.firstMatch(weightClassStr)!.group(0)!;
      final suffix = weightClassStr.replaceFirst(weightStr, '').trim();
      return DivisionWeightClass(
        // Alter order of weightclasses
        pos: e.key < (weightClassCount / 2) ? e.key * 2 : (weightClassCount - e.key - 1) * 2 + 1,
        seasonPartition: 0,
        division: division,
        weightClass: WeightClass(
          style: item['style'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
          weight: int.parse(weightStr),
          suffix: suffix.isEmpty ? null : suffix,
          unit: WeightUnit.kilogram,
        ),
      );
    });
    final weightClassesPartition2 = weightClassesPartitition1.map((e) => e.copyWith(
        seasonPartition: 1,
        weightClass: e.weightClass.copyWith(
          style: e.weightClass.style == WrestlingStyle.greco ? WrestlingStyle.free : WrestlingStyle.greco,
        )));
    return [...weightClassesPartitition1, ...weightClassesPartition2];
  }

  @override
  Future<Iterable<Club>> importClubs() async {
    final divisions = await importDivisions(minDate: DateTime.utc(MockableDateTime.now().year - 1));
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final clubs = (await Future.wait(leagues.map((league) async {
      final json = await _getCompetitionList(
        ligaId: league.division.name,
        regionId: league.name,
        seasonId: league.startDate.year.toString(),
      );
      if (json.isEmpty) return <Club>{};

      final competitionList = json['competitionList'];
      final Iterable<Club> clubs;
      if (competitionList is Map<String, dynamic>) {
        Future<List<Club>> getClubOfCompetition(String key) async {
          return (await Future.wait(competitionList.entries.map((entry) async {
            final Map<String, dynamic> values = entry.value;
            String? clubName = values[key];
            if (clubName == null) return null;
            if (clubName != clubName.trim()) {
              clubName = clubName.trim();
              print('Club with club name "$clubName" was trimmed');
            }
            return Club(
              name: clubName,
              // TODO: read 'no' from endpoint, when available
              no: null,
              orgSyncId: clubName,
              organization: organization,
            );
          })))
              .whereNotNull()
              .toList();
        }

        final listHome = await getClubOfCompetition('homeTeamName');
        final listGuest = await getClubOfCompetition('opponentTeamName');

        clubs = [...listHome, ...listGuest];
      } else {
        clubs = [];
      }
      return clubs;
    })))
        .expand((element) => element);
    return clubs.toSet();
  }

  @override
  Future<Iterable<Membership>> importMemberships({required Club club}) async {
    final divisions = await importDivisions(minDate: DateTime.utc(MockableDateTime.now().year - 1));
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final teamMatches =
        (await Future.wait(leagues.map((e) => importTeamMatches(league: e)))).expand((element) => element);
    final memberships = (await Future.wait(
      teamMatches.map((teamMatch) async {
        final json = await _getCompetition(
            seasonId: teamMatch.league!.startDate.year.toString(), competitionId: teamMatch.orgSyncId!);
        if (json.isEmpty) return <Membership>{};
        final List<dynamic> boutList = json['competition']['_boutList'];

        final homeLicenseIds = boutList.map((boutJson) => int.tryParse(boutJson['homeWrestlerLicId'] ?? ''));
        final opponentLicenseIds = boutList.map((boutJson) => int.tryParse(boutJson['homeWrestlerLicId'] ?? ''));
        final licenseIds = [...homeLicenseIds, ...opponentLicenseIds].whereNotNull();
        final memberships = await Future.wait(licenseIds.map((e) async {
          final json = await _getSaisonWrestler(passCode: e);
          if (json.isEmpty) return null;
          final wrestlerJson = json['wrestler'];
          if (wrestlerJson == null || wrestlerJson['clubCode'] != club.no) {
            // FIXME: comparison may not is correct!
            return null;
          }
          return Membership(
            club: club,
            organization: organization,
            no: json['passcode'],
            orgSyncId: '${wrestlerJson['clubCode']}-${json['passcode']}',
            person: _copyPersonWithOrg(Person(
              prename: wrestlerJson['givenname'],
              surname: wrestlerJson['name'],
              gender: wrestlerJson['gender'] == 'm'
                  ? Gender.male
                  : (wrestlerJson['gender'] == 'w' ? Gender.female : Gender.other),
              birthDate: DateTime.parse(wrestlerJson['birthday']),
              nationality: Countries.values
                  .singleWhereOrNull((element) => element.unofficialNames.contains(wrestlerJson['nationality'])),
            )),
          );
        }));

        return memberships.whereNotNull().toSet();
      }),
    ))
        .expand((element) => element);
    return memberships.toSet();
  }

  @override
  Future<Iterable<Team>> importTeams({required Club club}) async {
    final divisions = await importDivisions(minDate: DateTime.utc(MockableDateTime.now().year - 1));
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final teams = (await Future.wait(leagues.map((league) async {
      final json = await _getCompetitionList(
        ligaId: league.division.name,
        regionId: league.name,
        seasonId: league.startDate.year.toString(),
      );
      if (json.isEmpty) return <Team>{};

      final competitionList = json['competitionList'];
      final Iterable<Team> teams;
      if (competitionList is Map<String, dynamic>) {
        Future<List<Team>> getTeamOfCompetition(String key) async {
          return (await Future.wait(competitionList.entries.map((entry) async {
            final Map<String, dynamic> values = entry.value;
            String? teamName = values[key];
            if (teamName == null) return null;
            if (teamName != teamName.trim()) {
              teamName = teamName.trim();
              print('Team with team name "$teamName" was trimmed');
            }
            if (teamName != club.name) return null;
            return Team(
              name: teamName,
              club: await _getSingleBySyncId<Club>(teamName),
              orgSyncId: teamName,
              organization: organization,
            );
          })))
              .whereNotNull()
              .toList();
        }

        final listHome = await getTeamOfCompetition('homeTeamName');
        final listGuest = await getTeamOfCompetition('opponentTeamName');

        teams = [...listHome, ...listGuest];
      } else {
        teams = [];
      }
      return teams;
    })))
        .expand((element) => element);
    return teams.toSet().where((element) => element.club == club);
  }

  @override
  Future<Iterable<League>> importLeagues({required Division division}) async {
    final json = await _getLeagueList(seasonId: division.startDate.year.toString());
    if (json.isEmpty) return <League>{};

    final leagueList = json['ligaList'][division.name];
    Iterable<League> leagues;
    if (leagueList is Map<String, dynamic>) {
      leagues = await Future.wait(
        leagueList.entries.map(
          (entry) async => League(
            name: entry.key,
            startDate: division.startDate,
            endDate: division.endDate,
            division: division,
            orgSyncId: '${division.orgSyncId}_${entry.key}',
            organization: organization,
          ),
        ),
      );
    } else {
      leagues = [];
    }
    return leagues;
  }

  @override
  Future<Iterable<TeamMatch>> importTeamMatches({required League league}) async {
    final json = await _getCompetitionList(
      ligaId: league.division.name,
      regionId: league.name,
      seasonId: league.startDate.year.toString(),
    );
    if (json.isEmpty) return <TeamMatch>{};

    final competitionList = json['competitionList'];
    if (competitionList is Map<String, dynamic>) {
      final teamMatches = await Future.wait(competitionList.entries.map((entry) async {
        final Map<String, dynamic> values = entry.value;
        final refereePrename = values['refereeGivenname'].toString().trim();
        final refereeSurname = values['refereeName'].toString().trim();
        final referee = refereePrename.isNotEmpty && refereeSurname.isNotEmpty
            ? _copyPersonWithOrg(Person(
                prename: refereePrename,
                surname: refereeSurname,
              ))
            : null;
        return TeamMatch(
          home: Lineup(
            team: await _getSingleBySyncId<Team>(values['homeTeamName']),
          ),
          guest: Lineup(
            team: await _getSingleBySyncId<Team>(values['opponentTeamName']),
          ),
          date: DateTime.parse(values['boutDate'] + ' ' + values['scaleTime']),
          visitorsCount: int.tryParse(values['audience']),
          location: values['location'],
          referee: referee,
          comment: values['editorComment'],
          league: league,
          no: entry.key,
          // TODO: Save number of boutdays in league, and use them here.
          seasonPartition: double.parse(values['boutday']) / 16 < 0.5 ? 1 : 2,
          organization: organization,
          orgSyncId: entry.key,
        );
      }));
      return teamMatches.toSet();
    }
    return [];
  }

  Person _copyPersonWithOrg(Person person) {
    return person.copyWith(orgSyncId: '${person.fullName}_${person.birthDate}', organization: organization);
  }

  Iterable<String>? cachedSeasonList;

  /// Get all seasons
  // ignore: unused_element
  Future<Iterable<String>> _getSeasonList() async {
    if (cachedSeasonList != null) return cachedSeasonList!;

    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'listSaison',
    });

    String body;
    if (!isMock) {
      print('Call API: $uri');
      final response = await http.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw Exception('Failed to get the saison list: ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = listSaisonJson;
    }
    final Map<String, dynamic> json = jsonDecode(body);
    final Map<String, dynamic> competitionList = json['ligaList'];
    cachedSeasonList = await Future.wait(competitionList.entries.map((entry) async => entry.value.toString()));
    return cachedSeasonList!;
  }

  final Map<String, Map<String, dynamic>> cachedLeagueList = {};

  /// Get leagues of a season
  Future<Map<String, dynamic>> _getLeagueList({
    String? seasonId,
  }) async {
    seasonId ??= MockableDateTime.now().year.toString();
    final cacheId = 's:$seasonId';
    if (cachedLeagueList[cacheId] != null) return cachedLeagueList[cacheId]!;
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'listLiga',
      'sid': seasonId,
    });
    String body;
    if (!isMock) {
      print('Call API: $uri');
      final response = await http.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the liga list (seasonId: $seasonId): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      if (seasonId == '2023') {
        body = listLigaJson;
      } else {
        body = '{}';
      }
    }
    cachedLeagueList[cacheId] = jsonDecode(body);
    return cachedLeagueList[cacheId]!;
  }

  final Map<String, Map<String, dynamic>> cachedCompetitionList = {};

  /// Get team matches of a league
  Future<Map<String, dynamic>> _getCompetitionList({
    required String seasonId,
    required String ligaId,
    required String regionId,
  }) async {
    final cacheId = 's:$seasonId,l:$ligaId,r:$regionId';
    if (cachedCompetitionList[cacheId] != null) return cachedCompetitionList[cacheId]!;
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'listCompetition',
      'sid': seasonId,
      'ligaId': ligaId,
      'rid': regionId,
    });

    String body;
    if (!isMock) {
      print('Call API: $uri');
      final response = await http.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the competition list (seasonId: $seasonId, ligaId: $ligaId, rid: $regionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      if (seasonId == '2023') {
        body = listCompetitionJson;
      } else {
        body = '{}';
      }
    }
    cachedCompetitionList[cacheId] = jsonDecode(body);
    return cachedCompetitionList[cacheId]!;
  }

  final Map<String, Map<String, dynamic>> cachedCompetitions = {};

  Future<Map<String, dynamic>> _getCompetition({
    required String seasonId,
    required String competitionId,
  }) async {
    final cacheId = 's:$seasonId,c:$competitionId';
    if (cachedCompetitions[cacheId] != null) return cachedCompetitions[cacheId]!;
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'getCompetition',
      'sid': seasonId,
      'cid': competitionId,
    });

    String body;
    if (!isMock) {
      print('Call API: $uri');
      final response = await http.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the competition list (seasonId: $seasonId, competitionId: $competitionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      if (seasonId == '2023') {
        body = competitionJson;
      } else {
        body = '{}';
      }
    }
    cachedCompetitions[cacheId] = jsonDecode(body);
    return cachedCompetitions[cacheId]!;
  }

  final Map<String, Map<String, dynamic>> cachedWrestlers = {};

  Future<Map<String, dynamic>> _getSaisonWrestler({
    required int passCode,
  }) async {
    final cacheId = 'p:$passCode';
    if (cachedWrestlers[cacheId] != null) return cachedWrestlers[cacheId]!;
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'getSaisonWrestler',
      'passcode': passCode.toString(),
    });

    String body;
    if (!isMock) {
      if (authService == null) {
        print('No credentials given. Operation `getSaisonWrestler` skipped.');
        return {};
      }
      print('Call API: $uri');
      final response = await http.get(uri, headers: authService?.header).timeout(timeout);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the competition list (passcode: $passCode): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = wrestlerJson;
    }
    cachedWrestlers[cacheId] = jsonDecode(body);
    return cachedWrestlers[cacheId]!;
  }
}
