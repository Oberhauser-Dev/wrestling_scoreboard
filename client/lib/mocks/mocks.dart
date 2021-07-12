import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/membership.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';

ClientLeague leagueMenRPW = ClientLeague(name: 'Real Pro Wrestling', startDate: DateTime(2021));
ClientLeague leagueJnRPW = ClientLeague(name: 'Real Pro Wrestling Jn', startDate: DateTime(2021));
ClientLeague leagueNational = ClientLeague(name: 'National League', startDate: DateTime(2021));

ClientClub homeClub = ClientClub(name: 'Springfield Wrestlers');
ClientClub guestClub = ClientClub(name: 'Quahog Hunters');

ClientTeam homeTeam =
    ClientTeam(name: 'Springfield Wrestlers', club: homeClub, description: '1. Team Men', league: leagueMenRPW);
ClientTeam homeTeamJuniors =
    ClientTeam(name: 'Springfield Wrestlers Jn', club: homeClub, description: 'Juniors', league: leagueJnRPW);
ClientTeam guestTeam =
    ClientTeam(name: 'Quahog Hunters II', club: guestClub, description: '2. Team Men', league: leagueMenRPW);

List<ClientTeamMatch> matches = [initMenRPWMatch(), initJnRPWMatch()];

// TEAM 1
WeightClass wc57 = WeightClass(weight: 57, style: WrestlingStyle.free);
WeightClass wc130 = WeightClass(weight: 130, style: WrestlingStyle.greco);
WeightClass wc61 = WeightClass(weight: 61, style: WrestlingStyle.greco);
WeightClass wc66 = WeightClass(weight: 66, style: WrestlingStyle.free);
WeightClass wc75 = WeightClass(weight: 75, style: WrestlingStyle.free, name: '75 kg A');

Person p1 = Person(prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
Person p2 = Person(prename: 'Bart', surname: 'Simpson', gender: Gender.male);
Person p3 = Person(prename: 'March', surname: 'Simpson', gender: Gender.female);
Person p4 = Person(prename: 'Homer', surname: 'Simpson', gender: Gender.male);
ClientMembership r1 = ClientMembership(person: p1, club: homeClub);
ClientMembership r2 = ClientMembership(person: p2, club: homeClub);
ClientMembership r3 = ClientMembership(person: p3, club: homeClub);
ClientMembership r4 = ClientMembership(person: p4, club: homeClub);

// TEAM 2
Person p5 = Person(prename: 'Meg', surname: 'Griffin', gender: Gender.female);
Person p6 = Person(prename: 'Chris', surname: 'Griffin', gender: Gender.male);
Person p7 = Person(prename: 'Lois', surname: 'Griffin', gender: Gender.female);
Person p8 = Person(prename: 'Peter', surname: 'Griffin', gender: Gender.male);
ClientMembership b1 = ClientMembership(person: p5, club: guestClub);
ClientMembership b2 = ClientMembership(person: p6, club: guestClub);
ClientMembership b3 = ClientMembership(person: p7, club: guestClub);
ClientMembership b4 = ClientMembership(person: p8, club: guestClub);

final List<Participation> participations = [];

ClientTeamMatch initMenRPWMatch() {
  ClientLineup home = ClientLineup(team: homeTeam);
  ClientLineup guest = ClientLineup(team: guestTeam);

  participations.add(Participation(membership: r1, lineup: home, weightClass: wc57));
  participations.add(Participation(membership: r1, lineup: home, weightClass: wc61));
  participations.add(Participation(membership: r1, lineup: home, weightClass: wc75));
  participations.add(Participation(membership: r1, lineup: home, weightClass: wc130));
  participations.add(Participation(membership: r1, lineup: guest, weightClass: wc57));
  participations.add(Participation(membership: r1, lineup: guest, weightClass: wc66));
  participations.add(Participation(membership: r1, lineup: guest, weightClass: wc75));
  participations.add(Participation(membership: r1, lineup: guest, weightClass: wc130));

  Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
  return ClientTeamMatch(home, guest, referee, location: 'Springfield');
}

ClientTeamMatch initJnRPWMatch() {
  ClientLineup home = ClientLineup(team: homeTeamJuniors);
  ClientLineup guest = ClientLineup(team: guestTeam);

  // Miss participants

  Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
  return ClientTeamMatch(home, guest, referee, location: 'Springfield');
}

List<ClientTeamMatch> getMatches() => matches;

List<Participation> getParticipations() => participations;

List<ClientTeamMatch> getMatchesOfTeam(ClientTeam team) {
  return getMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}
