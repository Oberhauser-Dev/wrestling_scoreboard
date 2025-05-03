import '../common.dart';

class MockedData {
  late final organization = Organization(id: 0, name: 'Deutscher Ringer Bund', abbreviation: 'DRB');
  late final organization2 =
      Organization(id: 1, name: 'Bayerischer Ringer Verband', abbreviation: 'BRV', parent: organization);

  final boutConfig = BoutConfig(id: 1);

  late final boutResultRule = BoutResultRule(
    id: 0,
    boutConfig: boutConfig,
    boutResult: BoutResult.vin,
    winnerClassificationPoints: 4,
    loserClassificationPoints: 0,
  );

  late final adultDivision = Division(
    id: 1,
    name: 'Adult',
    startDate: DateTime.utc(2021),
    endDate: DateTime.utc(2022),
    boutConfig: boutConfig,
    seasonPartitions: 2,
    organization: organization,
  );

  late final juniorDivision = Division(
    id: 2,
    name: 'Junior',
    startDate: DateTime.utc(2021),
    endDate: DateTime.utc(2022),
    boutConfig: boutConfig,
    seasonPartitions: 2,
    organization: organization,
  );

  late final leagueMenRPW = League(
    id: 1,
    name: 'Real Pro Wrestling',
    startDate: DateTime.utc(2021),
    endDate: DateTime.utc(2022),
    division: adultDivision,
    boutDays: 14,
    organization: organization,
  );

  late final leagueJnRPW = League(
    id: 2,
    name: 'Real Pro Wrestling Jn',
    startDate: DateTime.utc(2021),
    endDate: DateTime.utc(2022),
    division: juniorDivision,
    boutDays: 14,
    organization: organization,
  );
  late final leagueNational = League(
    id: 3,
    name: 'National League',
    startDate: DateTime.utc(2021),
    endDate: DateTime.utc(2022),
    division: adultDivision,
    boutDays: 14,
    organization: organization,
  );

  late final homeClub = Club(id: 1, name: 'Springfield Wrestlers', organization: organization);
  late final guestClub = Club(id: 2, name: 'Quahog Hunters', organization: organization);

  late final homeTeam = const Team(
    id: 1,
    name: 'Springfield Wrestlers',
    description: '1. Team Men',
  );
  late final homeTeamJuniors = const Team(
    id: 2,
    name: 'Springfield Wrestlers Jn',
    description: 'Juniors',
  );
  late final guestTeam = const Team(
    id: 3,
    name: 'Quahog Hunters II',
    description: '2. Team Men',
  );

  late final homeTeamAffiliation = TeamClubAffiliation(team: homeTeam, club: homeClub);
  late final homeTeamJuniorsAffiliation = TeamClubAffiliation(team: homeTeamJuniors, club: homeClub);
  late final guestTeamAffiliation = TeamClubAffiliation(team: guestTeam, club: guestClub);

// Teams per League
  late final htMenRPW = LeagueTeamParticipation(id: 1, league: leagueMenRPW, team: homeTeam);
  late final htjJnRPW = LeagueTeamParticipation(id: 2, league: leagueJnRPW, team: homeTeamJuniors);
  late final gtMenRPW = LeagueTeamParticipation(id: 3, league: leagueMenRPW, team: guestTeam);
  late final htNat = LeagueTeamParticipation(id: 4, league: leagueNational, team: homeTeam);
  late final gtNat = LeagueTeamParticipation(id: 5, league: leagueNational, team: guestTeam);

  late final wc57 = const WeightClass(id: 1, weight: 57, style: WrestlingStyle.free);
  late final wc130 = const WeightClass(id: 2, weight: 130, style: WrestlingStyle.greco);
  late final wc61 = const WeightClass(id: 3, weight: 61, style: WrestlingStyle.greco);
  late final wc98 = const WeightClass(id: 4, weight: 98, style: WrestlingStyle.free);
  late final wc66 = const WeightClass(id: 5, weight: 66, style: WrestlingStyle.free);
  late final wc86 = const WeightClass(id: 6, weight: 86, style: WrestlingStyle.greco);
  late final wc71 = const WeightClass(id: 7, weight: 71, style: WrestlingStyle.greco);
  late final wc80 = const WeightClass(id: 8, weight: 80, style: WrestlingStyle.free);
  late final wc75A = const WeightClass(id: 9, weight: 75, style: WrestlingStyle.free, suffix: 'A');
  late final wc75B = const WeightClass(id: 10, weight: 75, style: WrestlingStyle.greco, suffix: 'B');

  late final divisionWc57 = DivisionWeightClass(id: 0, pos: 0, division: adultDivision, weightClass: wc57);

  late final leagueWc57 = LeagueWeightClass(id: 0, pos: 0, league: leagueMenRPW, weightClass: wc57);

// TEAM 1
  late final p1 = Person(id: 1, prename: 'Lisa', surname: 'Simpson', gender: Gender.female, organization: organization);
  late final p2 = Person(id: 2, prename: 'Bart', surname: 'Simpson', gender: Gender.male, organization: organization);
  late final p3 =
      Person(id: 3, prename: 'March', surname: 'Simpson', gender: Gender.female, organization: organization);
  late final p4 = Person(id: 4, prename: 'Homer', surname: 'Simpson', gender: Gender.male, organization: organization);

  late final r1 = Membership(id: 1, person: p1, club: homeClub);
  late final r2 = Membership(id: 2, person: p2, club: homeClub);
  late final r3 = Membership(id: 3, person: p3, club: homeClub);
  late final r4 = Membership(id: 4, person: p4, club: homeClub);

// TEAM 2
  late final p5 = Person(id: 5, prename: 'Meg', surname: 'Griffin', gender: Gender.female, organization: organization);
  late final p6 = Person(id: 6, prename: 'Chris', surname: 'Griffin', gender: Gender.male, organization: organization);
  late final p7 = Person(id: 7, prename: 'Lois', surname: 'Griffin', gender: Gender.female, organization: organization);
  late final p8 = Person(id: 8, prename: 'Peter', surname: 'Griffin', gender: Gender.male, organization: organization);

  late final b1 = Membership(id: 5, person: p5, club: guestClub);
  late final b2 = Membership(id: 6, person: p6, club: guestClub);
  late final b3 = Membership(id: 7, person: p7, club: guestClub);
  late final b4 = Membership(id: 8, person: p8, club: guestClub);

  final referee = const Person(id: 9, prename: 'Mr', surname: 'Referee', gender: Gender.male);
  final judge = const Person(id: 10, prename: 'Mrs', surname: 'Judge', gender: Gender.female);
  final matChairman = const Person(id: 11, prename: 'Mr', surname: 'Chairman', gender: Gender.male);
  final timeKeeper = const Person(id: 12, prename: 'Mr', surname: 'Time-Keeper', gender: Gender.male);
  final transcriptWriter = const Person(id: 13, prename: 'Mrs', surname: 'Transcript-Writer', gender: Gender.female);

  TeamMatch initMenRPWMatch() {
    final menRpwHomeTeamLineup = TeamLineup(id: 1, team: homeTeam);
    final menRpwGuestTeamLineup = TeamLineup(id: 2, team: guestTeam);
    _teamLineups.add(menRpwHomeTeamLineup);
    _teamLineups.add(menRpwGuestTeamLineup);
    _teamLineupParticipations.add(
        TeamLineupParticipation(id: 1, membership: r1, lineup: menRpwHomeTeamLineup, weightClass: wc57, weight: 55.8));
    _teamLineupParticipations.add(
        TeamLineupParticipation(id: 2, membership: r2, lineup: menRpwHomeTeamLineup, weightClass: wc61, weight: 60.15));
    _teamLineupParticipations.add(
        TeamLineupParticipation(id: 3, membership: r3, lineup: menRpwHomeTeamLineup, weightClass: wc75A, weight: 73.3));
    _teamLineupParticipations.add(TeamLineupParticipation(
        id: 4, membership: r4, lineup: menRpwHomeTeamLineup, weightClass: wc130, weight: 133.5));
    _teamLineupParticipations.add(
        TeamLineupParticipation(id: 5, membership: b1, lineup: menRpwGuestTeamLineup, weightClass: wc57, weight: 57.0));
    _teamLineupParticipations
        .add(TeamLineupParticipation(id: 6, membership: b2, lineup: menRpwGuestTeamLineup, weightClass: wc66));
    _teamLineupParticipations.add(TeamLineupParticipation(
        id: 7, membership: b3, lineup: menRpwGuestTeamLineup, weightClass: wc75A, weight: 72.4));
    _teamLineupParticipations.add(TeamLineupParticipation(
        id: 8, membership: b4, lineup: menRpwGuestTeamLineup, weightClass: wc130, weight: 129.9));

    return TeamMatch(
      id: 1,
      no: '123456',
      home: menRpwHomeTeamLineup,
      guest: menRpwGuestTeamLineup,
      referee: referee,
      judge: judge,
      matChairman: matChairman,
      timeKeeper: timeKeeper,
      transcriptWriter: transcriptWriter,
      date: DateTime.utc(2025, 5, 3),
      comment: 'Some commment',
      visitorsCount: 123,
      location: 'Springfield',
      league: leagueMenRPW,
      organization: organization,
    );
  }

  late final menRPWMatch = initMenRPWMatch();

  TeamMatch initJnRPWMatch() {
    TeamLineup home = TeamLineup(id: 3, team: homeTeamJuniors);
    TeamLineup guest = TeamLineup(id: 4, team: guestTeam);
    _teamLineups.add(home);
    _teamLineups.add(guest);

    return TeamMatch(
      id: 2,
      home: home,
      guest: guest,
      referee: referee,
      location: 'Springfield',
      date: DateTime.now(),
      league: leagueJnRPW,
      organization: organization,
    );
  }

  late final jnRPWMatch = initJnRPWMatch();

  late final boutState1R = AthleteBoutState(id: 1, membership: r1, classificationPoints: 5);
  late final boutState1B = AthleteBoutState(id: 2, membership: b1, classificationPoints: 0);
  late final bout1 = Bout(
    id: 0,
    r: boutState1R,
    b: boutState1B,
    organization: organization,
    result: BoutResult.vca,
    winnerRole: BoutRole.red,
    duration: Duration(seconds: 180),
  );

  late final boutState2R = AthleteBoutState(id: 3, membership: r2, classificationPoints: 1);
  late final boutState2B = AthleteBoutState(id: 4, membership: b2, classificationPoints: 3);
  late final bout2 = Bout(
    id: 1,
    r: boutState2R,
    b: boutState2B,
    organization: organization,
    result: BoutResult.vca,
    winnerRole: BoutRole.blue,
    duration: Duration(seconds: 180),
  );

  late final boutState3R = AthleteBoutState(id: 5, membership: r1, classificationPoints: 1);
  late final boutState3B = AthleteBoutState(id: 6, membership: b2, classificationPoints: 3);
  late final bout3 = Bout(
    id: 2,
    r: boutState3R,
    b: boutState3B,
    organization: organization,
  );

  late final boutState4R = AthleteBoutState(id: 7, membership: r2);
  late final boutState4B = AthleteBoutState(id: 8, membership: b1);
  late final bout4 = Bout(
    id: 3,
    r: boutState4R,
    b: boutState4B,
    organization: organization,
  );

  late final boutState5R = AthleteBoutState(id: 20, membership: r1);
  late final boutState5B = AthleteBoutState(id: 21, membership: r4);
  late final bout5 = Bout(
    id: 4,
    r: boutState5R,
    b: boutState5B,
    organization: organization,
  );

  late final tmb1 = TeamMatchBout(
    id: 1,
    teamMatch: menRPWMatch,
    pos: 0,
    organization: organization,
    weightClass: wc57,
    bout: bout1,
  );

  late final tmb2 = TeamMatchBout(
    id: 2,
    teamMatch: menRPWMatch,
    pos: 1,
    organization: organization,
    weightClass: wc61,
    bout: bout2,
  );

  late final competition = Competition(
    id: 0,
    no: 'abc',
    name: 'Wittelsbacher-Land-Turnier',
    boutConfig: boutConfig,
    date: DateTime.utc(2025, 03, 29),
    organization: organization,
    comment: 'This is a comment',
    location: 'Aichach',
    visitorsCount: 500,
    matCount: 6,
  );

  late final competitionPerson =
      CompetitionPerson(id: 0, competition: competition, person: p1, role: PersonRole.timeKeeper);

  late final competitionSystemAffiliationNordic = CompetitionSystemAffiliation(
      id: 0, competitionSystem: CompetitionSystem.nordic, competition: competition, maxContestants: 6);
  late final competitionSystemAffiliationTwoPools =
      CompetitionSystemAffiliation(id: 1, competitionSystem: CompetitionSystem.twoPools, competition: competition);

  late final ageCategoryAJuniors =
      AgeCategory(id: 0, name: 'A-Juniors', minAge: 16, maxAge: 18, organization: organization);
  late final ageCategoryCJuniors =
      AgeCategory(id: 1, name: 'C-Juniors', minAge: 12, maxAge: 14, organization: organization);

  late final competitionLineup1 = CompetitionLineup(id: 0, competition: competition, club: homeClub);
  late final competitionLineup2 = CompetitionLineup(id: 1, competition: competition, club: guestClub);
  late final competitionWeightCategory =
      CompetitionWeightCategory(id: 1, competition: competition, weightClass: wc61, ageCategory: ageCategoryAJuniors);

  late final competitionWeightCategory2 =
      CompetitionWeightCategory(id: 2, competition: competition, weightClass: wc57, ageCategory: ageCategoryCJuniors);

  late final competitionParticipation1 = CompetitionParticipation(
    id: 1,
    poolDrawNumber: 1,
    poolGroup: 0,
    membership: r1,
    lineup: competitionLineup1,
    weightCategory: competitionWeightCategory,
    weight: 61,
  );

  late final competitionParticipation2 = CompetitionParticipation(
    id: 2,
    poolDrawNumber: 2,
    poolGroup: 0,
    membership: b1,
    lineup: competitionLineup2,
    weightCategory: competitionWeightCategory,
    weight: 60.3,
  );

  late final competitionParticipation3 = CompetitionParticipation(
    id: 3,
    poolDrawNumber: 3,
    poolGroup: 0,
    membership: r2,
    lineup: competitionLineup2,
    weightCategory: competitionWeightCategory,
    weight: 59.2,
    disqualified: true,
    eliminated: true,
  );

  late final competitionParticipation4 = CompetitionParticipation(
    id: 4,
    poolDrawNumber: 4,
    poolGroup: 0,
    membership: b2,
    lineup: competitionLineup2,
    weightCategory: competitionWeightCategory,
    weight: 59.4,
  );

  late final competitionParticipation5 = CompetitionParticipation(
    id: 10,
    poolDrawNumber: 0,
    poolGroup: 1,
    membership: r3,
    lineup: competitionLineup1,
    weightCategory: competitionWeightCategory,
    weight: 58.1,
  );

  late final competitionParticipation6 = CompetitionParticipation(
    id: 11,
    poolDrawNumber: 1,
    poolGroup: 1,
    membership: b3,
    lineup: competitionLineup2,
    weightCategory: competitionWeightCategory,
    weight: 58.2,
  );

  late final competitionParticipation7 = CompetitionParticipation(
    id: 12,
    poolDrawNumber: 2,
    poolGroup: 1,
    membership: r4,
    lineup: competitionLineup2,
    weightCategory: competitionWeightCategory,
    weight: 58.3,
  );

  late final competitionBout1 = CompetitionBout(
    id: 1,
    competition: competition,
    pos: 0,
    mat: 0,
    bout: bout1,
    round: 0,
    weightCategory: competitionWeightCategory,
  );

  late final competitionBout2 = CompetitionBout(
    id: 2,
    competition: competition,
    pos: 1,
    mat: 2,
    bout: bout2,
    round: 0,
    weightCategory: competitionWeightCategory,
  );

  late final competitionBout3 = CompetitionBout(
    id: 3,
    competition: competition,
    pos: 3,
    bout: bout3,
    round: 1,
    weightCategory: competitionWeightCategory,
  );

  late final competitionBout4 = CompetitionBout(
    id: 4,
    competition: competition,
    pos: 4,
    bout: bout4,
    round: 1,
    weightCategory: competitionWeightCategory,
  );

  late final competitionBoutFinal1 = CompetitionBout(
    id: 10,
    competition: competition,
    pos: 10,
    bout: bout5,
    round: 2,
    roundType: RoundType.finals,
    weightCategory: competitionWeightCategory,
  );

  late final boutAction1 = BoutAction(
      actionType: BoutActionType.points,
      bout: bout1,
      duration: Duration(seconds: 29),
      role: BoutRole.red,
      pointCount: 4);
  late final boutAction2 = BoutAction(
      actionType: BoutActionType.caution, bout: bout2, duration: Duration(seconds: 129), role: BoutRole.blue);
  late final boutAction3 = BoutAction(
      actionType: BoutActionType.points,
      bout: bout2,
      duration: Duration(seconds: 100),
      role: BoutRole.red,
      pointCount: 2);

  late final List<Club> _clubs = [homeClub, guestClub];
  late final List<BoutAction> _boutActions = [boutAction1, boutAction2, boutAction3];
  late final List<Organization> _organizations = [organization, organization2];
  late final List<Division> _divisions = [juniorDivision, adultDivision];
  late final List<League> _leagues = [leagueMenRPW, leagueJnRPW, leagueNational];
  late final List<DivisionWeightClass> _divisionWeightClasses = [divisionWc57];
  late final List<LeagueWeightClass> _leagueWeightClasses = [leagueWc57];
  late final List<LeagueTeamParticipation> _leagueTeamParticipations = [htMenRPW, gtMenRPW, htjJnRPW, htNat, gtNat];
  late final List<TeamLineup> _teamLineups = []; // Is filled during initialization of team matches
  late final List<Membership> _memberships = [r1, r2, r3, r4, b1, b2, b3, b4];
  late final List<TeamLineupParticipation> _teamLineupParticipations =
      []; // Is filled during initialization of team matches
  late final List<AthleteBoutState> _athleteBoutStates = [
    boutState1R,
    boutState1B,
    boutState2R,
    boutState2B,
    boutState3R,
    boutState3B,
    boutState4R,
    boutState4B,
    boutState5R,
    boutState5B,
  ];
  late final List<Person> _persons = [
    p1,
    p2,
    p3,
    p4,
    p5,
    p6,
    p7,
    p8,
    referee,
    timeKeeper,
    judge,
    matChairman,
    transcriptWriter,
  ];
  late final List<Team> _teams = [homeTeam, homeTeamJuniors, guestTeam];
  late final List<TeamClubAffiliation> _teamClubAffiliations = [
    homeTeamAffiliation,
    homeTeamJuniorsAffiliation,
    guestTeamAffiliation
  ];

  late final List<WeightClass> _weightClasses = [wc57, wc130, wc61, wc98, wc66, wc86, wc71, wc80, wc75A, wc75B];
  late final List<BoutConfig> _boutConfigs = [boutConfig];
  late final List<BoutResultRule> _boutResultRules = [boutResultRule];

  late final List<TeamMatch> _teamMatches = [menRPWMatch, jnRPWMatch];
  late final List<TeamMatchBout> _teamMatchBouts = [tmb1, tmb2];

  late final List<AgeCategory> _ageCategories = [ageCategoryAJuniors, ageCategoryCJuniors];

  late final List<Competition> _competitions = [competition];
  late final List<CompetitionSystemAffiliation> _competitionSystemAffiliations = [
    competitionSystemAffiliationNordic,
    competitionSystemAffiliationTwoPools,
  ];
  late final List<CompetitionPerson> _competitionPersons = [
    competitionPerson,
  ];
  late final List<CompetitionBout> _competitionBouts = [
    competitionBout1,
    competitionBout2,
    competitionBout3,
    competitionBout4,
    competitionBoutFinal1,
  ];
  late final List<CompetitionWeightCategory> _competitionWeightCategories = [
    competitionWeightCategory,
    competitionWeightCategory2,
  ];
  late final List<CompetitionLineup> _competitionLineups = [competitionLineup1, competitionLineup2];
  late final List<CompetitionParticipation> _competitionParticipations = [
    competitionParticipation1,
    competitionParticipation2,
    competitionParticipation3,
    competitionParticipation4,
    competitionParticipation5,
    competitionParticipation6,
    competitionParticipation7,
  ];

  List<AgeCategory> getAgeCategories() => _ageCategories;

  List<AgeCategory> getAgeCategoryOfOrganization(Organization organization) {
    return getAgeCategories().where((element) => element.organization == organization).toList();
  }

  List<Club> getClubs() => _clubs;

  List<Club> getClubsOfOrganization(Organization organization) {
    return getClubs().where((element) => element.organization == organization).toList();
  }

  List<CompetitionBout> getBoutsOfCompetition(Competition competition) {
    return getCompetitionBouts().where((element) => element.competition == competition).toList();
  }

  List<TeamMatchBout> getBoutsOfTeamMatch(TeamMatch match) {
    return getTeamMatchBouts().where((element) => element.teamMatch == match).toList();
  }

  List<BoutAction> getBoutActions() => _boutActions;

  List<BoutAction> getBoutActionsOfBout(Bout bout) =>
      getBoutActions().where((element) => element.bout == bout).toList();

  List<Organization> getOrganizations() => _organizations;

  List<Organization> getOrganizationsOfOrganization(Organization organization) {
    return getOrganizations().where((element) => element.parent == organization).toList();
  }

  List<Division> getDivisions() => _divisions;

  List<Division> getDivisionsOfDivision(Division division) {
    return getDivisions().where((element) => element.parent == division).toList();
  }

  List<Division> getDivisionsOfOrganization(Organization organization) {
    return getDivisions().where((element) => element.organization == organization).toList();
  }

  List<League> getLeagues() => _leagues;

  List<League> getLeaguesOfDivision(Division division) {
    return getLeagues().where((element) => element.division == division).toList();
  }

  List<LeagueWeightClass> getLeagueWeightClasses() => _leagueWeightClasses;

  List<LeagueWeightClass> getLeagueWeightClassesOfLeague(League league) {
    return getLeagueWeightClasses().where((e) => e.league == league).toList();
  }

  List<DivisionWeightClass> getDivisionWeightClasses() => _divisionWeightClasses;

  List<DivisionWeightClass> getDivisionWeightClassesOfDivision(Division division) {
    return getDivisionWeightClasses().where((element) => element.division == division).toList();
  }

  List<LeagueTeamParticipation> getLeagueTeamParticipations() => _leagueTeamParticipations;

  List<LeagueTeamParticipation> getLeagueTeamParticipationsOfLeague(League league) {
    return getLeagueTeamParticipations().where((element) => element.league == league).toList();
  }

  List<LeagueTeamParticipation> getLeagueTeamParticipationsOfTeam(Team team) {
    return getLeagueTeamParticipations().where((element) => element.team == team).toList();
  }

  List<TeamLineup> getTeamLineups() => _teamLineups;

  List<Membership> getMemberships() => _memberships;

  List<Membership> getMembershipsOfClub(Club club) {
    return getMemberships().where((element) => element.club == club).toList();
  }

  List<TeamLineupParticipation> getTeamLineupParticipations() => _teamLineupParticipations;

  List<TeamLineupParticipation> getTeamLineupParticipationsOfLineup(TeamLineup lineup) {
    return getTeamLineupParticipations().where((element) => element.lineup == lineup).toList();
  }

  List<AthleteBoutState> getAthleteBoutStates() => _athleteBoutStates;

  List<Person> getPersons() => _persons;

  List<Person> getPersonsOfOrganization(Organization organization) {
    return getPersons().where((element) => element.organization == organization).toList();
  }

  List<Team> getTeams() => _teams;

  List<TeamClubAffiliation> getTeamClubAffiliations() => _teamClubAffiliations;

  List<Team> getTeamsOfClub(Club club) {
    return getTeamClubAffiliations().where((element) => element.club == club).map((tca) => tca.team).toList();
  }

  List<Team> getTeamsOfLeague(League league) {
    return getLeagueTeamParticipationsOfLeague(league).map((e) => e.team).toList();
  }

  List<TeamMatch> getTeamMatches() => _teamMatches;

  List<TeamMatch> getTeamMatchesOfTeam(Team team) {
    return getTeamMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
  }

  List<TeamMatch> getTeamMatchesOfLeague(League league) {
    return getTeamMatches().where((e) => e.league == league).toList();
  }

  List<TeamMatchBout> getTeamMatchBouts() => _teamMatchBouts;

  List<Bout> getBouts() => {
        ..._teamMatchBouts.map((e) => e.bout),
        ..._competitionBouts.map((e) => e.bout),
      }.toList();

  List<TeamMatchBout> getTeamMatchBoutsOfTeamMatch(TeamMatch match) {
    return getTeamMatchBouts().where((element) => element.teamMatch == match).toList();
  }

  List<BoutConfig> getBoutConfigs() => _boutConfigs;

  List<BoutResultRule> getBoutResultRules() => _boutResultRules;

  List<BoutResultRule> getBoutResultRulesOfBoutConfig(BoutConfig boutConfig) {
    return getBoutResultRules().where((element) => element.boutConfig == boutConfig).toList();
  }

  List<Competition> getCompetitions() => _competitions;

  List<Competition> getCompetitionsOfOrganization(Organization organization) {
    return getCompetitions().where((element) => element.organization == organization).toList();
  }

  List<CompetitionWeightCategory> getCompetitionWeightCategories() => _competitionWeightCategories;

  List<CompetitionWeightCategory> getCompetitionWeightCategoriesOfCompetition(Competition competition) {
    return getCompetitionWeightCategories().where((element) => element.competition == competition).toList();
  }

  List<CompetitionSystemAffiliation> getCompetitionSystemAffiliations() => _competitionSystemAffiliations;

  List<CompetitionSystemAffiliation> getCompetitionSystemAffiliationsOfCompetition(Competition competition) {
    return getCompetitionSystemAffiliations().where((element) => element.competition == competition).toList();
  }

  List<CompetitionPerson> getCompetitionPersons() => _competitionPersons;

  List<CompetitionBout> getCompetitionBouts() => _competitionBouts;

  List<CompetitionBout> getCompetitionBoutsOfCompetition(Competition competition) {
    return getCompetitionBouts().where((element) => element.competition == competition).toList();
  }

  List<CompetitionBout> getCompetitionBoutsOfWeightCategory(CompetitionWeightCategory weightCategory) {
    return getCompetitionBouts().where((element) => element.weightCategory == weightCategory).toList();
  }

  List<CompetitionLineup> getCompetitionLineups() => _competitionLineups;

  List<CompetitionLineup> getCompetitionLineupsOfCompetition(Competition competition) {
    return getCompetitionLineups().where((element) => element.competition == competition).toList();
  }

  List<CompetitionParticipation> getCompetitionParticipations() => _competitionParticipations;

  List<CompetitionParticipation> getCompetitionParticipationsOfWeightCategory(
      CompetitionWeightCategory weightCategory) {
    return getCompetitionParticipations().where((element) => element.weightCategory == weightCategory).toList();
  }

  List<CompetitionParticipation> getCompetitionParticipationsOfLineup(CompetitionLineup lineup) {
    return getCompetitionParticipations().where((element) => element.lineup == lineup).toList();
  }

  List<WeightClass> getWeightClasses() => _weightClasses;

  List<WeightClass> getWeightClassesOfDivision(Division league) {
    return (getDivisionWeightClassesOfDivision(league).toList()..sort((a, b) => a.pos - b.pos))
        .map((e) => e.weightClass)
        .toList();
  }
}
