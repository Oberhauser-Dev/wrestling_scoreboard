import 'package:collection/collection.dart';
import 'package:country/country.dart';
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'shared.dart';

void main() {
  late WrestlingApi wrestlingApi;
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);

  final testDivisionJunior = Division(
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

  final testBezirksligaGrenzlandligaLeague = League(
    name: 'Grenzlandliga',
    startDate: testDivisionJunior.startDate,
    endDate: testDivisionJunior.endDate,
    division: testDivisionJunior,
    boutDays: 14,
    organization: organizationNRW,
    orgSyncId: '2023_(S) Bezirksliga_Grenzlandliga',
  );

  final testBayerligaSuedLeague = League(
    name: 'Süd',
    startDate: testDivisionJunior.startDate,
    endDate: testDivisionJunior.endDate,
    division: testDivisionBayernliga,
    boutDays: 14,
    organization: organizationNRW,
    orgSyncId: '2023_Bayernliga_Süd',
  );

  final testClubGeiselhoering =
      Club(name: 'TV Geiselhöring', organization: organizationNRW, orgSyncId: '20178', no: '20178');
  final testClubUntergriesbach =
      Club(name: 'SV Untergriesbach', organization: organizationNRW, orgSyncId: '20696', no: '20696');
  final testClubBerchtesgaden =
      Club(name: 'TSV Berchtesgaden', organization: organizationNRW, orgSyncId: '10142', no: '10142');

  final testMembership = Membership(
    no: '1234',
    orgSyncId: '20696-1234',
    organization: organizationNRW,
    club: testClubUntergriesbach,
    person: Person(
      orgSyncId: 'Max_Muster_2000-01-31',
      organization: organizationNRW,
      prename: 'Max',
      surname: 'Muster',
      gender: Gender.male,
      birthDate: DateTime(2000, 1, 31),
      nationality: Countries.deu,
    ),
  );

  final testLineupUntergriesbach = Lineup(
    team: Team(
        name: 'SV Untergriesbach',
        club: testClubUntergriesbach,
        organization: organizationNRW,
        orgSyncId: 'SV Untergriesbach'),
  );

  final testLineupBerchtesgaden = Lineup(
    team: Team(
      orgSyncId: 'TSV Berchtesgaden',
      organization: organizationNRW,
      name: 'TSV Berchtesgaden',
      club: testClubBerchtesgaden,
      description: null,
    ),
    leader: null,
    coach: null,
  );

  final testTeamMatch = TeamMatch(
    league: testBayerligaSuedLeague,
    no: '005029c',
    orgSyncId: '005029c',
    seasonPartition: 1,
    organization: organizationNRW,
    comment: 'Verspäteter Beginn aufgrund Vorkämpfe',
    home: testLineupUntergriesbach,
    guest: testLineupBerchtesgaden,
    date: DateTime(2023, 10, 28, 19),
    visitorsCount: 295,
    location: 'Verbandsschulturnhalle, Passauerstr. 47, 94107 Untergriesbach',
    referee: Person(
      prename: 'Mustafa',
      surname: 'Durak',
      orgSyncId: 'Mustafa_Durak_null',
      organization: organizationNRW,
    ),
  );

  setUp(() {
    wrestlingApi = WrestlingApiProvider.deNwRingenApi.getApi(
      organizationNRW,
      authService: BasicAuthService(username: '', password: ''),
      getSingleOfOrg: <T extends Organizational>(String orgSyncId, {required int orgId}) async {
        switch (T) {
          case const (Club):
            return (await wrestlingApi.importClubs()).singleWhere((club) => club.orgSyncId == orgSyncId) as T;
          case const (Team):
            final clubs = await wrestlingApi.importClubs();
            for (final club in clubs) {
              final teams = await wrestlingApi.importTeams(club: club);
              final team = teams.singleWhereOrNull((t) => t.orgSyncId == orgSyncId);
              if (team != null) {
                return team as T;
              }
            }
            throw 'Type $T with orgSyncId $orgSyncId not found';
          case const (DivisionWeightClass):
            final divisions = await wrestlingApi.importDivisions(minDate: DateTime.utc(2023));
            final weightClasses = (await Future.wait(
                    divisions.map((division) => wrestlingApi.importDivisionWeightClasses(division: division))))
                .expand((w) => w);
            return weightClasses.singleWhere((w) => w.orgSyncId == orgSyncId) as T;
          default:
            throw UnimplementedError('Type $T with orgSyncId $orgSyncId not found');
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
          testDivisionJunior,
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
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_57_kg_free_0',
          ),
          DivisionWeightClass(
            pos: 1,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 130, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_130_kg_greco_0',
          ),
          DivisionWeightClass(
            pos: 2,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 61, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_61_kg_greco_0',
          ),
          DivisionWeightClass(
            pos: 3,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 98, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_98_kg_free_0',
          ),
          DivisionWeightClass(
            pos: 4,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 66, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_66_kg_free_0',
          ),
          DivisionWeightClass(
            pos: 5,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 86, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_86_kg_greco_0',
          ),
          DivisionWeightClass(
            pos: 6,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 71, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_71_kg_greco_0',
          ),
          DivisionWeightClass(
            pos: 7,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 80, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_80_kg_free_0',
          ),
          DivisionWeightClass(
            pos: 8,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 75, suffix: 'A', unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_75_kg_A_free_0',
          ),
          DivisionWeightClass(
            pos: 9,
            seasonPartition: 0,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 75, suffix: 'B', unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_75_kg_B_greco_0',
          ),
          // Season partition 2
          DivisionWeightClass(
            pos: 0,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 57, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_57_kg_greco_1',
          ),
          DivisionWeightClass(
            pos: 1,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 130, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_130_kg_free_1',
          ),
          DivisionWeightClass(
            pos: 2,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 61, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_61_kg_free_1',
          ),
          DivisionWeightClass(
            pos: 3,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 98, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_98_kg_greco_1',
          ),
          DivisionWeightClass(
            pos: 4,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 66, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_66_kg_greco_1',
          ),
          DivisionWeightClass(
            pos: 5,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 86, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_86_kg_free_1',
          ),
          DivisionWeightClass(
            pos: 6,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 71, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_71_kg_free_1',
          ),
          DivisionWeightClass(
            pos: 7,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 80, suffix: null, unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_80_kg_greco_1',
          ),
          DivisionWeightClass(
            pos: 8,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.greco, weight: 75, suffix: 'A', unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_75_kg_A_greco_1',
          ),
          DivisionWeightClass(
            pos: 9,
            seasonPartition: 1,
            division: testDivisionBayernliga,
            weightClass: WeightClass(style: WrestlingStyle.free, weight: 75, suffix: 'B', unit: WeightUnit.kilogram),
            organization: organizationNRW,
            orgSyncId: '2023_Bayernliga_75_kg_B_free_1',
          ),
        ]);
      });

      test('Leagues', () async {
        final leagues = await wrestlingApi.importLeagues(division: testDivisionJunior);
        expect(leagues, [
          testBezirksligaGrenzlandligaLeague,
          League(
            name: 'Mittelfranken',
            startDate: testDivisionJunior.startDate,
            endDate: testDivisionJunior.endDate,
            division: testDivisionJunior,
            boutDays: 16,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Mittelfranken',
          ),
          League(
            name: 'Niederbayern/Oberpfalz',
            startDate: testDivisionJunior.startDate,
            endDate: testDivisionJunior.endDate,
            division: testDivisionJunior,
            boutDays: 14,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Niederbayern/Oberpfalz',
          ),
          League(
            name: 'Oberbayern/Schwaben Gr. A',
            startDate: testDivisionJunior.startDate,
            endDate: testDivisionJunior.endDate,
            division: testDivisionJunior,
            boutDays: 14,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Oberbayern/Schwaben Gr. A',
          ),
          League(
            name: 'Oberbayern/Schwaben Gr. B',
            startDate: testDivisionJunior.startDate,
            endDate: testDivisionJunior.endDate,
            division: testDivisionJunior,
            boutDays: 14,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Bezirksliga_Oberbayern/Schwaben Gr. B',
          ),
        ]);
      });

      test('Clubs', () async {
        final clubs = await wrestlingApi.importClubs();
        expect(clubs, [
          Club(name: 'RG Willmering', organization: organizationNRW, orgSyncId: '30525', no: '30525'),
          Club(name: 'ASV Cham', organization: organizationNRW, orgSyncId: '30074', no: '30074'),
          Club(name: 'TV Geiselhöring', organization: organizationNRW, orgSyncId: '20178', no: '20178'),
          Club(name: 'TSV Westendorf', organization: organizationNRW, orgSyncId: '70824', no: '70824'),
          Club(name: 'ASV Au-Hallertau', organization: organizationNRW, orgSyncId: '12173', no: '12173'),
          Club(name: 'RSC Rehau', organization: organizationNRW, orgSyncId: '40666', no: '40666'),
          Club(name: 'TV 1862 Unterdürrbach', organization: organizationNRW, orgSyncId: '60915', no: '60915'),
          Club(name: 'ASV Hof', organization: organizationNRW, orgSyncId: '40352', no: '40352'),
          Club(name: 'TSV 1860 Weißenburg', organization: organizationNRW, orgSyncId: '50680', no: '50680'),
          Club(name: 'TSV Zirndorf', organization: organizationNRW, orgSyncId: '50020', no: '50020'),
          Club(name: 'AC Lichtenfels', organization: organizationNRW, orgSyncId: '40467', no: '40467'),
          Club(name: 'ASC Bindlach', organization: organizationNRW, orgSyncId: '41515', no: '41515'),
          Club(name: 'SpVgg Freising', organization: organizationNRW, orgSyncId: '10339', no: '10339'),
          Club(name: 'SC Oberölsbach', organization: organizationNRW, orgSyncId: '30505', no: '30505'),
          Club(name: 'TV Erlangen', organization: organizationNRW, orgSyncId: '50132', no: '50132'),
          Club(name: 'ASV Neumarkt/Opf.', organization: organizationNRW, orgSyncId: '30285', no: '30285'),
          Club(name: 'TSC Mering', organization: organizationNRW, orgSyncId: '70434', no: '70434'),
          Club(name: 'TV Traunstein', organization: organizationNRW, orgSyncId: '11564', no: '11564'),
          Club(name: 'AC Bad Reichenhall', organization: organizationNRW, orgSyncId: '10095', no: '10095'),
          Club(name: 'TSV Trostberg', organization: organizationNRW, orgSyncId: '11567', no: '11567'),
          Club(name: 'SC Isaria Unterföhring', organization: organizationNRW, orgSyncId: '11592', no: '11592'),
          Club(name: 'AC Penzberg', organization: organizationNRW, orgSyncId: '11270', no: '11270'),
          Club(name: 'RSV Schonungen', organization: organizationNRW, orgSyncId: '61941', no: '61941'),
          Club(name: 'SV Wacker Burghausen', organization: organizationNRW, orgSyncId: '10191', no: '10191'),
          Club(name: 'SV Johannis Nürnberg', organization: organizationNRW, orgSyncId: '50495', no: '50495'),
          Club(name: 'SV Siegfried Hallbergmoos', organization: organizationNRW, orgSyncId: '10862', no: '10862'),
          Club(name: 'SV Mietraching', organization: organizationNRW, orgSyncId: '20371', no: '20371'),
          Club(name: 'SC 04 Nürnberg', organization: organizationNRW, orgSyncId: '50359', no: '50359'),
          Club(name: 'SC Anger', organization: organizationNRW, orgSyncId: '10047', no: '10047'),
          Club(name: 'TSV Berchtesgaden', organization: organizationNRW, orgSyncId: '10142', no: '10142'),
          Club(name: 'TSV Aichach', organization: organizationNRW, orgSyncId: '70008', no: '70008'),
          Club(name: 'ESV München-Ost', organization: organizationNRW, orgSyncId: '10797', no: '10797'),
          Club(name: 'AC Regensburg', organization: organizationNRW, orgSyncId: '30377', no: '30377'),
          Club(name: 'TSV Burgebrach', organization: organizationNRW, orgSyncId: '40138', no: '40138'),
          Club(name: 'WKG Marktleugast/Bamberg', organization: organizationNRW, orgSyncId: '40200', no: '40200'),
          Club(name: 'ATSV Kelheim', organization: organizationNRW, orgSyncId: '20283', no: '20283'),
          Club(name: 'TSV Sankt Wolfgang', organization: organizationNRW, orgSyncId: '11472', no: '11472'),
          Club(name: 'RSC Marktleugast', organization: organizationNRW, orgSyncId: '40495', no: '40495'),
          Club(name: 'TV Miesbach', organization: organizationNRW, orgSyncId: '10858', no: '10858'),
          Club(name: 'TSV Kottern', organization: organizationNRW, orgSyncId: '70690', no: '70690'),
          Club(name: 'TSG Augsburg', organization: organizationNRW, orgSyncId: '70043', no: '70043'),
          Club(name: 'SV 29 Kempten', organization: organizationNRW, orgSyncId: '70415', no: '70415'),
          Club(name: 'TSV Diedorf', organization: organizationNRW, orgSyncId: '70195', no: '70195'),
          Club(name: 'TV Feldkirchen', organization: organizationNRW, orgSyncId: '10312', no: '10312'),
          Club(name: 'SG Moosburg', organization: organizationNRW, orgSyncId: '10888', no: '10888'),
          Club(name: 'RC Bergsteig Amberg', organization: organizationNRW, orgSyncId: '30016', no: '30016'),
          Club(name: 'SV Untergriesbach', organization: organizationNRW, orgSyncId: '20696', no: '20696'),
          Club(name: 'TBVfL Neustadt / Wildenheid', organization: organizationNRW, orgSyncId: '40584', no: '40584'),
          Club(name: 'RCA Bayreuth', organization: organizationNRW, orgSyncId: '41716', no: '41716'),
          Club(name: 'ASC Röthenbach', organization: organizationNRW, orgSyncId: '50539', no: '50539'),
          Club(name: 'KSV Bamberg', organization: organizationNRW, orgSyncId: '40061', no: '40061'),
          Club(name: 'TSV Feucht', organization: organizationNRW, orgSyncId: '50168', no: '50168'),
          Club(name: 'TSV Cadolzburg', organization: organizationNRW, orgSyncId: '50082', no: '50082'),
          Club(name: 'DJK Pfersee', organization: organizationNRW, orgSyncId: '71264', no: '71264'),
          Club(name: 'TSV 1860 München', organization: organizationNRW, orgSyncId: '11016', no: '11016'),
          Club(name: 'AC Wals', organization: organizationNRW, orgSyncId: 'e1', no: 'e1'),
          Club(name: 'Olympic Salzburg', organization: organizationNRW, orgSyncId: 'e2', no: 'e2'),
          Club(name: 'KG Vigaun/Abtenau', organization: organizationNRW, orgSyncId: 'e3', no: 'e3'),
          Club(name: 'TSV Sulzberg e.V.', organization: organizationNRW, orgSyncId: '70748', no: '70748'),
          Club(name: 'AVJC Zella-Mehlis', organization: organizationNRW, orgSyncId: '4', no: '4'),
          Club(name: 'SVJk 03 Albrechts', organization: organizationNRW, orgSyncId: '5', no: '5'),
          Club(name: 'AC Forchheim', organization: organizationNRW, orgSyncId: '40133', no: '40133'),
          Club(name: 'KG Südthüringen', organization: organizationNRW, orgSyncId: 'e4', no: 'e4'),
          Club(name: 'RC Bergsteig Amberg', organization: organizationNRW, orgSyncId: '31437', no: '31437'),
          Club(name: 'KSV Hof', organization: organizationNRW, orgSyncId: '41901', no: '41901'),
          Club(name: 'TSV Weilheim', organization: organizationNRW, orgSyncId: '11663', no: '11663'),
        ]);
      });

      test('Memberships', () async {
        final memberships = await wrestlingApi.importMemberships(club: testClubUntergriesbach);
        expect(memberships, {testMembership});
      });

      test('Teams', () async {
        final teams = await wrestlingApi.importTeams(club: testClubGeiselhoering);
        expect(teams, [
          Team(
              name: 'TV Geiselhöring',
              club: testClubGeiselhoering,
              orgSyncId: 'TV Geiselhöring',
              organization: organizationNRW),
          Team(
              name: 'S - TV Geiselhöring',
              club: testClubGeiselhoering,
              orgSyncId: 'S - TV Geiselhöring',
              organization: organizationNRW),
          Team(
              name: 'TV Geiselhöring II',
              club: testClubGeiselhoering,
              orgSyncId: 'TV Geiselhöring II',
              organization: organizationNRW),
        ]);
      });

      test('TeamMatches', () async {
        final teamMatches = await wrestlingApi.importTeamMatches(league: testBayerligaSuedLeague);
        expect(teamMatches, [
          testTeamMatch,
          TeamMatch(
              orgSyncId: '029013c',
              no: '029013c',
              organization: organizationNRW,
              home: testLineupBerchtesgaden,
              guest: Lineup(
                  team: Team(
                      orgSyncId: 'TSC Mering',
                      organization: organizationNRW,
                      name: 'TSC Mering',
                      club: Club(orgSyncId: '70434', organization: organizationNRW, name: 'TSC Mering', no: '70434'),
                      description: null),
                  leader: null,
                  coach: null),
              league: testBayerligaSuedLeague,
              seasonPartition: 0,
              matChairman: null,
              referee: Person(
                  id: null,
                  orgSyncId: 'Fröhlich_Peter_null',
                  organization: organizationNRW,
                  prename: 'Fröhlich',
                  surname: 'Peter',
                  gender: null,
                  birthDate: null,
                  nationality: null),
              judge: null,
              timeKeeper: null,
              transcriptWriter: null,
              location: 'Kongresshaus Berchtesgaden, Maximilianstr. 9, 83471 Berchtesgaden',
              date: DateTime(2023, 10, 21, 19),
              visitorsCount: 813,
              comment: 'TSV BGD 57kg übergewicht'),
        ]);
      });

      test('TeamMatch Bouts', () async {
        final bouts = await wrestlingApi.importBouts(event: testTeamMatch);
        final weightClass = WeightClass(
          weight: 61,
          style: WrestlingStyle.free,
          suffix: null,
          unit: WeightUnit.kilogram,
        );
        // TODO: Evaluate this bout: https://www.brv-ringen.de/index.php?option=com_rdb&view=rdb&Itemid=512&tk=cs&sid=2023&yid=M&menu=1&op=lc&lid=Bayernliga&cntl=Ergebnisse&from=ll&cid=005029c
        // Why activity and passivity at different times, or points at different times?
        final expectedBout = Bout(
          orgSyncId: '005029c_61_kg',
          duration: Duration(minutes: 6),
          result: BoutResult.vpo,
          weightClass: weightClass,
          winnerRole: BoutRole.blue,
          pool: null,
          organization: organizationNRW,
          r: ParticipantState(
            classificationPoints: 0,
            participation: Participation(
              membership: testMembership,
              lineup: testLineupUntergriesbach,
              weight: null,
              weightClass: weightClass,
            ),
          ),
          b: ParticipantState(
            classificationPoints: 1,
            participation: Participation(
              membership: Membership(
                no: '4321',
                orgSyncId: '10142-4321',
                organization: organizationNRW,
                club: testClubBerchtesgaden,
                person: Person(
                  orgSyncId: 'Tobias_Müller_2000-03-02',
                  organization: organizationNRW,
                  prename: 'Tobias',
                  surname: 'Müller',
                  gender: Gender.male,
                  birthDate: DateTime(2000, 3, 02),
                  nationality: Countries.deu,
                ),
              ),
              lineup: testLineupBerchtesgaden,
              weight: null,
              weightClass: weightClass,
            ),
          ),
        );
        // "2R26,2B37,PB98,AB124,1R156,PR252,AR292,1B326,1R337,AB360,2B360"
        expect(bouts, <Bout, Iterable<BoutAction>>{
          expectedBout: <BoutAction>[
            BoutAction(
                role: BoutRole.red,
                actionType: BoutActionType.points,
                duration: Duration(seconds: 26),
                pointCount: 2,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.blue,
                actionType: BoutActionType.points,
                duration: Duration(seconds: 37),
                pointCount: 2,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.blue,
                actionType: BoutActionType.verbal,
                duration: Duration(seconds: 98),
                pointCount: null,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.blue,
                actionType: BoutActionType.passivity,
                duration: Duration(seconds: 124),
                pointCount: null,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.red,
                actionType: BoutActionType.points,
                duration: Duration(seconds: 156),
                pointCount: 1,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.red,
                actionType: BoutActionType.verbal,
                duration: Duration(seconds: 252),
                pointCount: null,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.red,
                actionType: BoutActionType.passivity,
                duration: Duration(seconds: 292),
                pointCount: null,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.blue,
                actionType: BoutActionType.points,
                duration: Duration(seconds: 326),
                pointCount: 1,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.red,
                actionType: BoutActionType.points,
                duration: Duration(seconds: 337),
                pointCount: 1,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.blue,
                actionType: BoutActionType.passivity,
                duration: Duration(seconds: 360),
                pointCount: null,
                bout: expectedBout),
            BoutAction(
                role: BoutRole.blue,
                actionType: BoutActionType.points,
                duration: Duration(seconds: 360),
                pointCount: 2,
                bout: expectedBout),
          ],
        });
      });
    });
  });
}
