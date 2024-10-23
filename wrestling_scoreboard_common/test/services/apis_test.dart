import 'package:country/country.dart';
import 'package:test/test.dart';
import 'package:wrestling_scoreboard_common/common.dart';

import 'shared.dart';

void main() {
  late WrestlingApi wrestlingApi;
  MockableDateTime.isMocked = true;
  MockableDateTime.mockedDateTime = DateTime.utc(2024, 01, 02);

  BoutConfig getAdultBoutConfig() => const BoutConfig(
        periodDuration: Duration(minutes: 3),
        periodCount: 2,
        breakDuration: Duration(seconds: 30),
        activityDuration: Duration(seconds: 30),
        injuryDuration: Duration(minutes: 2),
        bleedingInjuryDuration: Duration(minutes: 4),
      );
  BoutConfig getYouthBoutConfig() => const BoutConfig(
        periodDuration: Duration(minutes: 2),
        periodCount: 2,
        breakDuration: Duration(seconds: 30),
        activityDuration: Duration(seconds: 30),
        injuryDuration: Duration(minutes: 2),
        bleedingInjuryDuration: Duration(minutes: 4),
      );

  final testDivisionJunior = Division(
    name: '(S) Bezirksliga',
    startDate: DateTime.utc(2023),
    endDate: DateTime.utc(2024),
    boutConfig: getYouthBoutConfig(),
    seasonPartitions: 2,
    organization: organizationNRW,
    orgSyncId: '2023_(S) Bezirksliga',
  );

  final testDivisionBayernliga = Division(
    name: 'Bayernliga',
    startDate: DateTime.utc(2023),
    endDate: DateTime.utc(2024),
    boutConfig: getAdultBoutConfig(),
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

  final testClubMering = Club(name: 'TSC Mering', organization: organizationNRW, orgSyncId: '70434', no: '70434');
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
      birthDate: DateTime.utc(2000, 1, 31),
      nationality: Countries.deu,
    ),
  );

  final testTeamMering = Team(orgSyncId: 'TSC Mering', organization: organizationNRW, name: 'TSC Mering');

  final testTeamUntergriesbach =
      Team(name: 'SV Untergriesbach', organization: organizationNRW, orgSyncId: 'SV Untergriesbach');

  final testLineupUntergriesbach = Lineup(
    team: testTeamUntergriesbach,
  );

  final testTeamClubAffiliationUntergriesbach =
      TeamClubAffiliation(team: testTeamUntergriesbach, club: testClubUntergriesbach);

  final testTeamBerchtesgaden = Team(
    orgSyncId: 'TSV Berchtesgaden',
    organization: organizationNRW,
    name: 'TSV Berchtesgaden',
    description: null,
  );

  final testTeamClubAffiliationBerchtesgaden =
      TeamClubAffiliation(team: testTeamBerchtesgaden, club: testClubBerchtesgaden);

  final testLineupBerchtesgaden = Lineup(
    team: testTeamBerchtesgaden,
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
            return (await wrestlingApi.importTeamClubAffiliations())
                .firstWhere((tca) => tca.club.orgSyncId == orgSyncId)
                .club as T;
          case const (Team):
            return (await wrestlingApi.importTeamClubAffiliations())
                .firstWhere((tca) => tca.team.orgSyncId == orgSyncId)
                .team as T;
          case const (DivisionWeightClass):
            final divisions = await wrestlingApi.importDivisions(minDate: DateTime.utc(2023));
            final weightClasses = (await Future.wait(
                    divisions.keys.map((division) => wrestlingApi.importDivisionWeightClasses(division: division))))
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
      Iterable<BoutResultRule> boutResultRules(BoutConfig config) => [
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
              boutResult: BoutResult.dsq2,
              winnerClassificationPoints: 0,
              loserClassificationPoints: 0,
            ),
          ];

      test('Divisions', () async {
        final divisionBoutConfigRulesMap = await wrestlingApi.importDivisions(minDate: DateTime.utc(2023));
        final youthBoutConfig = getYouthBoutConfig();
        final adultBoutConfig = getAdultBoutConfig();
        expect(divisionBoutConfigRulesMap, {
          testDivisionJunior: boutResultRules(testDivisionJunior.boutConfig),
          Division(
            name: '(S) Finalrunde',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: youthBoutConfig,
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_(S) Finalrunde',
          ): boutResultRules(youthBoutConfig),
          testDivisionBayernliga: boutResultRules(testDivisionBayernliga.boutConfig),
          Division(
            name: 'Gruppenoberliga',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: adultBoutConfig,
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_Gruppenoberliga',
          ): boutResultRules(adultBoutConfig),
          Division(
            name: 'Landesliga',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: adultBoutConfig,
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_Landesliga',
          ): boutResultRules(adultBoutConfig),
          Division(
            name: 'Oberliga',
            startDate: DateTime.utc(2023),
            endDate: DateTime.utc(2024),
            boutConfig: adultBoutConfig,
            seasonPartitions: 2,
            organization: organizationNRW,
            orgSyncId: '2023_Oberliga',
          ): boutResultRules(adultBoutConfig),
        });
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

      test('Team Club Affiliations', () async {
        final clubs = await wrestlingApi.importTeamClubAffiliations();
        final clubWillmering =
            Club(name: 'RG Willmering', organization: organizationNRW, orgSyncId: '30525', no: '30525');
        final clubCham = Club(name: 'ASV Cham', organization: organizationNRW, orgSyncId: '30074', no: '30074');
        final teamWillmeringCham =
            Team(name: 'WKG Willmering/Cham', orgSyncId: 'WKG Willmering/Cham', organization: organizationNRW);
        final teamWillmeringChamS =
            Team(name: 'S - WKG Willmering/Cham', orgSyncId: 'S - WKG Willmering/Cham', organization: organizationNRW);
        final teamWillmeringCham2 =
            Team(name: 'WKG Willmering/Cham II', orgSyncId: 'WKG Willmering/Cham II', organization: organizationNRW);
        expect(clubs, [
          TeamClubAffiliation(team: teamWillmeringCham, club: clubWillmering),
          TeamClubAffiliation(team: teamWillmeringCham2, club: clubWillmering),
          TeamClubAffiliation(team: teamWillmeringChamS, club: clubWillmering),
          TeamClubAffiliation(team: teamWillmeringCham, club: clubCham),
          TeamClubAffiliation(team: teamWillmeringCham2, club: clubCham),
          TeamClubAffiliation(team: teamWillmeringChamS, club: clubCham),
          TeamClubAffiliation(
              team: Team(name: 'TV Geiselhöring', orgSyncId: 'TV Geiselhöring', organization: organizationNRW),
              club: testClubGeiselhoering),
          TeamClubAffiliation(
              team: Team(name: 'S - TV Geiselhöring', orgSyncId: 'S - TV Geiselhöring', organization: organizationNRW),
              club: testClubGeiselhoering),
          TeamClubAffiliation(
              team: Team(name: 'TV Geiselhöring II', orgSyncId: 'TV Geiselhöring II', organization: organizationNRW),
              club: testClubGeiselhoering),
          TeamClubAffiliation(team: testTeamMering, club: testClubMering),
          TeamClubAffiliation(
              team: Team(name: 'S - TSC Mering', orgSyncId: 'S - TSC Mering', organization: organizationNRW),
              club: testClubMering),
          TeamClubAffiliation(
              team: Team(name: 'TSC Mering II', orgSyncId: 'TSC Mering II', organization: organizationNRW),
              club: testClubMering),
          TeamClubAffiliation(
              team: Team(name: 'S - TSC Mering II', orgSyncId: 'S - TSC Mering II', organization: organizationNRW),
              club: testClubMering),
          testTeamClubAffiliationBerchtesgaden,
          TeamClubAffiliation(
              team: Team(
                  name: 'S - TSV Berchtesgaden', orgSyncId: 'S - TSV Berchtesgaden', organization: organizationNRW),
              club: testClubBerchtesgaden),
          TeamClubAffiliation(
              team:
                  Team(name: 'TSV Berchtesgaden II', orgSyncId: 'TSV Berchtesgaden II', organization: organizationNRW),
              club: testClubBerchtesgaden),
          TeamClubAffiliation(
              team:
                  Team(name: 'SV Untergriesbach II', orgSyncId: 'SV Untergriesbach II', organization: organizationNRW),
              club: testClubUntergriesbach),
          TeamClubAffiliation(
              team: Team(
                  name: 'S - SV Untergriesbach', orgSyncId: 'S - SV Untergriesbach', organization: organizationNRW),
              club: testClubUntergriesbach),
          testTeamClubAffiliationUntergriesbach,
        ]);
      });

      test('Memberships', () async {
        final memberships = await wrestlingApi.importMemberships(club: testClubUntergriesbach);
        expect(memberships, {testMembership});
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
              guest: Lineup(team: testTeamMering, leader: null, coach: null),
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
          orgSyncId: '005029c_61_kg_free',
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
                  birthDate: DateTime.utc(2000, 3, 02),
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
