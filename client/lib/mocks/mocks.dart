import 'package:common/common.dart';

League _leagueMenRPW = League(
  id: 1,
  name: 'Real Pro Wrestling',
  startDate: DateTime(2021),
  boutConfig: BoutConfig(id: 1),
);
League _leagueJnRPW = League(
  id: 2,
  name: 'Real Pro Wrestling Jn',
  startDate: DateTime(2021),
  boutConfig: BoutConfig(id: 2),
);
League _leagueNational = League(
  id: 3,
  name: 'National League',
  startDate: DateTime(2021),
  boutConfig: BoutConfig(id: 3),
);

Club _homeClub = Club(id: 1, name: 'Springfield Wrestlers');
Club _guestClub = Club(id: 2, name: 'Quahog Hunters');

Team _homeTeam = Team(
  id: 1,
  name: 'Springfield Wrestlers',
  club: _homeClub,
  description: '1. Team Men',
  league: _leagueMenRPW,
);
Team _homeTeamJuniors = Team(
  id: 2,
  name: 'Springfield Wrestlers Jn',
  club: _homeClub,
  description: 'Juniors',
  league: _leagueJnRPW,
);
Team _guestTeam = Team(
  id: 3,
  name: 'Quahog Hunters II',
  club: _guestClub,
  description: '2. Team Men',
  league: _leagueMenRPW,
);

WeightClass wc57 = WeightClass(id: 1, weight: 57, style: WrestlingStyle.free);
WeightClass wc130 = WeightClass(id: 2, weight: 130, style: WrestlingStyle.greco);
WeightClass wc61 = WeightClass(id: 3, weight: 61, style: WrestlingStyle.greco);
WeightClass wc98 = WeightClass(id: 4, weight: 98, style: WrestlingStyle.free);
WeightClass wc66 = WeightClass(id: 5, weight: 66, style: WrestlingStyle.free);
WeightClass wc86 = WeightClass(id: 6, weight: 86, style: WrestlingStyle.greco);
WeightClass wc71 = WeightClass(id: 7, weight: 71, style: WrestlingStyle.greco);
WeightClass wc80 = WeightClass(id: 8, weight: 80, style: WrestlingStyle.free);
WeightClass wc75A = WeightClass(id: 9, weight: 75, style: WrestlingStyle.free, suffix: 'A');
WeightClass wc75B = WeightClass(id: 10, weight: 75, style: WrestlingStyle.greco, suffix: 'B');

// TEAM 1
Person p1 = Person(id: 1, prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
Person p2 = Person(id: 2, prename: 'Bart', surname: 'Simpson', gender: Gender.male);
Person p3 = Person(id: 3, prename: 'March', surname: 'Simpson', gender: Gender.female);
Person p4 = Person(id: 4, prename: 'Homer', surname: 'Simpson', gender: Gender.male);
Membership r1 = Membership(id: 1, person: p1, club: _homeClub);
Membership r2 = Membership(id: 2, person: p2, club: _homeClub);
Membership r3 = Membership(id: 3, person: p3, club: _homeClub);
Membership r4 = Membership(id: 4, person: p4, club: _homeClub);

// TEAM 2
Person p5 = Person(id: 5, prename: 'Meg', surname: 'Griffin', gender: Gender.female);
Person p6 = Person(id: 6, prename: 'Chris', surname: 'Griffin', gender: Gender.male);
Person p7 = Person(id: 7, prename: 'Lois', surname: 'Griffin', gender: Gender.female);
Person p8 = Person(id: 8, prename: 'Peter', surname: 'Griffin', gender: Gender.male);
Membership b1 = Membership(id: 5, person: p5, club: _guestClub);
Membership b2 = Membership(id: 6, person: p6, club: _guestClub);
Membership b3 = Membership(id: 7, person: p7, club: _guestClub);
Membership b4 = Membership(id: 8, person: p8, club: _guestClub);

final List<Club> _clubs = [_homeClub, _guestClub];
final List<Fight> _fights = [];
final List<FightAction> _fightActions = []; // TODO fill
final List<League> _leagues = [_leagueMenRPW, _leagueJnRPW, _leagueNational];
final List<LeagueWeightClass> _leagueWeightClasses = []; // TODO fill
final List<Lineup> _lineups = [];
final List<Membership> _memberships = [r1, r2, r3, r4, b1, b2, b3, b4];
final List<Participation> _participations = [];
final List<ParticipantState> _participantStates = []; // TODO fill
final List<Person> _persons = []; // TODO fill
final List<Team> _teams = [_homeTeam, _homeTeamJuniors, _guestTeam];
final List<TeamMatch> _teamMatches = [initMenRPWMatch(), initJnRPWMatch()];
final List<TeamMatchFight> _teamMatchFights = [];
final List<TournamentFight> _tournamentFights = [];
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

  Person referee = Person(id: 9, prename: 'Mr', surname: 'Referee', gender: Gender.male);
  Person judge = Person(id: 10, prename: 'Mrs', surname: 'Judge', gender: Gender.female);
  Person matChairman = Person(id: 11, prename: 'Mr', surname: 'Chairman', gender: Gender.male);
  Person timeKeeper = Person(id: 12, prename: 'Mr', surname: 'Time-Keeper', gender: Gender.male);
  Person transcriptWriter = Person(id: 12, prename: 'Mrs', surname: 'Transcript-Writer', gender: Gender.female);
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

  Person referee = Person(id: 10, prename: 'Mr', surname: 'Schiri', gender: Gender.male);
  return TeamMatch(id: 2, home: home, guest: guest, referee: referee, location: 'Springfield');
}

List<Club> getClubs() => _clubs;

List<Fight> getFights() => _fights;

List<Fight> getFightsOfTournament(Tournament tournament) {
  return getTournamentFights().where((element) => element.tournament == tournament).map((e) => e.fight).toList();
}

List<Fight> getFightsOfTeamMatch(TeamMatch match) {
  return getTeamMatchFights().where((element) => element.teamMatch == match).map((e) => e.fight).toList();
}

List<FightAction> getFightActions() => _fightActions;

List<FightAction> getFightActionsOfFight(Fight fight) =>
    getFightActions().where((element) => element.fight == fight).toList();

List<League> getLeagues() => _leagues;

List<LeagueWeightClass> getLeagueWeightClasses() => _leagueWeightClasses;

List<LeagueWeightClass> getLeagueWeightClassesOfLeague(League league) {
  return getLeagueWeightClasses().where((element) => element.league == league).toList();
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
  return getTeams().where((element) => element.league == league).toList();
}

List<TeamMatch> getTeamMatches() => _teamMatches;

List<TeamMatch> getTeamMatchesOfTeam(Team team) {
  return getTeamMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}

List<TeamMatchFight> getTeamMatchFights() => _teamMatchFights;

List<TeamMatchFight> getTeamMatchFightsOfTeamMatch(TeamMatch match) {
  return getTeamMatchFights().where((element) => element.teamMatch == match).toList();
}

List<TournamentFight> getTournamentFights() => _tournamentFights;

List<WeightClass> getWeightClasses() => _weightClasses;

List<WeightClass> getWeightClassesOfLeague(League league) {
  return (getLeagueWeightClasses().where((element) => element.league == league).toList()..sort((a, b) => a.pos - b.pos))
      .map((e) => e.weightClass)
      .toList();
}
