import 'package:country/country.dart';
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'shared.dart';

void main() {
  late WrestlingApi wrestlingApi;
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);

  final testDivision = Division(
    name: '(S) Bezirksliga',
    startDate: DateTime.utc(2023),
    endDate: DateTime.utc(2024),
    boutConfig: BoutConfig(),
    seasonPartitions: 2,
    organization: organizationNRW,
    orgSyncId: '2023_(S) Bezirksliga',
  );

  final testDivisionBayernliga = Division(
    name: 'Bayernliga',
    startDate: DateTime.utc(2023),
    endDate: DateTime.utc(2024),
    boutConfig: BoutConfig(),
    seasonPartitions: 2,
    organization: organizationNRW,
    orgSyncId: '2023_Bayernliga',
  );

  final testLeague = League(
    name: 'Grenzlandliga',
    startDate: testDivision.startDate,
    endDate: testDivision.endDate,
    division: testDivision,
    organization: organizationNRW,
    orgSyncId: '2023_(S) Bezirksliga_Grenzlandliga',
  );

  final testClub = Club(name: 'TV Geiselhöring II', organization: organizationNRW, orgSyncId: 'TV Geiselhöring II');

  setUp(() {
    wrestlingApi = WrestlingApiProvider.deNwRingenApi.getApi(
      organizationNRW,
      authService: BasicAuthService(username: '', password: ''),
      getSingleOfOrg: <T extends DataObject>(String orgSyncId, {required int orgId}) async {
        switch (T) {
          case const (Club):
            return Club(name: orgSyncId, organization: organizationNRW, orgSyncId: orgSyncId) as T;
          case const (Team):
            return Team(
              name: orgSyncId,
              club: Club(name: orgSyncId, organization: organizationNRW, orgSyncId: orgSyncId),
              orgSyncId: orgSyncId,
              organization: organizationNRW,
            ) as T;
          default:
            throw UnimplementedError();
        }
      },
    );
    wrestlingApi.isMock = true;
  });

  group('APIs', () {
    group('Germany, NRW', () {
      test('Divisions', () async {
        final divisions = await wrestlingApi.importDivisions(minDate: DateTime.utc(2023));
        expect(divisions, [
          testDivision,
          Division(
            name: '(S) Finalrunde',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: BoutConfig(),
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Finalrunde',
          ),
          testDivisionBayernliga,
          Division(
            name: 'Gruppenoberliga',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: BoutConfig(),
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_Gruppenoberliga',
          ),
          Division(
            name: 'Landesliga',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: BoutConfig(),
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_Landesliga',
          ),
          Division(
            name: 'Oberliga',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: BoutConfig(),
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_Oberliga',
          ),
        ]);
      });

      test('DivisionWeightClasses', () async {
        final divisionWeightClasses = await wrestlingApi.importDivisionWeightClasses(division: testDivisionBayernliga);
        expect(divisionWeightClasses, [
          // Season partition 1
          DivisionWeightClass(
            pos: 0,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 57, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 1,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 130, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 2,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 61, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 3,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 98, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 4,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 66, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 5,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 86, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 6,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 71, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 7,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 80, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 8,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 75, suffix: 'A', unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 9,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 75, suffix: 'B', unit: WeightUnit.kilogram),
          ),
          // Season partition 2
          DivisionWeightClass(
            pos: 0,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 57, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 1,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 130, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 2,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 61, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 3,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 98, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 4,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 66, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 5,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 86, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 6,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 71, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 7,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 80, suffix: null, unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 8,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 75, suffix: 'A', unit: WeightUnit.kilogram),
          ),
          DivisionWeightClass(
            pos: 9,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 75, suffix: 'B', unit: WeightUnit.kilogram),
          ),
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
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Mittelfranken',
          ),
          League(
            name: 'Niederbayern/Oberpfalz',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Niederbayern/Oberpfalz',
          ),
          League(
            name: 'Oberbayern/Schwaben Gr. A',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Oberbayern/Schwaben Gr. A',
          ),
          League(
            name: 'Oberbayern/Schwaben Gr. B',
            startDate: testDivision.startDate,
            endDate: testDivision.endDate,
            division: testDivision,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Oberbayern/Schwaben Gr. B',
          ),
        ]);
      });

      test('Clubs', () async {
        final clubs = await wrestlingApi.importClubs();
        expect(clubs, [
          testClub,
          Club(name: 'AC Bad Reichenhall', organization: organizationNRW, orgSyncId: 'AC Bad Reichenhall'),
          Club(name: 'TV Feldkirchen', organization: organizationNRW, orgSyncId: 'TV Feldkirchen'),
        ]);
      });

      // TODO: enable when endpoint for clubs is available.
      test('Memberships', () async {
        final memberships = await wrestlingApi.importMemberships(club: testClub);
        expect(memberships, {
          Membership(
            no: '1234',
            orgSyncId: '11472-1234',
            organization: organizationNRW,
            club: testClub,
            person: Person(
              orgSyncId: 'Max_Muster_2000-01-31',
              organization: organizationNRW,
              prename: 'Max',
              surname: 'Muster',
              gender: Gender.male,
              birthDate: DateTime(2000, 1, 31),
              nationality: Countries.deu,
            ),
          ),
        });
      });

      test('Teams', () async {
        final teams = await wrestlingApi.importTeams(club: testClub);
        expect(teams, [
          Team(
            name: 'TV Geiselhöring II',
            club: testClub,
            orgSyncId: 'TV Geiselhöring II',
            organization: organizationNRW,
          ),
        ]);
      });

      test('TeamMatches', () async {
        final teamMatches = await wrestlingApi.importTeamMatches(league: testLeague);
        expect(teamMatches, [
          TeamMatch(
            home: Lineup(
              team: Team(
                  name: 'TV Geiselhöring II',
                  club: testClub,
                  organization: organizationNRW,
                  orgSyncId: 'TV Geiselhöring II'),
            ),
            guest: Lineup(
              team: Team(
                name: 'TV Feldkirchen',
                club: Club(name: 'TV Feldkirchen', organization: organizationNRW, orgSyncId: 'TV Feldkirchen'),
                orgSyncId: 'TV Feldkirchen',
                organization: organizationNRW,
              ),
            ),
            date: DateTime(2023, 9, 25, 17, 45),
            visitorsCount: 100,
            location: 'Geiselhöringer Hof, Straubinger Str. 5, 94333 Geiselhöring',
            referee: Person(
              prename: 'Johannes',
              surname: 'Unparteiisch',
              orgSyncId: 'Johannes_Unparteiisch_null',
              organization: organizationNRW,
            ),
            comment: 'fair',
            league: testLeague,
            no: '106109j',
            seasonPartition: 1,
            organization: organizationNRW,
            orgSyncId: '106109j',
          ),
          TeamMatch(
            home: Lineup(
              team: Team(
                name: 'AC Bad Reichenhall',
                club: Club(name: 'AC Bad Reichenhall', organization: organizationNRW, orgSyncId: 'AC Bad Reichenhall'),
                orgSyncId: 'AC Bad Reichenhall',
                organization: organizationNRW,
              ),
            ),
            guest: Lineup(
              team: Team(
                  name: 'TV Geiselhöring II',
                  club: testClub,
                  organization: organizationNRW,
                  orgSyncId: 'TV Geiselhöring II'),
            ),
            date: DateTime(2023, 10, 02, 19),
            visitorsCount: null,
            location: 'Mehrzweckturnhalle in Karlstein, Schmalschlägerstr. 5, 83435 Bad Reichenhall / Karlstein',
            referee: null,
            comment: 'AC 57, 61 kg unbesetzt, TVGII 98,130kg unbesetzt',
            league: testLeague,
            no: '035106j',
            seasonPartition: 1,
            organization: organizationNRW,
            orgSyncId: '035106j',
          ),
        ]);
      });
    });
  });
}
