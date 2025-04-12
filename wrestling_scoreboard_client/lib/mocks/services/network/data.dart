import 'package:wrestling_scoreboard_common/common.dart';

class MockedData {
  late final _organization = Organization(id: 0, name: 'Deutscher Ringer Bund', abbreviation: 'DRB');
  late final _organization2 =
      Organization(id: 1, name: 'Bayerischer Ringer Verband', abbreviation: 'BRV', parent: _organization);

  final _boutConfig = BoutConfig(id: 1);

  late final _adultDivision = Division(
    id: 1,
    name: 'Adult',
    startDate: DateTime(2021),
    endDate: DateTime(2022),
    boutConfig: _boutConfig,
    seasonPartitions: 2,
    organization: _organization,
  );

  late final _juniorDivision = Division(
    id: 2,
    name: 'Junior',
    startDate: DateTime(2021),
    endDate: DateTime(2022),
    boutConfig: _boutConfig,
    seasonPartitions: 2,
    organization: _organization,
  );

  late final _leagueMenRPW = League(
    id: 1,
    name: 'Real Pro Wrestling',
    startDate: DateTime(2021),
    endDate: DateTime(2022),
    division: _adultDivision,
    boutDays: 14,
    organization: _organization,
  );

  late final _leagueJnRPW = League(
    id: 2,
    name: 'Real Pro Wrestling Jn',
    startDate: DateTime(2021),
    endDate: DateTime(2022),
    division: _juniorDivision,
    boutDays: 14,
    organization: _organization,
  );
  late final _leagueNational = League(
    id: 3,
    name: 'National League',
    startDate: DateTime(2021),
    endDate: DateTime(2022),
    division: _adultDivision,
    boutDays: 14,
    organization: _organization,
  );

  late final _homeClub = Club(id: 1, name: 'Springfield Wrestlers', organization: _organization);
  late final _guestClub = Club(id: 2, name: 'Quahog Hunters', organization: _organization);

  late final _homeTeam = const Team(
    id: 1,
    name: 'Springfield Wrestlers',
    description: '1. Team Men',
  );
  late final _homeTeamJuniors = const Team(
    id: 2,
    name: 'Springfield Wrestlers Jn',
    description: 'Juniors',
  );
  late final _guestTeam = const Team(
    id: 3,
    name: 'Quahog Hunters II',
    description: '2. Team Men',
  );

  late final _homeTeamAffiliation = TeamClubAffiliation(team: _homeTeam, club: _homeClub);
  late final _homeTeamJuniorsAffiliation = TeamClubAffiliation(team: _homeTeamJuniors, club: _homeClub);
  late final _guestTeamAffiliation = TeamClubAffiliation(team: _guestTeam, club: _guestClub);

// Teams per League
  late final _htMenRPW = LeagueTeamParticipation(id: 1, league: _leagueMenRPW, team: _homeTeam);
  late final _htjJnRPW = LeagueTeamParticipation(id: 2, league: _leagueJnRPW, team: _homeTeamJuniors);
  late final _gtMenRPW = LeagueTeamParticipation(id: 3, league: _leagueMenRPW, team: _guestTeam);
  late final _htNat = LeagueTeamParticipation(id: 4, league: _leagueNational, team: _homeTeam);
  late final _gtNat = LeagueTeamParticipation(id: 5, league: _leagueNational, team: _guestTeam);

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

// TEAM 1
  late final p1 =
      Person(id: 1, prename: 'Lisa', surname: 'Simpson', gender: Gender.female, organization: _organization);
  late final p2 = Person(id: 2, prename: 'Bart', surname: 'Simpson', gender: Gender.male, organization: _organization);
  late final p3 =
      Person(id: 3, prename: 'March', surname: 'Simpson', gender: Gender.female, organization: _organization);
  late final p4 = Person(id: 4, prename: 'Homer', surname: 'Simpson', gender: Gender.male, organization: _organization);
  late final r1 = Membership(id: 1, person: p1, club: _homeClub);
  late final r2 = Membership(id: 2, person: p2, club: _homeClub);
  late final r3 = Membership(id: 3, person: p3, club: _homeClub);
  late final r4 = Membership(id: 4, person: p4, club: _homeClub);

// TEAM 2
  late final p5 = Person(id: 5, prename: 'Meg', surname: 'Griffin', gender: Gender.female, organization: _organization);
  late final p6 = Person(id: 6, prename: 'Chris', surname: 'Griffin', gender: Gender.male, organization: _organization);
  late final p7 =
      Person(id: 7, prename: 'Lois', surname: 'Griffin', gender: Gender.female, organization: _organization);
  late final p8 = Person(id: 8, prename: 'Peter', surname: 'Griffin', gender: Gender.male, organization: _organization);
  late final b1 = Membership(id: 5, person: p5, club: _guestClub);
  late final b2 = Membership(id: 6, person: p6, club: _guestClub);
  late final b3 = Membership(id: 7, person: p7, club: _guestClub);
  late final b4 = Membership(id: 8, person: p8, club: _guestClub);

  TeamMatch initMenRPWMatch() {
    TeamLineup home = TeamLineup(id: 1, team: _homeTeam);
    TeamLineup guest = TeamLineup(id: 2, team: _guestTeam);
    _lineups.add(home);
    _lineups.add(guest);
    _participations.add(TeamMatchParticipation(id: 1, membership: r1, lineup: home, weightClass: wc57, weight: 55.8));
    _participations.add(TeamMatchParticipation(id: 2, membership: r2, lineup: home, weightClass: wc61, weight: 60.15));
    _participations.add(TeamMatchParticipation(id: 3, membership: r3, lineup: home, weightClass: wc75A, weight: 73.3));
    _participations.add(TeamMatchParticipation(id: 4, membership: r4, lineup: home, weightClass: wc130, weight: 133.5));
    _participations.add(TeamMatchParticipation(id: 5, membership: b1, lineup: guest, weightClass: wc57, weight: 57.0));
    _participations.add(TeamMatchParticipation(id: 6, membership: b2, lineup: guest, weightClass: wc66));
    _participations.add(TeamMatchParticipation(id: 7, membership: b3, lineup: guest, weightClass: wc75A, weight: 72.4));
    _participations
        .add(TeamMatchParticipation(id: 8, membership: b4, lineup: guest, weightClass: wc130, weight: 129.9));

    Person referee = const Person(id: 9, prename: 'Mr', surname: 'Referee', gender: Gender.male);
    Person judge = const Person(id: 10, prename: 'Mrs', surname: 'Judge', gender: Gender.female);
    Person matChairman = const Person(id: 11, prename: 'Mr', surname: 'Chairman', gender: Gender.male);
    Person timeKeeper = const Person(id: 12, prename: 'Mr', surname: 'Time-Keeper', gender: Gender.male);
    Person transcriptWriter = const Person(id: 12, prename: 'Mrs', surname: 'Transcript-Writer', gender: Gender.female);
    return TeamMatch(
      id: 1,
      no: '123456',
      home: home,
      guest: guest,
      referee: referee,
      judge: judge,
      matChairman: matChairman,
      timeKeeper: timeKeeper,
      transcriptWriter: transcriptWriter,
      date: DateTime.now(),
      comment: 'Some commment',
      visitorsCount: 123,
      location: 'Springfield',
      league: _leagueMenRPW,
    );
  }

  late final _menRPWMatch = initMenRPWMatch();

  TeamMatch initJnRPWMatch() {
    TeamLineup home = TeamLineup(id: 3, team: _homeTeamJuniors);
    TeamLineup guest = TeamLineup(id: 4, team: _guestTeam);
    _lineups.add(home);
    _lineups.add(guest);

    // Miss participants

    Person referee = const Person(id: 10, prename: 'Mr', surname: 'Schiri', gender: Gender.male);
    return TeamMatch(
      id: 2,
      home: home,
      guest: guest,
      referee: referee,
      location: 'Springfield',
      date: DateTime.now(),
      league: _leagueJnRPW,
    );
  }

  late final _jnRPWMatch = initJnRPWMatch();

  late final _bout1 = Bout(
    id: 1,
    r: AthleteBoutState(id: 1, membership: r1, classificationPoints: 5),
    b: AthleteBoutState(id: 2, membership: b1, classificationPoints: 0),
    organization: _organization,
    result: BoutResult.vca,
    winnerRole: BoutRole.red,
    duration: Duration(seconds: 180),
  );

  late final _bout2 = Bout(
    id: 2,
    r: AthleteBoutState(id: 3, membership: r2, classificationPoints: 1),
    b: AthleteBoutState(id: 4, membership: b2, classificationPoints: 3),
    organization: _organization,
    result: BoutResult.vca,
    winnerRole: BoutRole.blue,
    duration: Duration(seconds: 180),
  );

  late final _bout3 = Bout(
    id: 3,
    r: AthleteBoutState(id: 5, membership: r1),
    b: AthleteBoutState(id: 6, membership: b2),
    organization: _organization,
  );

  late final _bout4 = Bout(
    id: 3,
    r: AthleteBoutState(id: 7, membership: r2),
    b: AthleteBoutState(id: 8, membership: b1),
    organization: _organization,
  );

  late final tmb1 = TeamMatchBout(
    id: 1,
    teamMatch: _menRPWMatch,
    pos: 0,
    organization: _organization,
    weightClass: wc57,
    bout: _bout1,
  );

  late final tmb2 = TeamMatchBout(
    id: 2,
    teamMatch: _menRPWMatch,
    pos: 1,
    organization: _organization,
    weightClass: wc61,
    bout: _bout2,
  );

  late final _competition = Competition(
    id: 1,
    no: 'abc',
    name: 'Wittelsbacher-Land-Turnier',
    boutConfig: Competition.defaultBoutConfig,
    date: DateTime(2025, 03, 29),
    organization: _organization,
    comment: 'This is a comment',
    location: 'Aichach',
    visitorsCount: 500,
    matCount: 6,
  );

  late final _competitionSystemAffiliationNordic = CompetitionSystemAffiliation(
      id: 0, competitionSystem: CompetitionSystem.nordic, competition: _competition, maxContestants: 6);
  late final _competitionSystemAffiliationTwoPools =
      CompetitionSystemAffiliation(id: 1, competitionSystem: CompetitionSystem.twoPools, competition: _competition);

  late final _ageCategoryAJuniors =
      AgeCategory(id: 0, name: 'A-Juniors', minAge: 16, maxAge: 18, organization: _organization);
  late final _ageCategoryCJuniors =
      AgeCategory(id: 1, name: 'C-Juniors', minAge: 12, maxAge: 14, organization: _organization);

  late final _competitionLineup1 = CompetitionLineup(id: 0, competition: _competition, club: _homeClub);
  late final _competitionLineup2 = CompetitionLineup(id: 1, competition: _competition, club: _guestClub);
  late final _competitionWeightCategory =
      CompetitionWeightCategory(id: 1, competition: _competition, weightClass: wc61, ageCategory: _ageCategoryAJuniors);

  late final _competitionWeightCategory2 =
      CompetitionWeightCategory(id: 2, competition: _competition, weightClass: wc57, ageCategory: _ageCategoryCJuniors);

  late final _competitionParticipation1 = CompetitionParticipation(
    id: 1,
    poolDrawNumber: 1,
    membership: r1,
    lineup: _competitionLineup1,
    weightCategory: _competitionWeightCategory,
    weight: 61,
  );

  late final _competitionParticipation2 = CompetitionParticipation(
    id: 2,
    poolDrawNumber: 2,
    membership: b1,
    lineup: _competitionLineup2,
    weightCategory: _competitionWeightCategory,
    weight: 60.3,
  );

  late final _competitionParticipation3 = CompetitionParticipation(
    id: 3,
    poolDrawNumber: 3,
    membership: r2,
    lineup: _competitionLineup2,
    weightCategory: _competitionWeightCategory,
    weight: 59.2,
    disqualified: true,
    eliminated: true,
  );

  late final _competitionParticipation4 = CompetitionParticipation(
    id: 4,
    poolDrawNumber: 4,
    membership: b2,
    lineup: _competitionLineup2,
    weightCategory: _competitionWeightCategory,
    weight: 59.4,
  );

  late final _competitionBout1 = CompetitionBout(
    id: 1,
    competition: _competition,
    pos: 0,
    mat: 0,
    bout: _bout1,
    round: 0,
    weightCategory: _competitionWeightCategory,
  );

  late final _competitionBout2 = CompetitionBout(
    id: 2,
    competition: _competition,
    pos: 1,
    mat: 2,
    bout: _bout2,
    round: 0,
    weightCategory: _competitionWeightCategory,
  );

  late final _competitionBout3 = CompetitionBout(
    id: 3,
    competition: _competition,
    pos: 3,
    bout: _bout3,
    round: 1,
    weightCategory: _competitionWeightCategory,
  );

  late final _competitionBout4 = CompetitionBout(
    id: 4,
    competition: _competition,
    pos: 4,
    bout: _bout4,
    round: 1,
    weightCategory: _competitionWeightCategory,
  );

  late final _boutAction1 = BoutAction(
      actionType: BoutActionType.points,
      bout: _bout1,
      duration: Duration(seconds: 29),
      role: BoutRole.red,
      pointCount: 4);
  late final _boutAction2 = BoutAction(
      actionType: BoutActionType.caution, bout: _bout2, duration: Duration(seconds: 129), role: BoutRole.blue);
  late final _boutAction3 = BoutAction(
      actionType: BoutActionType.points,
      bout: _bout2,
      duration: Duration(seconds: 100),
      role: BoutRole.red,
      pointCount: 2);

  late final List<Club> _clubs = [_homeClub, _guestClub];
  late final List<BoutAction> _boutActions = [_boutAction1, _boutAction2, _boutAction3];
  late final List<Organization> _organizations = [_organization, _organization2];
  late final List<Division> _divisions = [_juniorDivision, _adultDivision];
  late final List<League> _leagues = [_leagueMenRPW, _leagueJnRPW, _leagueNational];
  late final List<DivisionWeightClass> _divisionWeightClasses = []; // TODO fill
  late final List<LeagueWeightClass> _leagueWeightClasses = []; // TODO fill
  late final List<LeagueTeamParticipation> _leagueTeamParticipations = [
    _htMenRPW,
    _gtMenRPW,
    _htjJnRPW,
    _htNat,
    _gtNat
  ];
  late final List<TeamLineup> _lineups = [];
  late final List<Membership> _memberships = [r1, r2, r3, r4, b1, b2, b3, b4];
  late final List<TeamMatchParticipation> _participations = []; // TODO fill
  late final List<AthleteBoutState> _participantStates = []; // TODO fill
  late final List<Person> _persons = [p1, p2, p3, p4, p5, p6, p7, p8];
  late final List<Team> _teams = [_homeTeam, _homeTeamJuniors, _guestTeam];
  late final List<TeamClubAffiliation> _teamClubAffiliations = [
    _homeTeamAffiliation,
    _homeTeamJuniorsAffiliation,
    _guestTeamAffiliation
  ];

  late final List<WeightClass> _weightClasses = [wc57, wc130, wc61, wc98, wc66, wc86, wc71, wc80, wc75A, wc75B];
  late final List<BoutConfig> _boutConfigs = [_boutConfig];
  late final List<BoutResultRule> _boutResultRules = []; // TODO fill

  late final List<TeamMatch> _teamMatches = [_menRPWMatch, _jnRPWMatch];
  late final List<TeamMatchBout> _teamMatchBouts = [tmb1, tmb2];

  late final List<AgeCategory> _ageCategories = [_ageCategoryAJuniors, _ageCategoryCJuniors];

  late final List<Competition> _competitions = [_competition];
  late final List<CompetitionSystemAffiliation> _competitionSystemAffiliations = [
    _competitionSystemAffiliationNordic,
    _competitionSystemAffiliationTwoPools,
  ];
  late final List<CompetitionBout> _competitionBouts = [
    _competitionBout1,
    _competitionBout2,
    _competitionBout3,
    _competitionBout4,
  ];
  late final List<CompetitionWeightCategory> _competitionWeightCategories = [
    _competitionWeightCategory,
    _competitionWeightCategory2,
  ];
  late final List<CompetitionLineup> _competitionLineups = [_competitionLineup1, _competitionLineup2];
  late final List<CompetitionParticipation> _competitionParticipations = [
    _competitionParticipation1,
    _competitionParticipation2,
    _competitionParticipation3,
    _competitionParticipation4,
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

  List<TeamLineup> getLineups() => _lineups;

  List<Membership> getMemberships() => _memberships;

  List<Membership> getMembershipsOfClub(Club club) {
    return getMemberships().where((element) => element.club == club).toList();
  }

  List<TeamMatchParticipation> getParticipations() => _participations;

  List<TeamMatchParticipation> getParticipationsOfLineup(TeamLineup lineup) {
    return getParticipations().where((element) => element.lineup == lineup).toList();
  }

  List<AthleteBoutState> getParticipantStates() => _participantStates;

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

  List<Bout> getBouts() => [
        ..._teamMatchBouts.map((e) => e.bout),
        ..._competitionBouts.map((e) => e.bout),
      ];

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
