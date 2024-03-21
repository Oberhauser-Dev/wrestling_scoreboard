import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:country/country.dart';
import 'package:http/http.dart' as http;

import '../../../common.dart';
import '../auth/authorization.dart';
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
    final json = await _getLeagueList(seasonId: minDate?.year.toString());
    final year = minDate?.year ?? int.parse(json['year']); // FIXME: year not matching the request.
    final divisionList = json['ligaList'];
    if (divisionList is Map<String, dynamic>) {
      return await Future.wait(divisionList.entries.map(
        (entry) async => Division(
          organization: organization,
          name: entry.key,
          startDate: DateTime(year),
          endDate: DateTime(year + 1),
          boutConfig: BoutConfig(),
          // TODO: get from "boutSchemeId" inside league list
          seasonPartitions: 2,
          orgSyncId: '${year}_${entry.key}',
        ),
      ));
    }
    return [];
  }

  @override
  Future<Iterable<DivisionWeightClass>> importDivisionWeightClasses({required Division division}) async {
    final leagues = await importLeagues(division: division);
    final competitions = await importTeamMatches(league: leagues.first);
    final json = await _getCompetition(
        seasonId: division.startDate.year.toString(), competitionId: competitions.first.orgSyncId!);
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
        return Club(
          name: values['homeTeamName'],
          organization: organization,
          orgSyncId: values['homeTeamName'],
          // TODO: read 'no' from endpoint, when available
          no: null,
        );
      }));

      final listGuest = await Future.wait(competitionList.entries.map((entry) async {
        final Map<String, dynamic> values = entry.value;
        return Club(
          name: values['opponentTeamName'],
          organization: organization,
          orgSyncId: values['opponentTeamName'],
          // TODO: read 'no' from endpoint, when available
          no: null,
        );
      }));

      return [...listHome, ...listGuest];
    })))
        .expand((element) => element);
    return clubs.toSet();
  }

  @override
  Future<Iterable<Membership>> importMemberships({required Club club}) async {
    final divisions = await importDivisions(minDate: DateTime(DateTime.now().year - 1));
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final teamMatches =
        (await Future.wait(leagues.map((e) => importTeamMatches(league: e)))).expand((element) => element);
    final memberships = (await Future.wait(
      teamMatches.map((teamMatch) async {
        final json = await _getCompetition(
            seasonId: teamMatch.league!.startDate.year.toString(), competitionId: teamMatch.orgSyncId!);
        final List<dynamic> boutList = json['competition']['_boutList'];

        final homeLicenseIds = boutList.map((boutJson) => int.tryParse(boutJson['homeWrestlerLicId'] ?? ''));
        final opponentLicenseIds = boutList.map((boutJson) => int.tryParse(boutJson['homeWrestlerLicId'] ?? ''));
        final licenseIds = [...homeLicenseIds, ...opponentLicenseIds].whereNotNull();
        final memberships = await Future.wait(licenseIds.map((e) async {
          final json = await _getSaisonWrestler(passCode: e);
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
    final divisions = await importDivisions();
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final teams = (await Future.wait(leagues.map((league) async {
      final json = await _getCompetitionList(
        ligaId: league.division.name,
        regionId: league.name,
        seasonId: league.startDate.year.toString(),
      );

      final Map<String, dynamic> competitionList = json['competitionList'];
      Future<List<Team>> getTeamOfCompetition(String key) async {
        return (await Future.wait(competitionList.entries.map((entry) async {
          final Map<String, dynamic> values = entry.value;
          final teamName = values[key];
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

      listHome.addAll(listGuest);
      return listHome;
    })))
        .expand((element) => element);
    return teams.toSet().where((element) => element.club == club);
  }

  @override
  Future<Iterable<League>> importLeagues({required Division division}) async {
    final json = await _getLeagueList(seasonId: division.startDate.year.toString());

    final leagueList = json['ligaList'][division.name];
    if (leagueList is Map<String, dynamic>) {
      return await Future.wait(
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
    }
    return [];
  }

  @override
  Future<Iterable<TeamMatch>> importTeamMatches({required League league}) async {
    final json = await _getCompetitionList(
      ligaId: league.division.name,
      regionId: league.name,
      seasonId: league.startDate.year.toString(),
    );

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

  /// Get all seasons
  // ignore: unused_element
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
      body = listSaisonJson;
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
      body = listLigaJson;
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
      body = listCompetitionJson;
    }
    return jsonDecode(body);
  }

  Future<Map<String, dynamic>> _getCompetition({
    required String seasonId,
    required String competitionId,
  }) async {
    final uri = Uri.parse(apiUrl).replace(queryParameters: {
      'op': 'getCompetition',
      'sid': seasonId,
      'cid': competitionId,
    });

    String body;
    if (!isMock) {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the competition list (seasonId: $seasonId, competitionId: $competitionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = competitionJson;
    }
    return jsonDecode(body);
  }

  Future<Map<String, dynamic>> _getSaisonWrestler({
    required int passCode,
  }) async {
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
      final response = await http.get(uri, headers: authService?.header);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get the competition list (passcode: $passCode): ${response.reasonPhrase ?? response.statusCode.toString()}');
      }
      body = response.body;
    } else {
      body = wrestlerJson;
    }
    return jsonDecode(body);
  }
}
