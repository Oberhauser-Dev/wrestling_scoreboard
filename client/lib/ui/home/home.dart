import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/data/league.dart';
import 'package:wrestling_scoreboard/ui/club/club_edit.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/home/team_selection.dart';
import 'package:wrestling_scoreboard/ui/league/league_edit.dart';
import 'package:wrestling_scoreboard/util/network/remote/web_socket.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WebSocketManager.onWebSocketConnecting.stream.distinct().listen((isConnected) {
      if (!isConnected) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          final localizations = AppLocalizations.of(context)!;
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text(localizations.noWebSocketConnection),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    WebSocketManager.onWebSocketConnecting.sink.add(true);
                  },
                  child: Text(localizations.retry),
                ),
              ],
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.home),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.foundation)),
              Tab(icon: Icon(Icons.emoji_events)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ManyConsumer<Club, ClientClub>(
              builder: (BuildContext context, List<ClientClub> clubs) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.clubs,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ClubEdit())),
                    ),
                  ),
                  items: clubs.map(
                        (e) => SingleConsumer<Club, ClientClub>(
                      id: e.id!,
                      initialData: e,
                      builder: (context, data) => ContentItem(
                        title: data.name,
                        icon: Icons.foundation,
                        onTap: () => handleSelectedClub(data, context),
                      ),
                    ),
                  ),
                );
              },
            ),
            ManyConsumer<League, ClientLeague>(
              builder: (BuildContext context, List<ClientLeague> leagues) {
                return ListGroup(
                  header: HeadingItem(
                    title: localizations.leagues,
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LeagueEdit())),
                    ),
                  ),
                  items: leagues.map(
                        (e) => SingleConsumer<League, ClientLeague>(
                      id: e.id!,
                      initialData: e,
                      builder: (context, data) => ContentItem(
                        title: data.name,
                        icon: Icons.emoji_events,
                        onTap: () => handleSelectedLeague(data, context),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  handleSelectedClub(ClientClub club, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSelection<Club, ClientClub>(
          filterObject: club,
        ),
      ),
    );
  }

  handleSelectedLeague(ClientLeague league, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamSelection<League, ClientLeague>(
          filterObject: league,
        ),
      ),
    );
  }
}
