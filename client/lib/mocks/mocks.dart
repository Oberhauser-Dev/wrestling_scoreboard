import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/participant.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
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
WeightClass wc57 = WeightClass(57, WrestlingStyle.free);
WeightClass wc130 = WeightClass(130, WrestlingStyle.greco);
WeightClass wc61 = WeightClass(61, WrestlingStyle.greco);
WeightClass wc66 = WeightClass(66, WrestlingStyle.free);
WeightClass wc75 = WeightClass(75, WrestlingStyle.free, name: '75 kg A');

Person p1 = Person(prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
Person p2 = Person(prename: 'Bart', surname: 'Simpson', gender: Gender.male);
Person p3 = Person(prename: 'March', surname: 'Simpson', gender: Gender.female);
Person p4 = Person(prename: 'Homer', surname: 'Simpson', gender: Gender.male);
ClientMembership r1 = ClientMembership(person: p1, club: homeClub);
ClientMembership r2 = ClientMembership(person: p2, club: homeClub);
ClientMembership r3 = ClientMembership(person: p3, club: homeClub);
ClientMembership r4 = ClientMembership(person: p4, club: homeClub);
ClientParticipantStatus rS1 = ClientParticipantStatus(memebership: r1, weightClass: wc57);
ClientParticipantStatus rS2 = ClientParticipantStatus(memebership: r2, weightClass: wc61);
ClientParticipantStatus rS3 = ClientParticipantStatus(memebership: r3, weightClass: wc75);
ClientParticipantStatus rS4 = ClientParticipantStatus(memebership: r4, weightClass: wc130);

// TEAM 2
Person p5 = Person(prename: 'Meg', surname: 'Griffin', gender: Gender.female);
Person p6 = Person(prename: 'Chris', surname: 'Griffin', gender: Gender.male);
Person p7 = Person(prename: 'Lois', surname: 'Griffin', gender: Gender.female);
Person p8 = Person(prename: 'Peter', surname: 'Griffin', gender: Gender.male);
ClientMembership b1 = ClientMembership(person: p5, club: guestClub);
ClientMembership b2 = ClientMembership(person: p6, club: guestClub);
ClientMembership b3 = ClientMembership(person: p7, club: guestClub);
ClientMembership b4 = ClientMembership(person: p8, club: guestClub);
ClientParticipantStatus bS1 = ClientParticipantStatus(memebership: b1, weightClass: wc57);
ClientParticipantStatus bS2 = ClientParticipantStatus(memebership: b2, weightClass: wc66);
ClientParticipantStatus bS3 = ClientParticipantStatus(memebership: b3, weightClass: wc75);
ClientParticipantStatus bS4 = ClientParticipantStatus(memebership: b4, weightClass: wc130);

ClientTeamMatch initMenRPWMatch() {
  ClientLineup home = ClientLineup(team: homeTeam, participantStatusList: [rS1, rS2, rS3, rS4]);
  ClientLineup guest = ClientLineup(team: guestTeam, participantStatusList: [bS1, bS2, bS3, bS4]);

  Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
  return ClientTeamMatch(home, guest, referee, location: 'Springfield');
}

ClientTeamMatch initJnRPWMatch() {
  ClientLineup home = ClientLineup(team: homeTeamJuniors, participantStatusList: [rS1, rS2, rS3, rS4]);
  ClientLineup guest = ClientLineup(team: guestTeam, participantStatusList: [bS1, bS2, bS3, bS4]);

  Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
  return ClientTeamMatch(home, guest, referee, location: 'Springfield');
}

List<ClientTeamMatch> getMatches() => matches;

List<ClientTeamMatch> getMatchesOfTeam(ClientTeam team) {
  return getMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}
