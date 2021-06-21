import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/data/weight_class.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_screen.dart';
import 'package:wrestling_scoreboard/ui/match_sequence.dart';

import 'data/fight.dart';
import 'data/gender.dart';
import 'data/lineup.dart';
import 'data/participant.dart';
import 'data/participant_status.dart';
import 'data/person.dart';
import 'data/team_match.dart';
import 'data/wrestling_style.dart';

void main() {
  runApp(WrestlingScoreboardApp());
}

class WrestlingScoreboardApp extends StatelessWidget {
  Locale _locale = Locale('en');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)?.appName ?? 'Wrestling Scoreboard',
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.dark,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('de', ''),
      ],
      locale: _locale,
      home: WrestlingScoreboardPage(),
    );
  }
}

class WrestlingScoreboardPage extends StatefulWidget {
  @override
  _WrestlingScoreboardPageState createState() => _WrestlingScoreboardPageState();
}

class _WrestlingScoreboardPageState extends State<WrestlingScoreboardPage> {
  @override
  Widget build(BuildContext context) {
    var match = initMatch();

    return Navigator(
      pages: [
        MaterialPage(
          key: ValueKey('MatchSequence'),
          child: MatchSequence(match, (Fight fight) => handleSelectedFight(fight, match)),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedFight to null
        return true;
      },
    );
  }

  handleSelectedFight(Fight fight, TeamMatch match) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FightScreen(match, fight)));
  }

  TeamMatch initMatch() {
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
    Team homeTeam = Team(name: 'Springfield Wrestlers');
    Lineup home = Lineup(team: homeTeam, participantStatusList: [rS1, rS2, rS3, rS4]);

    Participant b1 = Participant(prename: 'Meg', surname: 'Griffin', gender: Gender.female);
    Participant b2 = Participant(prename: 'Chris', surname: 'Griffin', gender: Gender.male);
    Participant b3 = Participant(prename: 'Lois', surname: 'Griffin', gender: Gender.female);
    Participant b4 = Participant(prename: 'Peter', surname: 'Griffin', gender: Gender.male);
    ParticipantStatus bS1 = ParticipantStatus(participant: b1, weightClass: wc57);
    ParticipantStatus bS2 = ParticipantStatus(participant: b2, weightClass: wc66);
    ParticipantStatus bS3 = ParticipantStatus(participant: b3, weightClass: wc75);
    ParticipantStatus bS4 = ParticipantStatus(participant: b4, weightClass: wc130);
    Team guestTeam = Team(name: 'Quahog Hunters');
    Lineup guest = Lineup(team: guestTeam, participantStatusList: [bS1, bS2, bS3, bS4]);

    Person referee = Person(prename: 'Mr', surname: 'Referee', gender: Gender.male);
    return TeamMatch(home, guest, referee);
  }
}
