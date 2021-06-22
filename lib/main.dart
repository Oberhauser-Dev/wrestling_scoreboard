import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wrestling_scoreboard/ui/fight/fight_screen.dart';
import 'package:wrestling_scoreboard/ui/match/match_sequence.dart';

import 'data/fight.dart';
import 'data/team_match.dart';
import 'mocks/mocks.dart';

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
}
