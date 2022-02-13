import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/consumer.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/ui/edit/club_edit.dart';
import 'package:wrestling_scoreboard/ui/edit/league_edit.dart';
import 'package:wrestling_scoreboard/ui/overview/club_overview.dart';
import 'package:wrestling_scoreboard/ui/overview/league_overview.dart';
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
    WebSocketManager.onWebSocketConnection.stream.distinct().listen((connectionState) {
      if (mounted && connectionState == WebSocketConnectionState.disconnected) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
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
                    WebSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
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
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.foundation),
                    const SizedBox(width: 8),
                    Text(localizations.clubs),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events),
                    const SizedBox(width: 8),
                    Text(localizations.leagues),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ManyConsumer<Club>(
              builder: (BuildContext context, List<Club> clubs) {
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
                    (e) => SingleConsumer<Club>(
                      id: e.id!,
                      initialData: e,
                      builder: (context, data) => ContentItem(
                        title: data!.name,
                        icon: Icons.foundation,
                        onTap: () => handleSelectedClub(data, context),
                      ),
                    ),
                  ),
                );
              },
            ),
            ManyConsumer<League>(
              builder: (BuildContext context, List<League> leagues) {
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
                    (e) => SingleConsumer<League>(
                      id: e.id!,
                      initialData: e,
                      builder: (context, data) => ContentItem(
                        title: data!.name,
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

  handleSelectedClub(Club club, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubOverview(
          filterObject: club,
        ),
      ),
    );
  }

  handleSelectedLeague(League league, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeagueOverview(
          filterObject: league,
        ),
      ),
    );
  }
}
