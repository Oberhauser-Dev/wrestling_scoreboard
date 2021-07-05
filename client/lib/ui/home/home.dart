import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';
import 'package:wrestling_scoreboard/util/network/rest/rest.dart';

class Home extends StatelessWidget {
  late final Future<List<ClientClub>> _clubs;
  late final Future<List<ClientLeague>> _leagues;

  Home() {
    _clubs = fetchMany<ClientClub>();
    _leagues = fetchMany<ClientLeague>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_clubs, _leagues]), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<ListItem> items = [HeadingItem(AppLocalizations.of(context)!.club)]..addAll(
                  (snapshot.data![0] as List<ClientClub>).map(
                      (e) => ContentItem(e.name, icon: Icons.foundation, onTab: () => handleSelectedClub(e, context))));
              items
                ..add(HeadingItem(AppLocalizations.of(context)!.league))
                ..addAll((snapshot.data![1] as List<ClientLeague>).map((e) =>
                    ContentItem(e.name, icon: Icons.emoji_events, onTab: () => handleSelectedLeague(e, context))));
              return GroupedList(items);
            } else {
              return Center(child: Text('Cannot access data!'));
            }
          }),
    );
  }

  handleSelectedClub(ClientClub club, BuildContext context) {
    fetchMany<ClientTeam>(prepend: '/club/${club.id}').then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeamSelection(
                  title: club.name,
                  teams: value,
                )),
      ),
    );
  }

  handleSelectedLeague(ClientLeague league, BuildContext context) {
    fetchMany<ClientTeam>(prepend: '/league/${league.id}').then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TeamSelection(
                  title: league.name,
                  teams: value,
                )),
      ),
    );
  }
}
