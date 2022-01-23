import 'package:common/common.dart';

League _leagueMenRPW = League(id: 1, name: 'Real Pro Wrestling', startDate: DateTime(2021));
League _leagueJnRPW = League(id: 2, name: 'Real Pro Wrestling Jn', startDate: DateTime(2021));
League _leagueNational = League(id: 3, name: 'National League', startDate: DateTime(2021));

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

List<Club> _clubs = [_homeClub, _guestClub];

List<League> _leagues = [_leagueMenRPW, _leagueJnRPW, _leagueNational];

List<Team> _teams = [_homeTeam, _homeTeamJuniors, _guestTeam];

List<TeamMatch> _matches = [initMenRPWMatch(), initJnRPWMatch()];

List<Fight> _fights = [];

List<TeamMatchFight> _teamMatchFights = [];

List<TournamentFight> _tournamentFights = [];

WeightClass wc57 = WeightClass(id: 1, weight: 57, style: WrestlingStyle.free);
WeightClass wc130 = WeightClass(id: 2, weight: 130, style: WrestlingStyle.greco);
WeightClass wc61 = WeightClass(id: 3, weight: 61, style: WrestlingStyle.greco);
WeightClass wc98 = WeightClass(id: 4, weight: 98, style: WrestlingStyle.free);
WeightClass wc66 = WeightClass(id: 5, weight: 66, style: WrestlingStyle.free);
WeightClass wc86 = WeightClass(id: 6, weight: 86, style: WrestlingStyle.greco);
WeightClass wc71 = WeightClass(id: 7, weight: 71, style: WrestlingStyle.greco);
WeightClass wc80 = WeightClass(id: 8, weight: 80, style: WrestlingStyle.free);
WeightClass wc75A = WeightClass(id: 9, weight: 75, style: WrestlingStyle.free, name: '75 kg A');
WeightClass wc75B = WeightClass(id: 10, weight: 75, style: WrestlingStyle.greco, name: '75 kg B');

final List<WeightClass> weightClasses = [wc57, wc130, wc61, wc98, wc66, wc86, wc71, wc80, wc75A, wc75B];

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

final List<Membership> _memberships = [r1, r2, r3, r4, b1, b2, b3, b4];

final List<Participation> _participations = [];
final List<Lineup> _lineups = [];

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
  return TeamMatch(
      id: 1,
      home: home,
      guest: guest,
      ex_weightClasses: weightClasses,
      ex_referees: [referee],
      location: 'Springfield');
}

TeamMatch initJnRPWMatch() {
  Lineup home = Lineup(id: 3, team: _homeTeamJuniors);
  Lineup guest = Lineup(id: 4, team: _guestTeam);
  _lineups.add(home);
  _lineups.add(guest);

  // Miss participants

  Person referee = Person(id: 10, prename: 'Mr', surname: 'Schiri', gender: Gender.male);
  return TeamMatch(
      id: 2,
      home: home,
      guest: guest,
      ex_weightClasses: weightClasses,
      ex_referees: [referee],
      location: 'Springfield');
}

List<Club> getClubs() => _clubs;

List<League> getLeagues() => _leagues;

List<Team> getTeams() => _teams;

List<Membership> getMemberships() => _memberships;

List<Lineup> getLineups() => _lineups;

List<TeamMatch> getTeamMatches() => _matches;

List<Participation> getParticipations() => _participations;

List<Fight> getFights() => _fights;

List<TeamMatchFight> getTeamMatchFights() => _teamMatchFights;

List<TournamentFight> getTournamentFights() => _tournamentFights;

List<Participation> getParticipationsOfLineup(Lineup lineup) {
  return getParticipations().where((element) => element.lineup == lineup).toList();
}

List<Membership> getMembershipsOfClub(Club club) {
  return getMemberships().where((element) => element.club == club).toList();
}

List<Team> getTeamsOfClub(Club club) {
  return getTeams().where((element) => element.club == club).toList();
}

List<Team> getTeamsOfLeague(League league) {
  return getTeams().where((element) => element.league == league).toList();
}

List<TeamMatch> getMatchesOfTeam(Team team) {
  return getTeamMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}

List<Fight> getFightsOfTournament(Tournament tournament) {
  return getTournamentFights().where((element) => element.tournament == tournament).map((e) => e.fight).toList();
}

List<Fight> getFightsOfTeamMatch(TeamMatch match) {
  return getTeamMatchFights().where((element) => element.teamMatch == match).map((e) => e.fight).toList();
}
