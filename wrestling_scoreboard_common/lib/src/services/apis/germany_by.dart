import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:country/country.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../../common.dart';
import '../../util/transaction.dart';
import 'mocks/competition_s-2023_c-005029c.json.dart';
import 'mocks/competition_s-2023_c-029013c.json.dart';
import 'mocks/listClubs.json.dart';
import 'mocks/listCompetition.json.dart';
import 'mocks/listLiga.json.dart';
import 'mocks/listSaison.json.dart';
import 'mocks/wrestler.json.dart';

class ByGermanyWrestlingApi extends WrestlingApi {
  final String apiUrl;
  final log = Logger('ByGermanyWrestlingApi');

  @override
  final BasicAuthService? authService;

  bool isMock = false;

  @override
  final Organization organization;

  @override
  GetSingleOfOrg getSingleOfOrg;

  late Future<T> Function<T extends Organizational>(String orgSyncId) _getSingleBySyncId;

  ByGermanyWrestlingApi(
    this.organization, {
    required this.getSingleOfOrg,
    this.apiUrl = 'https://www.brv-ringen.de/Api/dev/cs/',
    this.authService,
  }) {
    _getSingleBySyncId =
        <T extends Organizational>(String orgSyncId) => getSingleOfOrg<T>(orgSyncId, orgId: organization.id!);
  }

  final totalRegionWildcard = 'Bayern';

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
    final json = await _getLeagueList(seasonId: division.startDate.year.toString());
    if (json.isEmpty) return <DivisionWeightClass>{};

    final leagueList = json['ligaList'][division.name];
    Iterable<DivisionWeightClass> divisionWeightClasses;
    if (leagueList is Map<String, dynamic> && leagueList.isNotEmpty) {
      // Get division bout scheme from first league
      final firstLeague = leagueList.entries.first.value;
      final List<dynamic> boutSchemeMap = firstLeague['boutScheme'];

      final weightClassCount = boutSchemeMap.length;
      divisionWeightClasses = boutSchemeMap.map((item) {
        final originalPos = int.parse(item['order']) - 1;
        final suffix = (item['suffix'] ?? '').trim();
        final weightClassP1 = WeightClass(
          style: item['styleA'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
          weight: int.parse(item['weight']),
          suffix: suffix.isEmpty ? null : suffix,
          unit: WeightUnit.kilogram,
        );
        final divisionWeightClassPartition1 = DivisionWeightClass(
          // Alter order of weightclasses
          pos: originalPos < (weightClassCount / 2) ? originalPos * 2 : (weightClassCount - originalPos - 1) * 2 + 1,
          seasonPartition: 0,
          division: division,
          weightClass: weightClassP1,
          organization: organization,
          orgSyncId:
              _getDivisionWeightClassOrgSyncId(division: division, weightClass: weightClassP1, seasonPartition: 0),
        );
        final weightClassP2 = weightClassP1.copyWith(
          style: item['styleB'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
        );
        final divisionWeightClassPartition2 = divisionWeightClassPartition1.copyWith(
          seasonPartition: 1,
          weightClass: weightClassP2,
          orgSyncId:
              _getDivisionWeightClassOrgSyncId(division: division, weightClass: weightClassP2, seasonPartition: 1),
        );
        return [divisionWeightClassPartition1, divisionWeightClassPartition2];
      }).expand((element) => element);
    } else {
      divisionWeightClasses = [];
    }
    return divisionWeightClasses.sorted((a, b) {
      if (a.seasonPartition == null || b.seasonPartition == null) {
        return a.pos.compareTo(b.pos);
      }
      int comparison = a.seasonPartition!.compareTo(b.seasonPartition!);
      if (comparison == 0) {
        comparison = a.pos.compareTo(b.pos);
      }
      return comparison;
    });
  }

  String _getDivisionWeightClassOrgSyncId({
    required Division division,
    required WeightClass weightClass,
    required int seasonPartition,
  }) {
    return '${division.orgSyncId}_${weightClass.name}_${weightClass.style.name}_$seasonPartition'.replaceAll(' ', '_');
  }

  @override
  Future<Iterable<Club>> importClubs() async {
    final clubListJson = await _getClubList();
    if (clubListJson.isEmpty) return <Club>{};

    final clubs = clubListJson.map((json) {
      String? clubName = json['clubName'];
      String? clubId = json['clubId'];
      if (clubName == null || clubId == null) return null;
      if (clubName != clubName.trim()) {
        clubName = clubName.trim();
        log.warning('Club with club name "$clubName" was trimmed');
      }
      return Club(
        name: clubName,
        no: clubId,
        orgSyncId: clubId,
        organization: organization,
      );
    });
    return clubs.nonNulls.toSet();
  }

  @override
  Future<Iterable<Membership>> importMemberships({required Club club}) async {
    final divisions = await importDivisions(minDate: DateTime.utc(MockableDateTime.now().year - 1));
    final leagues = (await Future.wait(divisions.map((e) => importLeagues(division: e)))).expand((element) => element);
    final teamMatches = (await Future.wait(leagues.map((e) => importTeamMatches(league: e))))
        .expand((element) => element)
        .where((teamMatch) {
      return teamMatch.home.team.club == club || teamMatch.guest.team.club == club;
    });
    final memberships = (await Future.wait(
      teamMatches.map((teamMatch) async {
        final bouts = await importBouts(event: teamMatch);
        final homeMemberships = bouts.keys
            .where((bout) => bout.r?.participation.membership.club == club)
            .map((bout) => bout.r!.participation.membership);
        final opponentMemberships = bouts.keys
            .where((bout) => bout.b?.participation.membership.club == club)
            .map((bout) => bout.b!.participation.membership);
        return [...homeMemberships, ...opponentMemberships].nonNulls;
      }),
    ))
        .expand((element) => element);
    return memberships.toSet();
  }

  Future<Membership?> _getMembership({
    required int passCode,
    required Future<Club?> Function(String clubId) getClub,
  }) async {
    final json = await _getSaisonWrestler(passCode: passCode);
    if (json == null) return null;
    final wrestlerJson = json['wrestler'];
    final club = await getClub(wrestlerJson['clubId']);
    if (wrestlerJson == null || club == null) {
      return null;
    }
    return Membership(
      club: club,
      organization: organization,
      no: json['passcode'],
      orgSyncId: '${wrestlerJson['clubId']}-${json['passcode']}',
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
  }

  @override
  Future<Iterable<Team>> importTeams({required Club club}) async {
    final clubListJson = await _getClubList();
    if (clubListJson.isEmpty) return <Team>{};

    final clubJson = clubListJson.singleWhereOrNull((clubJson) => clubJson['clubId'] == club.orgSyncId);
    if (clubJson == null) return <Team>{};

    final teamListJson = (clubJson['teamList'] as Map<String, dynamic>?)?.values;
    if (teamListJson == null) return <Team>{};

    final teams = teamListJson.map((json) {
      String? teamName = json['teamName'];
      String? teamId = json['teamId'];
      if (teamName == null || teamId == null) return null;
      if (teamName != teamName.trim()) {
        teamName = teamName.trim();
        log.warning('Team with team name "$teamName" was trimmed');
      }
      return Team(
        name: teamName,
        orgSyncId: teamName,
        organization: organization,
        club: club,
      );
    });
    return teams.nonNulls.toSet();
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
          (entry) async {
            String leagueName = entry.key.trim();
            if (leagueName.isEmpty) {
              // If division has only one league it is the league for whole Bavarian.
              leagueName = totalRegionWildcard;
            }
            return League(
              name: leagueName,
              startDate: division.startDate,
              endDate: division.endDate,
              division: division,
              boutDays: int.parse(entry.value['noOfBoutDays']),
              orgSyncId: '${division.orgSyncId}_$leagueName',
              organization: organization,
            );
          },
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

        final competitionJson = (await _getCompetition(
            seasonId: league.startDate.year.toString(), competitionId: entry.key))['competition'];
        if (competitionJson == null) return null;
        return TeamMatch(
          home: Lineup(
            team: await _getSingleBySyncId<Team>(
                (competitionJson['homeTeamName'] as String).trim()), // teamId is not unique across all IDs
          ),
          guest: Lineup(
            team: await _getSingleBySyncId<Team>(
                (competitionJson['opponentTeamName'] as String).trim()), // teamId is not unique across all IDs
          ),
          date: DateTime.parse(values['boutDate'] + ' ' + values['scaleTime']),
          visitorsCount: int.tryParse(values['audience']),
          location: values['location'],
          referee: referee,
          comment: values['editorComment'],
          league: league,
          no: entry.key,
          seasonPartition: double.parse(values['boutday']) / league.boutDays <= 0.5 ? 0 : 1,
          organization: organization,
          orgSyncId: entry.key,
        );
      }));
      return teamMatches.nonNulls.toSet();
    }
    return [];
  }

  @override
  Future<Map<Bout, Iterable<BoutAction>>> importBouts({required WrestlingEvent event}) async {
    if (event is TeamMatch) {
      final competitionJson = (await _getCompetition(
          seasonId: event.league!.startDate.year.toString(), competitionId: event.orgSyncId!))['competition'];
      if (competitionJson == null) return {};
      final List<dynamic> boutListJson = competitionJson['_boutList'];
      if (boutListJson.isEmpty) return {};
      try {
        final boutActionMapEntries = await Future.wait(boutListJson.map((boutJson) async {
          final weightClassMatch = RegExp(r'(\d+)(\D*)').firstMatch(boutJson['weightClass'])!;
          final suffix = weightClassMatch.group(2)?.trim() ?? '';
          var weightClass = WeightClass(
            weight: int.parse(weightClassMatch.group(1)!), // Group 0 is the whole matched string
            suffix: suffix.isEmpty ? null : suffix,
            style: boutJson['style'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
            unit: WeightUnit.kilogram,
          );
          try {
            final divisionWeightClass = await _getSingleBySyncId<DivisionWeightClass>(_getDivisionWeightClassOrgSyncId(
                division: event.league!.division,
                weightClass: weightClass,
                seasonPartition: event.seasonPartition ?? 0));
            weightClass = divisionWeightClass.weightClass;
          } catch (e, st) {
            throw Exception(
              'The division weight class $weightClass cannot be found. '
              'This can happen, if the leagues `noOfBoutDays` is incorrect and therefore the weight classes of the current bout day are misconfigured.\n'
              '$e\n'
              '$st',
            );
          }

          final homeSyncId = int.tryParse(boutJson['homeWrestlerId'] ?? '');
          final homeMembership = homeSyncId == null
              ? null
              : await _getMembership(
                  passCode: homeSyncId, getClub: (clubId) async => await _getSingleBySyncId<Club>(clubId));

          final opponentSyncId = int.tryParse(boutJson['opponentWrestlerId'] ?? '');
          final opponentMembership = opponentSyncId == null
              ? null
              : await _getMembership(
                  passCode: opponentSyncId, getClub: (clubId) async => await _getSingleBySyncId<Club>(clubId));

          BoutResult? getBoutResult(String? result) {
            try {
              return switch (result) {
                'PS' => BoutResult.vpo, // Punktesieg
                'SS' => BoutResult.vfa, // Schultersieg
                'TÜ' => BoutResult.vsu, // Technische Überlegenheit
                'ÜG' => BoutResult.dsq, // Übergewicht, TODO: wrongly mapped
                'AS' => BoutResult.vin, // Aufgabesieg
                'DV' => BoutResult.vca, // Disqualifikation aufgrund von Regelwidrigkeit
                'KL' => BoutResult.vfo, // Kampfloser Sieger, TODO: wrongly mapped
                'DN' => BoutResult.vfo,
                'DQ' => BoutResult.dsq,
                'DQ2' => BoutResult.dsq2,
                '' => null,
                null => null,
                _ => throw UnimplementedError('The bout result type "$result" is not known in bout $boutJson.'),
              };
            } catch (e, st) {
              log.severe('Could not parse bout result $result', e, st);
            }
            return null;
          }

          final classificationPointsHome = int.tryParse(boutJson['homeWrestlerPoints']);
          final classificationPointsOpponent = int.tryParse(boutJson['opponentWrestlerPoints']);
          BoutRole? winnerRole;
          if ((classificationPointsHome ?? 0) > (classificationPointsOpponent ?? 0)) {
            winnerRole = BoutRole.red;
          } else if ((classificationPointsHome ?? 0) < (classificationPointsOpponent ?? 0)) {
            winnerRole = BoutRole.blue;
          }

          final String boutDurationJson = boutJson['annotation']?['1']?['duration']?['value'] ?? '';
          final boutDurationSeconds = int.tryParse(boutDurationJson);
          final boutDuration = boutDurationSeconds == null ? Duration.zero : Duration(seconds: boutDurationSeconds);

          var bout = Bout(
            orgSyncId: '${event.orgSyncId}_${weightClass.name}_${weightClass.style.name}'.replaceAll(' ', '_'),
            organization: organization,
            duration: boutDuration,
            weightClass: weightClass,
            result: getBoutResult(boutJson['result']),
            winnerRole: winnerRole,
            r: homeMembership == null
                ? null
                : ParticipantState(
                    classificationPoints: classificationPointsHome,
                    participation: Participation(
                      // TODO: Participation is shared
                      lineup: event.home,
                      membership: homeMembership,
                      weight: null, // TODO: Weight not available
                      weightClass: weightClass,
                    ),
                  ),
            b: opponentMembership == null
                ? null
                : ParticipantState(
                    classificationPoints: classificationPointsOpponent,
                    participation: Participation(
                      // TODO: Participation is shared
                      lineup: event.guest,
                      membership: opponentMembership,
                      weight: null, // TODO: Weight not available
                      weightClass: weightClass,
                    ),
                  ),
          );

          BoutAction parseActionStr(String str) {
            final match = RegExp(r'(\d+|[A-Z])([BRbr])(\d*)').firstMatch(str);
            if (match == null) throw Exception('Could not parse action "$str" in bout $boutJson.');
            final actionStr = match.group(1)!; // Group 0 is the whole matched string
            int? pointCount;
            BoutActionType actionType;
            switch (actionStr) {
              case 'A':
                if (weightClass.style == WrestlingStyle.greco) {
                  throw Exception('Activity Time "A" should be only available in free style: $boutJson');
                }
                // Germany handles passivity as activity period 'A' in free style.
                actionType = BoutActionType.passivity;
              case 'P':
                if (weightClass.style == WrestlingStyle.greco) {
                  actionType = BoutActionType.passivity;
                } else {
                  // Germany handles the first a verbal admonition before an activity period as passivity 'P' in free style.
                  actionType = BoutActionType.verbal;
                }
              case 'V':
                actionType = BoutActionType.verbal;
              case 'O':
                actionType = BoutActionType.caution;
              case 'D':
                actionType = BoutActionType.dismissal;
              default:
                actionType = BoutActionType.points;
                pointCount = int.tryParse(actionStr);
                if (pointCount == null) {
                  throw Exception('Action type "$actionStr" could not be parsed: $boutJson');
                }
            }

            return BoutAction(
              pointCount: pointCount,
              // Group 0 is the whole matched string
              actionType: actionType,
              bout: bout,
              role: match.group(2)! == 'R' ? BoutRole.red : BoutRole.blue,
              duration: Duration(seconds: int.parse(match.group(3)!)),
            );
          }

          final String boutActionsJson = boutJson['annotation']?['1']?['points']?['value'] ?? '';
          final Iterable<BoutAction> boutActions = boutActionsJson.split(',').where((str) => str.isNotEmpty).map((str) {
            try {
              return parseActionStr(str);
            } catch (e, st) {
              log.severe('Could not parse action str $str', e, st);
              return null;
            }
          }).nonNulls;

          // Duration is not available in the new RDB spec, so use the last action as duration.
          if (bout.duration == Duration.zero && boutActions.isNotEmpty) {
            bout = bout.copyWith(duration: boutActions.last.duration);
          }
          return MapEntry(bout, boutActions);
        }));
        return Map.fromEntries(boutActionMapEntries);
      } on Exception catch (e, st) {
        log.severe('Could not import bouts from bout list: $boutListJson', e, st);
        return {};
      }
    }
    throw UnimplementedError();
  }

  Person _copyPersonWithOrg(Person person) {
    return person.copyWith(
        orgSyncId: '${person.prename}_${person.surname}_${person.birthDate?.toIso8601String().substring(0, 10)}',
        organization: organization);
  }

  @override
  Future<List<DataObject>> search({required String searchStr, required Type searchType}) async {
    switch (searchType) {
      case const (Membership):
        final membership = await _getMembership(
            passCode: int.parse(searchStr),
            getClub: (clubId) async {
              return await _getSingleBySyncId<Club>(clubId);
            });
        if (membership == null) {
          throw Exception('Membership with search string "$searchStr" and type "$searchType" was not found.');
        }
        return [membership];
      default:
        throw Exception('API provider search for type $searchType is not supported yet.');
    }
  }

  Iterable<Map<String, dynamic>>? cachedClubList;

  /// Get all clubs
  Future<Iterable<Map<String, dynamic>>> _getClubList() async {
    return await runSynchronized(
      key: 'getClubList',
      canAbort: () => cachedClubList != null,
      runAsync: () async {
        if (cachedClubList != null) return cachedClubList!;

        final uri = Uri.parse(apiUrl).replace(queryParameters: {
          'op': 'listClub',
        });

        String body;
        if (!isMock) {
          log.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri));
          if (response.statusCode != 200) {
            throw Exception(
                'Failed to get the saison list: ${response.reasonPhrase ?? response.statusCode.toString()}');
          }
          body = response.body;
        } else {
          body = listClubJson;
        }
        final Map<String, dynamic> json = jsonDecode(body);
        final Iterable<dynamic> competitionList = (json['clubList'] as Map<String, dynamic>).values;
        cachedClubList = await Future.wait(competitionList.map((entry) async => entry as Map<String, dynamic>));
        return cachedClubList!;
      },
    );
  }

  Iterable<String>? cachedSeasonList;

  /// Get all seasons
  // ignore: unused_element
  Future<Iterable<String>> _getSeasonList() async {
    return await runSynchronized(
      key: 'getSeasonList',
      canAbort: () => cachedSeasonList != null,
      runAsync: () async {
        if (cachedSeasonList != null) return cachedSeasonList!;

        final uri = Uri.parse(apiUrl).replace(queryParameters: {
          'op': 'listSaison',
        });

        String body;
        if (!isMock) {
          log.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri));
          if (response.statusCode != 200) {
            throw Exception(
                'Failed to get the saison list: ${response.reasonPhrase ?? response.statusCode.toString()}');
          }
          body = response.body;
        } else {
          body = listSaisonJson;
        }
        final Map<String, dynamic> json = jsonDecode(body);
        final Map<String, dynamic> competitionList = json['ligaList'];
        cachedSeasonList = await Future.wait(competitionList.entries.map((entry) async => entry.value.toString()));
        return cachedSeasonList!;
      },
    );
  }

  final Map<String, Map<String, dynamic>> cachedLeagueList = {};

  /// Get leagues of a season
  Future<Map<String, dynamic>> _getLeagueList({
    String? seasonId,
  }) async {
    seasonId ??= MockableDateTime.now().year.toString();
    final cacheId = 's:$seasonId';
    return await runSynchronized(
      key: 'getLeagueList_$cacheId',
      canAbort: () => cachedLeagueList[cacheId] != null,
      runAsync: () async {
        if (cachedLeagueList[cacheId] != null) return cachedLeagueList[cacheId]!;
        final uri = Uri.parse(apiUrl).replace(queryParameters: {
          'op': 'listLiga',
          'sid': seasonId,
        });
        String body;
        if (!isMock) {
          log.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri));
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
      },
    );
  }

  final Map<String, Map<String, dynamic>> cachedCompetitionList = {};

  /// Get team matches of a league
  Future<Map<String, dynamic>> _getCompetitionList({
    required String seasonId,
    required String ligaId,
    required String regionId,
  }) async {
    final cacheId = 's:$seasonId,l:$ligaId,r:$regionId';
    return await runSynchronized(
      key: 'getCompetitionList_$cacheId',
      canAbort: () => cachedCompetitionList[cacheId] != null,
      runAsync: () async {
        if (cachedCompetitionList[cacheId] != null) return cachedCompetitionList[cacheId]!;
        final uri = Uri.parse(apiUrl).replace(queryParameters: {
          'op': 'listCompetition',
          'sid': seasonId,
          'ligaId': ligaId,
          // Replace total region name with empty
          'rid': regionId == totalRegionWildcard ? '' : regionId,
        });

        String body;
        if (!isMock) {
          log.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri));
          if (response.statusCode != 200) {
            throw Exception(
                'Failed to get the competition list (seasonId: $seasonId, ligaId: $ligaId, rid: $regionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
          }
          body = response.body;
        } else {
          if (seasonId == '2023' && ligaId == 'Bayernliga' && regionId == 'Süd') {
            body = listCompetitionS2023LBayernligaRSuedJson;
          } else {
            body = '{}';
          }
        }
        cachedCompetitionList[cacheId] = jsonDecode(body);
        return cachedCompetitionList[cacheId]!;
      },
    );
  }

  final Map<String, Map<String, dynamic>> cachedCompetitions = {};

  Future<Map<String, dynamic>> _getCompetition({
    required String seasonId,
    required String competitionId,
  }) async {
    final cacheId = 's:$seasonId,c:$competitionId';
    return await runSynchronized(
      key: 'getCompetition_$cacheId',
      canAbort: () => cachedCompetitions[cacheId] != null,
      runAsync: () async {
        if (cachedCompetitions[cacheId] != null) return cachedCompetitions[cacheId]!;

        final uri = Uri.parse(apiUrl).replace(queryParameters: {
          'op': 'getCompetition',
          'sid': seasonId,
          'cid': competitionId,
        });

        String body;
        if (!isMock) {
          log.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri));
          if (response.statusCode != 200) {
            throw Exception(
                'Failed to get the competition (seasonId: $seasonId, competitionId: $competitionId): ${response.reasonPhrase ?? response.statusCode.toString()}');
          }
          body = response.body;
        } else {
          if (seasonId == '2023') {
            if (competitionId == '005029c') {
              body = competitionS2023C005029cJson;
            } else if (competitionId == '029013c') {
              body = competitionS2023C029013cJson;
            } else {
              body = '{}';
            }
          } else {
            body = '{}';
          }
        }
        cachedCompetitions[cacheId] = jsonDecode(body);
        return cachedCompetitions[cacheId]!;
      },
    );
  }

  final Map<String, Map<String, dynamic>> cachedWrestlers = {};

  Future<Map<String, dynamic>?> _getSaisonWrestler({
    required int passCode,
  }) async {
    final cacheId = 'p:$passCode';
    return await runSynchronized(
      key: 'getSaisonWrestler_$cacheId',
      canAbort: () => cachedWrestlers[cacheId] != null,
      runAsync: () async {
        if (cachedWrestlers[cacheId] != null) return cachedWrestlers[cacheId]!;
        final uri = Uri.parse(apiUrl).replace(queryParameters: {
          'op': 'getSaisonWrestler',
          'passcode': passCode.toString(),
        });

        String? body;
        if (!isMock) {
          if (authService == null) {
            throw Exception('Failed to get the wrestler (passcode: $passCode): No credentials given.');
          }
          log.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode != 200) {
            throw Exception(
                'Failed to get the wrestler (passcode: $passCode): ${response.reasonPhrase ?? response.statusCode.toString()}');
          }
          body = response.body;
        } else {
          body = getWrestlerJson(passCode);
        }
        if (body == null) return null;
        cachedWrestlers[cacheId] = jsonDecode(body);
        return cachedWrestlers[cacheId]!;
      },
    );
  }
}
