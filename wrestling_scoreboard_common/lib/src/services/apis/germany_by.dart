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
  final _logger = Logger('ByGermanyWrestlingApi');

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

  Iterable<BoutResultRule> _teamMatchBoutResultRules(BoutConfig config) => [
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vfa,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vin,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vca,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vsu,
      technicalPointsDifference: 15,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 8,
      winnerClassificationPoints: 3,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 3,
      winnerClassificationPoints: 2,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vpo,
      technicalPointsDifference: 1,
      winnerClassificationPoints: 1,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.vfo,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.dsq,
      winnerClassificationPoints: 4,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.bothDsq,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.bothVfo,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
    BoutResultRule(
      boutConfig: config,
      boutResult: BoutResult.bothVin,
      winnerClassificationPoints: 0,
      loserClassificationPoints: 0,
    ),
  ];

  @override
  Future<bool> checkCredentials() async {
    if (isMock) {
      return true;
    } else {
      final uri = Uri.parse(apiUrl).replace(queryParameters: {'op': 'getSaisonWrestler', 'passcode': '2781'});
      _logger.fine('Call API to check credentials: $uri');
      final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
      if (response.statusCode >= 400) {
        return false;
      }
      return true;
    }
  }

  @override
  Future<Map<Division, Iterable<BoutResultRule>>> importDivisions({DateTime? minDate, DateTime? maxDate}) async {
    maxDate ??= MockableDateTime.now();
    minDate ??= DateTime.utc(maxDate.year - 1);
    final years = List<int>.generate(maxDate.year - minDate.year + 1, (index) => minDate!.year + index);
    final divisions = await Future.wait(
      years.map((year) async {
        final json = await _getLeagueList(seasonId: year.toString());
        if (json.isEmpty) return <Division, Iterable<BoutResultRule>>{};
        if (year != int.tryParse(json['year'])) throw "Years don't match: $year & ${json['year']}";
        final divisionList = json['ligaList'];
        Map<Division, Iterable<BoutResultRule>> divisionBoutResultRulesMap;
        if (divisionList is Map<String, dynamic>) {
          final divisionBoutRulesEntries = await Future.wait(
            divisionList.entries.map((divisionEntry) async {
              // Get division bout scheme from first league
              final leagueMap = divisionEntry.value as Map<String, dynamic>;
              final firstLeague = leagueMap.entries.first.value;
              final ageGroup = firstLeague['systemId'];
              for (final leagueEntry in leagueMap.entries) {
                if (leagueEntry.value['systemId'] != ageGroup) {
                  throw Exception('systemId/ageGroup differs within the division $divisionEntry');
                }
              }

              final isAdult = ageGroup == 'M' || ageGroup == 'F';
              final isYouth = ageGroup == 'S';
              BoutConfig boutConfig;
              Iterable<BoutResultRule> boutResultRules;
              if (isAdult) {
                boutConfig = const BoutConfig(
                  periodDuration: Duration(minutes: 3),
                  breakDuration: Duration(seconds: 30),
                  activityDuration: Duration(seconds: 30),
                  injuryDuration: Duration(minutes: 2),
                  bleedingInjuryDuration: Duration(minutes: 4),
                  periodCount: 2,
                );
                boutResultRules = _teamMatchBoutResultRules(boutConfig);
              } else if (isYouth) {
                boutConfig = const BoutConfig(
                  periodDuration: Duration(minutes: 2),
                  breakDuration: Duration(seconds: 30),
                  activityDuration: Duration(seconds: 30),
                  injuryDuration: Duration(minutes: 2),
                  bleedingInjuryDuration: Duration(minutes: 4),
                  periodCount: 2,
                );
                boutResultRules = _teamMatchBoutResultRules(boutConfig);
              } else {
                throw Exception('Cannot determine systemId/ageGroup: ${firstLeague['systemId']}');
              }
              final division = Division(
                organization: organization,
                name: divisionEntry.key,
                startDate: DateTime.utc(year),
                endDate: DateTime.utc(year + 1),
                boutConfig: boutConfig,
                seasonPartitions: 2,
                orgSyncId: '${year}_${divisionEntry.key}',
              );
              return MapEntry(division, boutResultRules);
            }),
          );
          divisionBoutResultRulesMap = Map.fromEntries(divisionBoutRulesEntries);
        } else {
          divisionBoutResultRulesMap = {};
        }
        return divisionBoutResultRulesMap;
      }),
    );
    return divisions.reduce((a, b) => a..addAll(b));
  }

  Iterable<LeagueWeightClass> _parseJsonLeagueWeightClass(Map<String, dynamic> item, League league) {
    final originalPos = int.parse(item['order']) - 1;
    final suffix = (item['suffix'] ?? '').trim();
    final weightClassPartition1 = WeightClass(
      style: item['styleA'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
      weight: int.parse(item['weight']),
      suffix: suffix.isEmpty ? null : suffix,
      unit: WeightUnit.kilogram,
    );
    final leagueWeightClassPartition1 = LeagueWeightClass(
      pos: originalPos,
      organization: organization,
      orgSyncId: _getWeightClassOrgSyncId(
        parentOrgSyncId: league.orgSyncId!,
        weightClass: weightClassPartition1,
        seasonPartition: 0,
      ),
      league: league,
      weightClass: weightClassPartition1,
      seasonPartition: 0,
    );
    final weightClassP2 = weightClassPartition1.copyWith(
      style: item['styleB'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
    );
    final leagueWeightClassPartition2 = leagueWeightClassPartition1.copyWith(
      seasonPartition: 1,
      weightClass: weightClassP2,
      orgSyncId: _getWeightClassOrgSyncId(
        parentOrgSyncId: league.orgSyncId!,
        weightClass: weightClassP2,
        seasonPartition: 1,
      ),
    );
    return [leagueWeightClassPartition1, leagueWeightClassPartition2];
  }

  @override
  Future<(Iterable<DivisionWeightClass>, Iterable<LeagueWeightClass>)> importDivisionAndLeagueWeightClasses({
    required Division division,
  }) async {
    final json = await _getLeagueList(seasonId: division.startDate.year.toString());
    if (json.isEmpty) return (<DivisionWeightClass>{}, <LeagueWeightClass>{});

    final divisionMap = json['ligaList'][division.name];
    if (divisionMap is! Map<String, dynamic> || divisionMap.isEmpty) {
      return (<DivisionWeightClass>{}, <LeagueWeightClass>{});
    }

    final Iterable<Iterable<LeagueWeightClass>> weightClassedPerLeague = await Future.wait(
      divisionMap.entries.map((leagueJsonEntries) async {
        final Map<String, dynamic> leagueJson = leagueJsonEntries.value;
        final List<dynamic> boutSchemeList = leagueJson['boutScheme'];
        final league = await _getSingleBySyncId<League>(
          _getLeagueOrgSyncId(division: division, leagueName: leagueJsonEntries.key),
        );
        return boutSchemeList.map((item) => _parseJsonLeagueWeightClass(item, league)).expand((element) => element);
      }),
    );

    final groupedByWeightClassList = weightClassedPerLeague.groupListsByIterable((leagueWeightClassList) {
      return leagueWeightClassList.map((lwcl) => lwcl.weightClass).toSet();
    });

    // This is the weight class, which is the most common, so use it as default in division level.
    final sortedWeightClassEntries =
        groupedByWeightClassList.entries.toList()..sort((a, b) => a.value.length.compareTo(b.value.length));
    final mostCommonWeightClasses = sortedWeightClassEntries.last.key;

    var divisionWeightClasses = groupedByWeightClassList[mostCommonWeightClasses]!.first.map(
      (lwc) => DivisionWeightClass(
        pos: lwc.pos,
        division: division,
        weightClass: lwc.weightClass,
        organization: organization,
        orgSyncId: _getWeightClassOrgSyncId(
          parentOrgSyncId: division.orgSyncId!,
          weightClass: lwc.weightClass,
          seasonPartition: lwc.seasonPartition!,
        ),
        seasonPartition: lwc.seasonPartition,
      ),
    );
    // TODO: May not be sorted
    divisionWeightClasses = divisionWeightClasses.sorted((a, b) {
      if (a.seasonPartition == null || b.seasonPartition == null) {
        return a.pos.compareTo(b.pos);
      }
      int comparison = a.seasonPartition!.compareTo(b.seasonPartition!);
      if (comparison == 0) {
        comparison = a.pos.compareTo(b.pos);
      }
      return comparison;
    });

    // Handle remaining leagueWeightClasses
    groupedByWeightClassList.remove(mostCommonWeightClasses);
    final leagueWeightClasses = groupedByWeightClassList.values
        .expand((listOfLeagueWeightClassCategories) => listOfLeagueWeightClassCategories)
        .expand((listOfLeagueWeightClasses) => listOfLeagueWeightClasses);
    return (divisionWeightClasses, leagueWeightClasses);
  }

  String _getWeightClassOrgSyncId({
    required String parentOrgSyncId,
    required WeightClass weightClass,
    required int seasonPartition,
  }) {
    return '${parentOrgSyncId}_${weightClass.name}_${weightClass.style.name}_$seasonPartition'.replaceAll(' ', '_');
  }

  String _getLeagueOrgSyncId({required Division division, required String leagueName}) {
    leagueName = leagueName.trim();
    if (leagueName.isEmpty) {
      // If division has only one league it is the league for whole Bavarian.
      leagueName = totalRegionWildcard;
    }
    return '${division.orgSyncId}_$leagueName';
  }

  @override
  Future<Iterable<TeamClubAffiliation>> importTeamClubAffiliations() async {
    final clubListJson = await _getClubList();
    if (clubListJson.isEmpty) return <TeamClubAffiliation>{};

    final teamClubAffiliations = <TeamClubAffiliation>[];
    for (var clubJson in clubListJson) {
      String? clubName = clubJson['clubName'];
      final String? clubId = clubJson['clubId'];
      if (clubName == null || clubId == null) continue;
      if (clubName != clubName.trim()) {
        clubName = clubName.trim();
        _logger.warning('Club with club name "$clubName" was trimmed');
      }

      final club = Club(name: clubName, no: clubId, orgSyncId: clubId, organization: organization);

      final teamListJson = (clubJson['teamList'] as Map<String, dynamic>?)?.values;
      if (teamListJson == null || teamListJson.isEmpty) continue;

      for (final teamJson in teamListJson) {
        String? teamName = teamJson['teamName'];
        final String? teamId = teamJson['teamId'];
        if (teamName == null || teamId == null) continue;
        if (teamName != teamName.trim()) {
          teamName = teamName.trim();
          _logger.warning('Team with team name "$teamName" was trimmed');
        }
        final team = Team(name: teamName, orgSyncId: teamName, organization: organization);
        teamClubAffiliations.add(TeamClubAffiliation(team: team, club: club));
      }
    }
    return teamClubAffiliations.nonNulls.toSet();
  }

  @override
  Future<Iterable<Membership>> importMemberships({required Club club}) async {
    final divisions = await importDivisions(minDate: DateTime.utc(MockableDateTime.now().year - 1));
    final leagues = (await Future.wait(
      divisions.keys.map((e) => importLeagues(division: e)),
    )).expand((element) => element);
    final teamClubAffiliations = await importTeamClubAffiliations();
    final teamMatches = (await Future.wait(
      leagues.map((e) => importTeamMatches(league: e)),
    )).expand((element) => element.keys).where((teamMatch) {
      return teamClubAffiliations.any(
        (tca) => tca.team.orgSyncId == teamMatch.home.team.orgSyncId && tca.club.orgSyncId == club.orgSyncId,
      );
    });
    final memberships = (await Future.wait(
      teamMatches.map((teamMatch) async {
        final bouts = await importTeamMatchBouts(teamMatch: teamMatch);
        final homeMemberships = bouts.keys
            .where((tmb) => tmb.bout.r?.membership.club == club)
            .map((tmb) => tmb.bout.r!.membership);
        final opponentMemberships = bouts.keys
            .where((tmb) => tmb.bout.b?.membership.club == club)
            .map((tmb) => tmb.bout.b!.membership);
        return [...homeMemberships, ...opponentMemberships].nonNulls;
      }),
    )).expand((element) => element);
    return memberships.toSet();
  }

  Future<Membership> _getMembership({
    required int passCode,
    required Future<Club?> Function(String clubId) getClub,
  }) async {
    final json = await _getSaisonWrestler(passCode: passCode);
    final wrestlerJson = json['wrestler'];
    final club = await getClub(wrestlerJson['clubId']);
    if (wrestlerJson == null || club == null) {
      throw Exception('No field "wrestler" and/or "clubId" found for json:\n$json');
    }
    return Membership(
      club: club,
      organization: organization,
      no: json['passcode'],
      orgSyncId: '${wrestlerJson['clubId']}-${json['passcode']}',
      person: _copyPersonWithOrg(
        Person(
          prename: wrestlerJson['givenname'],
          surname: wrestlerJson['name'],
          gender:
              wrestlerJson['gender'] == 'm'
                  ? Gender.male
                  : (wrestlerJson['gender'] == 'w' ? Gender.female : Gender.other),
          birthDate: DateTime.parse(wrestlerJson['birthday']).copyWith(isUtc: true),
          nationality: Countries.values.singleWhereOrNull(
            (element) => element.unofficialNames.contains(wrestlerJson['nationality']),
          ),
        ),
      ),
    );
  }

  @override
  Future<Iterable<League>> importLeagues({required Division division}) async {
    final json = await _getLeagueList(seasonId: division.startDate.year.toString());
    if (json.isEmpty) return <League>{};

    final leagueList = json['ligaList'][division.name];
    Iterable<League> leagues;
    if (leagueList is Map<String, dynamic>) {
      leagues = await Future.wait(
        leagueList.entries.map((entry) async {
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
            orgSyncId: _getLeagueOrgSyncId(division: division, leagueName: leagueName),
            organization: organization,
          );
        }),
      );
    } else {
      leagues = [];
    }
    return leagues;
  }

  @override
  Future<Map<TeamMatch, Map<Person, PersonRole>>> importTeamMatches({required League league}) async {
    final json = await _getCompetitionList(
      ligaId: league.division.name,
      regionId: league.name,
      seasonId: league.startDate.year.toString(),
    );
    if (json.isEmpty) return {};

    final competitionList = json['competitionList'];
    if (competitionList is Map<String, dynamic>) {
      final teamMatches = await Future.wait(
        competitionList.entries.map((entry) async {
          final Map<String, dynamic> values = entry.value;
          final refereePrename = values['refereeGivenname'].toString().trim();
          final refereeSurname = values['refereeName'].toString().trim();
          final referee =
              refereePrename.isNotEmpty && refereeSurname.isNotEmpty
                  ? _copyPersonWithOrg(Person(prename: refereePrename, surname: refereeSurname))
                  : null;

          final competitionJson =
              (await _getCompetition(
                seasonId: league.startDate.year.toString(),
                competitionId: entry.key,
              ))['competition'];
          if (competitionJson == null) return null;
          final schemeIndex = (values['scheme'] as String?)?.toIndex();
          final seasonPartition =
              schemeIndex != null
                  ? (schemeIndex - 1)
                  : (double.parse(values['boutday']) / league.boutDays <= 0.5 ? 0 : 1);
          return MapEntry(
            TeamMatch(
              home: TeamLineup(
                team: await _getSingleBySyncId<Team>(
                  (competitionJson['homeTeamName'] as String).trim(),
                ), // teamId is not unique across all IDs
              ),
              guest: TeamLineup(
                team: await _getSingleBySyncId<Team>(
                  (competitionJson['opponentTeamName'] as String).trim(),
                ), // teamId is not unique across all IDs
              ),
              date: DateTime.parse('${values['boutDate']} ${values['scaleTime']}'),
              visitorsCount: int.tryParse(values['audience']),
              location: values['location'],
              comment: values['editorComment'],
              league: league,
              no: entry.key,
              seasonPartition: seasonPartition,
              organization: organization,
              orgSyncId: entry.key,
            ),
            {if (referee != null) referee: PersonRole.referee},
          );
        }),
      );
      return Map.fromEntries(teamMatches.nonNulls);
    }
    return {};
  }

  @override
  Future<Map<TeamMatchBout, Iterable<BoutAction>>> importTeamMatchBouts({required TeamMatch teamMatch}) async {
    final competitionJson =
        (await _getCompetition(
          seasonId: teamMatch.league!.startDate.year.toString(),
          competitionId: teamMatch.orgSyncId!,
        ))['competition'];
    if (competitionJson == null) return {};
    final List<dynamic> boutListJson = competitionJson['_boutList'];
    if (boutListJson.isEmpty) return {};
    try {
      final boutActionMapEntries = await Future.wait(
        boutListJson.indexed.map((indexedEntry) async {
          final (index, boutJson) = indexedEntry;
          final weightClassMatch = RegExp(r'(\d+)(\D*)').firstMatch(boutJson['weightClass'])!;
          final suffix = weightClassMatch.group(2)?.trim() ?? '';
          var weightClass = WeightClass(
            weight: int.parse(weightClassMatch.group(1)!), // Group 0 is the whole matched string
            suffix: suffix.isEmpty ? null : suffix,
            style: boutJson['style'] == 'GR' ? WrestlingStyle.greco : WrestlingStyle.free,
            unit: WeightUnit.kilogram,
          );
          try {
            // TODO also search for league weight class first
            final divisionWeightClass = await _getSingleBySyncId<DivisionWeightClass>(
              _getWeightClassOrgSyncId(
                parentOrgSyncId: teamMatch.league!.division.orgSyncId!,
                weightClass: weightClass,
                seasonPartition: teamMatch.seasonPartition ?? 0,
              ),
            );
            weightClass = divisionWeightClass.weightClass;
          } catch (e, st) {
            _logger.severe(
              'The weight class ${weightClass.name} of division ${teamMatch.league!.division.fullname} cannot be found. '
              'This can happen, if the leagues `noOfBoutDays` is incorrect and therefore the weight classes of the current bout day are misconfigured.\n'
              '$e\n'
              '$st',
            );
            return null;
          }

          final homeSyncId = int.tryParse(boutJson['homeWrestlerId'] ?? '');
          final homeMembership =
              homeSyncId == null
                  ? null
                  : await _getMembership(
                    passCode: homeSyncId,
                    getClub: (clubId) async => await _getSingleBySyncId<Club>(clubId),
                  );

          final opponentSyncId = int.tryParse(boutJson['opponentWrestlerId'] ?? '');
          final opponentMembership =
              opponentSyncId == null
                  ? null
                  : await _getMembership(
                    passCode: opponentSyncId,
                    getClub: (clubId) async => await _getSingleBySyncId<Club>(clubId),
                  );

          BoutResult? getBoutResult(String? result) {
            try {
              return switch (result) {
                'PS' => BoutResult.vpo, // Punktesieg
                'PS1' => BoutResult.vpo, // Punktesieg, Verlierer hat Punkte
                'SS' => BoutResult.vfa, // Schultersieg
                'TÜ' => BoutResult.vsu, // Technische Überlegenheit
                'TÜ1' => BoutResult.vsu, // Technische Überlegenheit, Verlierer hat Punkte
                'ÜG' => BoutResult.vfo, // Übergewicht
                'UG' => BoutResult.vfo, // Untergewicht
                'AS' => BoutResult.vin, // Aufgabesieg
                'AS2' => BoutResult.bothVin, // Beide verletzt
                'DV' => BoutResult.vca, // Disqualifikation aufgrund von Regelwidrigkeit
                'KL' => BoutResult.vfo, // Kampfloser Sieger
                'DN' => BoutResult.vfo, // Disqualifikation wegen Nichtantritt
                'DQ' => BoutResult.dsq,
                'DS' => BoutResult.dsq, // Disqualifikation aufgrund von Passivität
                '1M.' => BoutResult.dsq, // Doppelstart
                'o.W.' => BoutResult.bothVfo, // ohne Wertung
                'DQ2' => BoutResult.bothDsq,
                '' => null,
                null => null,
                _ => throw UnimplementedError('The bout result type "$result" is not known in bout $boutJson.'),
              };
            } catch (e, st) {
              _logger.severe('Could not parse bout result $result', e, st);
              rethrow;
            }
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
            orgSyncId: '${teamMatch.orgSyncId}_${weightClass.name}_${weightClass.style.name}'.replaceAll(' ', '_'),
            organization: organization,
            duration: boutDuration,
            result: getBoutResult(boutJson['result']),
            winnerRole: winnerRole,
            r:
                homeMembership == null
                    ? null
                    : AthleteBoutState(classificationPoints: classificationPointsHome, membership: homeMembership),
            b:
                opponentMembership == null
                    ? null
                    : AthleteBoutState(
                      classificationPoints: classificationPointsOpponent,
                      membership: opponentMembership,
                    ),
          );

          BoutAction? parseActionStr(String str) {
            final match = RegExp(r'(\d+|[A-Za-z])([BRbr])(\d*)').firstMatch(str);
            if (match == null) throw Exception('Could not parse action "$str" in bout $boutJson.');
            final actionStr = match.group(1)!; // Group 0 is the whole matched string
            int? pointCount;
            BoutActionType actionType;
            switch (actionStr.toUpperCase()) {
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
              case 'L': // Leg Foul
                actionType = BoutActionType.caution;
              case 'C':
              // TODO: unknown bout action
              // https://www.brv-ringen.de/Api/dev/cs/?op=getCompetition&sid=2023&cid=006108b
              default:
                actionType = BoutActionType.points;
                pointCount = int.tryParse(actionStr);
                if (pointCount == null) {
                  _logger.warning('Action type "$actionStr" could not be parsed: $boutJson. The action is ignored.');
                  return null;
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
          final Iterable<BoutAction> boutActions =
              boutActionsJson.split(',').where((str) => str.isNotEmpty).map((str) {
                try {
                  return parseActionStr(str);
                } catch (e, st) {
                  _logger.severe('Invalid action string format: $str\n$boutJson', e, st);
                  rethrow;
                }
              }).nonNulls;

          // Duration is not available in the new RDB spec, so use the last action as duration.
          if (bout.duration == Duration.zero && boutActions.isNotEmpty) {
            bout = bout.copyWith(duration: boutActions.last.duration);
          }
          final teamMatchBout = TeamMatchBout(
            bout: bout,
            weightClass: weightClass,
            teamMatch: teamMatch,
            organization: organization,
            pos: index,
            orgSyncId: bout.orgSyncId,
          );
          return MapEntry(teamMatchBout, boutActions);
        }),
      );
      return Map.fromEntries(boutActionMapEntries.nonNulls);
    } on Exception catch (e, st) {
      _logger.severe('Could not import bouts from bout list: $boutListJson', e, st);
      rethrow;
    }
  }

  Person _copyPersonWithOrg(Person person) {
    return person.copyWith(
      orgSyncId: '${person.prename}_${person.surname}_${person.birthDate?.toIso8601String().substring(0, 10)}',
      organization: organization,
    );
  }

  @override
  Future<List<DataObject>> search({required String searchStr, required Type searchType}) async {
    switch (searchType) {
      case const (Membership):
        try {
          final membership = await _getMembership(
            passCode: int.parse(searchStr),
            getClub: (clubId) async {
              return await _getSingleBySyncId<Club>(clubId);
            },
          );
          return [membership];
        } catch (_) {
          return [];
        }
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

        final uri = Uri.parse(apiUrl).replace(queryParameters: {'op': 'listClub'});

        String body;
        if (!isMock) {
          _logger.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode >= 400) {
            throw HttpException('Failed to get the season list', response: response);
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

        final uri = Uri.parse(apiUrl).replace(queryParameters: {'op': 'listSaison'});

        String body;
        if (!isMock) {
          _logger.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode >= 400) {
            throw HttpException('Failed to get the saison list', response: response);
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
  Future<Map<String, dynamic>> _getLeagueList({String? seasonId}) async {
    seasonId ??= MockableDateTime.now().year.toString();
    final cacheId = 's:$seasonId';
    return await runSynchronized(
      key: 'getLeagueList_$cacheId',
      canAbort: () => cachedLeagueList[cacheId] != null,
      runAsync: () async {
        if (cachedLeagueList[cacheId] != null) return cachedLeagueList[cacheId]!;
        final uri = Uri.parse(apiUrl).replace(queryParameters: {'op': 'listLiga', 'sid': seasonId});
        String body;
        if (!isMock) {
          _logger.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode >= 400) {
            throw HttpException('Failed to get the liga list (seasonId: $seasonId)', response: response);
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
        final uri = Uri.parse(apiUrl).replace(
          queryParameters: {
            'op': 'listCompetition',
            'sid': seasonId,
            'ligaId': ligaId,
            // Replace total region name with empty
            'rid': regionId == totalRegionWildcard ? '' : regionId,
          },
        );

        String body;
        if (!isMock) {
          _logger.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode >= 400) {
            throw HttpException(
              'Failed to get the competition list (seasonId: $seasonId, ligaId: $ligaId, rid: $regionId)',
              response: response,
            );
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

  Future<Map<String, dynamic>> _getCompetition({required String seasonId, required String competitionId}) async {
    final cacheId = 's:$seasonId,c:$competitionId';
    return await runSynchronized(
      key: 'getCompetition_$cacheId',
      canAbort: () => cachedCompetitions[cacheId] != null,
      runAsync: () async {
        if (cachedCompetitions[cacheId] != null) return cachedCompetitions[cacheId]!;

        final uri = Uri.parse(
          apiUrl,
        ).replace(queryParameters: {'op': 'getCompetition', 'sid': seasonId, 'cid': competitionId});

        String body;
        if (!isMock) {
          _logger.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode >= 400) {
            throw HttpException(
              'Failed to get the competition (seasonId: $seasonId, competitionId: $competitionId)',
              response: response,
            );
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

  Future<Map<String, dynamic>> _getSaisonWrestler({required int passCode}) async {
    final cacheId = 'p:$passCode';
    return await runSynchronized(
      key: 'getSaisonWrestler_$cacheId',
      canAbort: () => cachedWrestlers[cacheId] != null,
      runAsync: () async {
        if (cachedWrestlers[cacheId] != null) return cachedWrestlers[cacheId]!;
        final uri = Uri.parse(
          apiUrl,
        ).replace(queryParameters: {'op': 'getSaisonWrestler', 'passcode': passCode.toString()});

        String? body;
        if (!isMock) {
          _logger.fine('Call API: $uri');
          final response = await retry(runAsync: () => http.get(uri, headers: authService?.header));
          if (response.statusCode >= 400) {
            throw HttpException('Failed to get the wrestler (passcode: $passCode)', response: response);
          }
          body = response.body;
        } else {
          body = getWrestlerJson(passCode);
        }
        if (body == null) {
          throw Exception('Response for the wrestler (passcode: $passCode) was null.');
        }
        cachedWrestlers[cacheId] = jsonDecode(body);
        return cachedWrestlers[cacheId]!;
      },
    );
  }
}
