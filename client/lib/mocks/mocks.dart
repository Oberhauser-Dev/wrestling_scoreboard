import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/participant.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';

ClientLeague leagueMenRPW = ClientLeague(name: 'Real Pro Wrestling', year: DateTime(2021));
ClientLeague leagueJnRPW = ClientLeague(name: 'Real Pro Wrestling Jn', year: DateTime(2021));
ClientLeague leagueNational = ClientLeague(name: 'National League', year: DateTime(2021));
List<ClientLeague> leagues = [leagueMenRPW, leagueJnRPW, leagueNational];

ClientClub homeClub = ClientClub(name: 'Springfield Wrestlers');
ClientClub guestClub = ClientClub(name: 'Quahog Hunters');
List<ClientClub> clubs = [homeClub, guestClub];

ClientTeam homeTeam =
    ClientTeam(name: 'Springfield Wrestlers', club: homeClub, description: '1. Team Men', league: leagueMenRPW);
ClientTeam homeTeamJuniors =
    ClientTeam(name: 'Springfield Wrestlers Jn', club: homeClub, description: 'Juniors', league: leagueJnRPW);
ClientTeam guestTeam =
    ClientTeam(name: 'Quahog Hunters II', club: guestClub, description: '2. Team Men', league: leagueMenRPW);
List<ClientTeam> teams = [homeTeam, homeTeamJuniors, guestTeam];

List<ClientTeamMatch> matches = [initMenRPWMatch(), initJnRPWMatch()];

// TEAM 1
WeightClass wc57 = WeightClass(57, WrestlingStyle.free);
WeightClass wc130 = WeightClass(130, WrestlingStyle.greco);
WeightClass wc61 = WeightClass(61, WrestlingStyle.greco);
WeightClass wc66 = WeightClass(66, WrestlingStyle.free);
WeightClass wc75 = WeightClass(75, WrestlingStyle.free, name: '75 kg A');

ClientParticipant r1 = ClientParticipant(prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
ClientParticipant r2 = ClientParticipant(prename: 'Bart', surname: 'Simpson', gender: Gender.male);
ClientParticipant r3 = ClientParticipant(prename: 'March', surname: 'Simpson', gender: Gender.female);
ClientParticipant r4 = ClientParticipant(prename: 'Homer', surname: 'Simpson', gender: Gender.male);
ClientParticipantStatus rS1 = ClientParticipantStatus(participant: r1, weightClass: wc57);
ClientParticipantStatus rS2 = ClientParticipantStatus(participant: r2, weightClass: wc61);
ClientParticipantStatus rS3 = ClientParticipantStatus(participant: r3, weightClass: wc75);
ClientParticipantStatus rS4 = ClientParticipantStatus(participant: r4, weightClass: wc130);

// TEAM 2
ClientParticipant b1 = ClientParticipant(prename: 'Meg', surname: 'Griffin', gender: Gender.female);
ClientParticipant b2 = ClientParticipant(prename: 'Chris', surname: 'Griffin', gender: Gender.male);
ClientParticipant b3 = ClientParticipant(prename: 'Lois', surname: 'Griffin', gender: Gender.female);
ClientParticipant b4 = ClientParticipant(prename: 'Peter', surname: 'Griffin', gender: Gender.male);
ClientParticipantStatus bS1 = ClientParticipantStatus(participant: b1, weightClass: wc57);
ClientParticipantStatus bS2 = ClientParticipantStatus(participant: b2, weightClass: wc66);
ClientParticipantStatus bS3 = ClientParticipantStatus(participant: b3, weightClass: wc75);
ClientParticipantStatus bS4 = ClientParticipantStatus(participant: b4, weightClass: wc130);

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

List<ClientClub> getClubs() => clubs;

List<ClientLeague> getLeagues() => leagues;

List<ClientTeam> getTeams() => teams;

List<ClientTeamMatch> getMatches() => matches;

List<ClientTeam> getTeamsOfClub(ClientClub club) {
  return getTeams().where((element) => element.club == club).toList();
}

List<ClientTeam> getTeamsOfLeague(ClientLeague league) {
  return getTeams().where((element) => element.league == league).toList();
}

List<ClientTeamMatch> getMatchesOfTeam(ClientTeam team) {
  return getMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}
