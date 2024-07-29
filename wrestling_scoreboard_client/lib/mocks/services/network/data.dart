import 'package:wrestling_scoreboard_common/common.dart';

const _organization = Organization(name: 'Deutscher Ringer Bund (DRB)');

final _adultDivision = Division(
  id: 1,
  name: 'Adult',
  startDate: DateTime(2021),
  endDate: DateTime(2022),
  boutConfig: const BoutConfig(id: 1),
  seasonPartitions: 2,
  organization: _organization,
);

final _juniorDivision = Division(
  id: 2,
  name: 'Junior',
  startDate: DateTime(2021),
  endDate: DateTime(2022),
  boutConfig: const BoutConfig(id: 1),
  seasonPartitions: 2,
  organization: _organization,
);

final _leagueMenRPW = League(
  id: 1,
  name: 'Real Pro Wrestling',
  startDate: DateTime(2021),
  endDate: DateTime(2022),
  division: _adultDivision,
  boutDays: 14,
);
final _leagueJnRPW = League(
  id: 2,
  name: 'Real Pro Wrestling Jn',
  startDate: DateTime(2021),
  endDate: DateTime(2022),
  division: _juniorDivision,
  boutDays: 14,
);
final _leagueNational = League(
  id: 3,
  name: 'National League',
  startDate: DateTime(2021),
  endDate: DateTime(2022),
  division: _adultDivision,
  boutDays: 14,
);

Club _homeClub = const Club(id: 1, name: 'Springfield Wrestlers', organization: _organization);
Club _guestClub = const Club(id: 2, name: 'Quahog Hunters', organization: _organization);

Team _homeTeam = Team(
  id: 1,
  name: 'Springfield Wrestlers',
  club: _homeClub,
  description: '1. Team Men',
);
Team _homeTeamJuniors = Team(
  id: 2,
  name: 'Springfield Wrestlers Jn',
  club: _homeClub,
  description: 'Juniors',
);
Team _guestTeam = Team(
  id: 3,
  name: 'Quahog Hunters II',
  club: _guestClub,
  description: '2. Team Men',
);

// Teams per League
LeagueTeamParticipation _htMenRPW = LeagueTeamParticipation(id: 1, league: _leagueMenRPW, team: _homeTeam);
LeagueTeamParticipation _htjJnRPW = LeagueTeamParticipation(id: 2, league: _leagueJnRPW, team: _homeTeamJuniors);
LeagueTeamParticipation _gtMenRPW = LeagueTeamParticipation(id: 3, league: _leagueMenRPW, team: _guestTeam);
LeagueTeamParticipation _htNat = LeagueTeamParticipation(id: 4, league: _leagueNational, team: _homeTeam);
LeagueTeamParticipation _gtNat = LeagueTeamParticipation(id: 5, league: _leagueNational, team: _guestTeam);

WeightClass wc57 = const WeightClass(id: 1, weight: 57, style: WrestlingStyle.free);
WeightClass wc130 = const WeightClass(id: 2, weight: 130, style: WrestlingStyle.greco);
WeightClass wc61 = const WeightClass(id: 3, weight: 61, style: WrestlingStyle.greco);
WeightClass wc98 = const WeightClass(id: 4, weight: 98, style: WrestlingStyle.free);
WeightClass wc66 = const WeightClass(id: 5, weight: 66, style: WrestlingStyle.free);
WeightClass wc86 = const WeightClass(id: 6, weight: 86, style: WrestlingStyle.greco);
WeightClass wc71 = const WeightClass(id: 7, weight: 71, style: WrestlingStyle.greco);
WeightClass wc80 = const WeightClass(id: 8, weight: 80, style: WrestlingStyle.free);
WeightClass wc75A = const WeightClass(id: 9, weight: 75, style: WrestlingStyle.free, suffix: 'A');
WeightClass wc75B = const WeightClass(id: 10, weight: 75, style: WrestlingStyle.greco, suffix: 'B');

// TEAM 1
Person p1 = const Person(id: 1, prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
Person p2 = const Person(id: 2, prename: 'Bart', surname: 'Simpson', gender: Gender.male);
Person p3 = const Person(id: 3, prename: 'March', surname: 'Simpson', gender: Gender.female);
Person p4 = const Person(id: 4, prename: 'Homer', surname: 'Simpson', gender: Gender.male);
Membership r1 = Membership(id: 1, person: p1, club: _homeClub);
Membership r2 = Membership(id: 2, person: p2, club: _homeClub);
Membership r3 = Membership(id: 3, person: p3, club: _homeClub);
Membership r4 = Membership(id: 4, person: p4, club: _homeClub);

// TEAM 2
Person p5 = const Person(id: 5, prename: 'Meg', surname: 'Griffin', gender: Gender.female);
Person p6 = const Person(id: 6, prename: 'Chris', surname: 'Griffin', gender: Gender.male);
Person p7 = const Person(id: 7, prename: 'Lois', surname: 'Griffin', gender: Gender.female);
Person p8 = const Person(id: 8, prename: 'Peter', surname: 'Griffin', gender: Gender.male);
Membership b1 = Membership(id: 5, person: p5, club: _guestClub);
Membership b2 = Membership(id: 6, person: p6, club: _guestClub);
Membership b3 = Membership(id: 7, person: p7, club: _guestClub);
Membership b4 = Membership(id: 8, person: p8, club: _guestClub);

final List<Club> _clubs = [_homeClub, _guestClub];
final List<Bout> _bouts = [];
final List<BoutAction> _boutActions = []; // TODO fill
final List<Organization> _organizations = [_organization];
final List<Division> _divisions = [_juniorDivision, _adultDivision];
final List<League> _leagues = [_leagueMenRPW, _leagueJnRPW, _leagueNational];
final List<DivisionWeightClass> _divisionWeightClasses = []; // TODO fill
final List<LeagueTeamParticipation> _leagueTeamParticipations = [_htMenRPW, _gtMenRPW, _htjJnRPW, _htNat, _gtNat];
final List<Lineup> _lineups = [];
final List<Membership> _memberships = [r1, r2, r3, r4, b1, b2, b3, b4];
final List<Participation> _participations = [];
final List<ParticipantState> _participantStates = []; // TODO fill
final List<Person> _persons = []; // TODO fill
final List<Team> _teams = [_homeTeam, _homeTeamJuniors, _guestTeam];
final List<TeamMatch> _teamMatches = [initMenRPWMatch(), initJnRPWMatch()];
final List<TeamMatchBout> _teamMatchBouts = [];
final List<CompetitionBout> _competitionBouts = [];
final List<WeightClass> _weightClasses = [wc57, wc130, wc61, wc98, wc66, wc86, wc71, wc80, wc75A, wc75B];

TeamMatch initMenRPWMatch() {
  Lineup home = Lineup(id: 1, team: _homeTeam);
  Lineup guest = Lineup(id: 2, team: _guestTeam);
  _lineups.add(home);
  _lineups.add(guest);
  _participations.add(Participation(id: 1, membership: r1, lineup: home, weightClass: wc57, weight: 55.8));
  _participations.add(Participation(id: 2, membership: r2, lineup: home, weightClass: wc61, weight: 60.15));
  _participations.add(Participation(id: 3, membership: r3, lineup: home, weightClass: wc75A, weight: 73.3));
  _participations.add(Participation(id: 4, membership: r4, lineup: home, weightClass: wc130, weight: 133.5));
  _participations.add(Participation(id: 5, membership: b1, lineup: guest, weightClass: wc57, weight: 57.0));
  _participations.add(Participation(id: 6, membership: b2, lineup: guest, weightClass: wc66));
  _participations.add(Participation(id: 7, membership: b3, lineup: guest, weightClass: wc75A, weight: 72.4));
  _participations.add(Participation(id: 8, membership: b4, lineup: guest, weightClass: wc130, weight: 129.9));

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
      location: 'Springfield');
}

TeamMatch initJnRPWMatch() {
  Lineup home = Lineup(id: 3, team: _homeTeamJuniors);
  Lineup guest = Lineup(id: 4, team: _guestTeam);
  _lineups.add(home);
  _lineups.add(guest);

  // Miss participants

  Person referee = const Person(id: 10, prename: 'Mr', surname: 'Schiri', gender: Gender.male);
  return TeamMatch(id: 2, home: home, guest: guest, referee: referee, location: 'Springfield', date: DateTime.now());
}

List<Club> getClubs() => _clubs;

List<Bout> getBouts() => _bouts;

List<Bout> getBoutsOfCompetition(Competition competition) {
  return getCompetitionBouts().where((element) => element.competition == competition).map((e) => e.bout).toList();
}

List<Bout> getBoutsOfTeamMatch(TeamMatch match) {
  return getTeamMatchBouts().where((element) => element.teamMatch == match).map((e) => e.bout).toList();
}

List<BoutAction> getBoutActions() => _boutActions;

List<BoutAction> getBoutActionsOfBout(Bout bout) => getBoutActions().where((element) => element.bout == bout).toList();

List<Organization> getOrganizations() => _organizations;

List<Division> getDivisions() => _divisions;

List<League> getLeagues() => _leagues;

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

List<Lineup> getLineups() => _lineups;

List<Membership> getMemberships() => _memberships;

List<Membership> getMembershipsOfClub(Club club) {
  return getMemberships().where((element) => element.club == club).toList();
}

List<Participation> getParticipations() => _participations;

List<Participation> getParticipationsOfLineup(Lineup lineup) {
  return getParticipations().where((element) => element.lineup == lineup).toList();
}

List<ParticipantState> getParticipantStates() => _participantStates;

List<Person> getPersons() => _persons;

List<Team> getTeams() => _teams;

List<Team> getTeamsOfClub(Club club) {
  return getTeams().where((element) => element.club == club).toList();
}

List<Team> getTeamsOfLeague(League league) {
  return getLeagueTeamParticipationsOfLeague(league).map((e) => e.team).toList();
}

List<TeamMatch> getTeamMatches() => _teamMatches;

List<TeamMatch> getTeamMatchesOfTeam(Team team) {
  return getTeamMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}

List<TeamMatchBout> getTeamMatchBouts() => _teamMatchBouts;

List<TeamMatchBout> getTeamMatchBoutsOfTeamMatch(TeamMatch match) {
  return getTeamMatchBouts().where((element) => element.teamMatch == match).toList();
}

List<CompetitionBout> getCompetitionBouts() => _competitionBouts;

List<WeightClass> getWeightClasses() => _weightClasses;

List<WeightClass> getWeightClassesOfDivision(Division league) {
  return (getDivisionWeightClassesOfDivision(league).toList()..sort((a, b) => a.pos - b.pos))
      .map((e) => e.weightClass)
      .toList();
}
