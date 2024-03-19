import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'shared.dart';

void main() {
  late WrestlingApi wrestlingApi;

  final testDivision = Division(
    name: '(S) Bezirksliga',
    startDate: DateTime(2021),
    endDate: DateTime(2022),
    boutConfig: BoutConfig(),
    seasonPartitions: 2,
    organization: organizationNRW,
  );

  final testLeague = League(
    name: 'Grenzlandliga',
    startDate: testDivision.startDate,
    endDate: testDivision.endDate,
    division: testDivision,
  );

  final testClub = Club(name: 'TV Geiselhöring II', organization: organizationNRW);

  setUp(() {
    wrestlingApi = WrestlingApiProvider.deNwRingenApi.getApi(organizationNRW,
        getSingle: <T extends DataObject>(String providerId) async {
      switch (T) {
        case const (Club):
          return Club(name: providerId, organization: organizationNRW) as T;
        case const (Team):
          return Team(name: providerId, club: Club(name: providerId, organization: organizationNRW)) as T;
        default:
          throw UnimplementedError();
      }
    });
    wrestlingApi.isMock = true;
  });

  group('APIs', () {
    group('Germany, NRW', () {
      test('Divisions', () async {
        final divisions = await wrestlingApi.importDivisions(minDate: DateTime(2023));
        expect(divisions, [
          testDivision,
          Division(
              name: '(S) Finalrunde',
              startDate: DateTime(2021),
              endDate: DateTime(2022),
              boutConfig: BoutConfig(),
              seasonPartitions: 2,
              organization: organizationNRW),
          Division(
              name: 'Bayernliga',
              startDate: DateTime(2021),
              endDate: DateTime(2022),
              boutConfig: BoutConfig(),
              seasonPartitions: 2,
              organization: organizationNRW),
          Division(
              name: 'Gruppenoberliga',
              startDate: DateTime(2021),
              endDate: DateTime(2022),
              boutConfig: BoutConfig(),
              seasonPartitions: 2,
              organization: organizationNRW),
          Division(
              name: 'Landesliga',
              startDate: DateTime(2021),
              endDate: DateTime(2022),
              boutConfig: BoutConfig(),
              seasonPartitions: 2,
              organization: organizationNRW),
          Division(
              name: 'Oberliga',
              startDate: DateTime(2021),
              endDate: DateTime(2022),
              boutConfig: BoutConfig(),
              seasonPartitions: 2,
              organization: organizationNRW),
        ]);
      });

      test('Leagues', () async {
        final leagues = await wrestlingApi.importLeagues(division: testDivision);
        expect(leagues, [
          testLeague,
          League(
            name: 'Mittelfranken',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
          ),
          League(
            name: 'Niederbayern/Oberpfalz',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
          ),
          League(
            name: 'Oberbayern/Schwaben Gr. A',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
          ),
          League(
            name: 'Oberbayern/Schwaben Gr. B',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
          ),
        ]);
      });

      test('Clubs', () async {
        final clubs = await wrestlingApi.importClubs();
        expect(clubs, [
          testClub,
          Club(name: 'AC Bad Reichenhall', organization: organizationNRW),
          Club(name: 'TSV Trostberg', organization: organizationNRW),
          Club(name: 'TV Feldkirchen', organization: organizationNRW),
        ]);
      });

      test('Teams', () async {
        final teams = await wrestlingApi.importTeams(club: testClub);
        expect(teams, [
          Team(name: 'TV Geiselhöring II', club: testClub),
        ]);
      });

      test('TeamMatches', () async {
        final teamMatches = await wrestlingApi.importTeamMatches(league: testLeague);
        expect(teamMatches, [
          TeamMatch(
            home: Lineup(
              team: Team(name: 'TV Geiselhöring II', club: testClub),
            ),
            guest: Lineup(
              team: Team(name: 'TV Feldkirchen', club: Club(name: 'TV Feldkirchen', organization: organizationNRW)),
            ),
            date: DateTime(2021, 9, 25, 17, 45),
            visitorsCount: 100,
            location: 'Geiselhöringer Hof, Straubinger Str. 5, 94333 Geiselhöring',
            referee: Person(prename: 'Johannes', surname: 'Steinberger'),
            comment: 'fair',
            league: testLeague,
            no: '106109j',
            seasonPartition: 1,
          ),
          TeamMatch(
            home: Lineup(
              team: Team(
                  name: 'AC Bad Reichenhall', club: Club(name: 'AC Bad Reichenhall', organization: organizationNRW)),
            ),
            guest: Lineup(
              team: Team(name: 'TV Geiselhöring II', club: testClub),
            ),
            date: DateTime(2021, 10, 02, 19),
            visitorsCount: null,
            location: 'Mehrzweckturnhalle in Karlstein, Schmalschlägerstr. 5, 83435 Bad Reichenhall / Karlstein',
            referee: Person(prename: '', surname: ''),
            comment: 'AC 57, 61 kg unbesetzt, TVGII 98,130kg unbesetzt',
            league: testLeague,
            no: '035106j',
            seasonPartition: 1,
          ),
        ]);
      });
    });
  });
}
