import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/mocks/mocks.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';
import 'package:wrestling_scoreboard/util/network/rest/rest.dart';

class Home extends StatelessWidget {
  late final Future<List<Club>> _clubs;

  Home() {
    _clubs = fetchMany<Club>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<List<Club>>(
          future: _clubs, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Club>> snapshot) {
            if (snapshot.hasData) {
              List<ListItem> items = [HeadingItem(AppLocalizations.of(context)!.club)]..addAll(snapshot.data!.map(
                  (e) => ContentItem(e.name, icon: Icons.foundation, onTab: () => handleSelectedClub(e, context))));
              items
                ..add(HeadingItem(AppLocalizations.of(context)!.league))
                ..addAll(getLeagues().map((e) =>
                    ContentItem(e.name, icon: Icons.emoji_events, onTab: () => handleSelectedLeague(e, context))));
              return GroupedList(items);
            } else {
              return Text('Cannot access data!');
            }
          }),
    );
  }

  handleSelectedClub(Club club, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeamSelection(
                  title: club.name,
                  teams: getTeamsOfClub(club),
                )));
  }

  handleSelectedLeague(League league, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeamSelection(
                  title: league.name,
                  teams: getTeamsOfLeague(league),
                )));
  }
}
