import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/gender.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/lineup.dart';
import 'package:wrestling_scoreboard/data/participant.dart';
import 'package:wrestling_scoreboard/data/participant_status.dart';
import 'package:wrestling_scoreboard/data/person.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/team_match.dart';
import 'package:wrestling_scoreboard/data/weight_class.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';

League leagueMenRPW = League(name: 'Real Pro Wrestling', year: DateTime(2021));
League leagueJnRPW = League(name: 'Real Pro Wrestling Jn', year: DateTime(2021));
League leagueNational = League(name: 'National League', year: DateTime(2021));
List<League> leagues = [leagueMenRPW, leagueJnRPW, leagueNational];

Club homeClub = Club(name: 'Springfield Wrestlers');
Club guestClub = Club(name: 'Quahog Hunters');
List<Club> clubs = [homeClub, guestClub];

Team homeTeam = Team(name: 'Springfield Wrestlers', club: homeClub, description: '1. Team Men', league: leagueMenRPW);
Team homeTeamJuniors =
    Team(name: 'Springfield Wrestlers Jn', club: homeClub, description: 'Juniors', league: leagueJnRPW);
Team guestTeam = Team(name: 'Quahog Hunters II', club: guestClub, description: '2. Team Men', league: leagueMenRPW);
List<Team> teams = [homeTeam, homeTeamJuniors, guestTeam];

List<TeamMatch> matches = [initMenRPWMatch(), initJnRPWMatch()];

// TEAM 1
WeightClass wc57 = WeightClass(57, WrestlingStyle.free);
WeightClass wc130 = WeightClass(130, WrestlingStyle.greco);
WeightClass wc61 = WeightClass(61, WrestlingStyle.greco);
WeightClass wc66 = WeightClass(66, WrestlingStyle.free);
WeightClass wc75 = WeightClass(75, WrestlingStyle.free, name: '75 kg A');

Participant r1 = Participant(prename: 'Lisa', surname: 'Simpson', gender: Gender.female);
Participant r2 = Participant(prename: 'Bart', surname: 'Simpson', gender: Gender.male);
Participant r3 = Participant(prename: 'March', surname: 'Simpson', gender: Gender.female);
Participant r4 = Participant(prename: 'Homer', surname: 'Simpson', gender: Gender.male);
ParticipantStatus rS1 = ParticipantStatus(participant: r1, weightClass: wc57);
ParticipantStatus rS2 = ParticipantStatus(participant: r2, weightClass: wc61);
ParticipantStatus rS3 = ParticipantStatus(participant: r3, weightClass: wc75);
ParticipantStatus rS4 = ParticipantStatus(participant: r4, weightClass: wc130);

// TEAM 2
Participant b1 = Participant(prename: 'Meg', surname: 'Griffin', gender: Gender.female);
Participant b2 = Participant(prename: 'Chris', surname: 'Griffin', gender: Gender.male);
Participant b3 = Participant(prename: 'Lois', surname: 'Griffin', gender: Gender.female);
Participant b4 = Participant(prename: 'Peter', surname: 'Griffin', gender: Gender.male);
ParticipantStatus bS1 = ParticipantStatus(participant: b1, weightClass: wc57);
ParticipantStatus bS2 = ParticipantStatus(participant: b2, weightClass: wc66);
ParticipantStatus bS3 = ParticipantStatus(participant: b3, weightClass: wc75);
ParticipantStatus bS4 = ParticipantStatus(participant: b4, weightClass: wc130);

TeamMatch initMenRPWMatch() {
  Lineup home = Lineup(team: homeTeam, participantStatusList: [rS1, rS2, rS3, rS4]);
  Lineup guest = Lineup(team: guestTeam, participantStatusList: [bS1, bS2, bS3, bS4]);

  Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
  return TeamMatch(home, guest, referee, location: 'Springfield');
}

TeamMatch initJnRPWMatch() {
  Lineup home = Lineup(team: homeTeamJuniors, participantStatusList: [rS1, rS2, rS3, rS4]);
  Lineup guest = Lineup(team: guestTeam, participantStatusList: [bS1, bS2, bS3, bS4]);

  Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
  return TeamMatch(home, guest, referee, location: 'Springfield');
}

List<Club> getClubs() => clubs;

List<League> getLeagues() => leagues;

List<Team> getTeams() => teams;

List<TeamMatch> getMatches() => matches;

List<Team> getTeamsOfClub(Club club) {
  return getTeams().where((element) => element.club == club).toList();
}

List<Team> getTeamsOfLeague(League league) {
  return getTeams().where((element) => element.league == league).toList();
}

List<TeamMatch> getMatchesOfTeam(Team team) {
  return getMatches().where((element) => element.home.team == team || element.guest.team == team).toList();
}
