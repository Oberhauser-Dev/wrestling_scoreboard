import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/data/team.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class Home extends StatelessWidget {
  late final Future<List<ClientClub>> _clubs;
  late final Future<List<ClientLeague>> _leagues;

  Home() {
    _clubs = dataProvider.readMany<ClientClub>();
    _leagues = dataProvider.readMany<ClientLeague>();
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
              List<ListGroup> items = [
                ListGroup(
                    HeadingItem(AppLocalizations.of(context)!.club),
                    (snapshot.data![0] as List<ClientClub>).map((e) =>
                        ContentItem(e.name, icon: Icons.foundation, onTab: () => handleSelectedClub(e, context)))),
                ListGroup(
                    HeadingItem(AppLocalizations.of(context)!.league),
                    (snapshot.data![1] as List<ClientLeague>).map((e) =>
                        ContentItem(e.name, icon: Icons.emoji_events, onTab: () => handleSelectedLeague(e, context))))
              ];
              return GroupedList(items);
            } else {
              return Center(child: Text('Cannot access data!'));
            }
          }),
    );
  }

  handleSelectedClub(ClientClub club, BuildContext context) {
    dataProvider.readMany<ClientTeam>(filterObject: club).then(
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
    dataProvider.readMany<ClientTeam>(filterObject: league).then(
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
