import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/ui/components/consumer.dart';
import 'package:wrestling_scoreboard_client/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard_client/ui/components/responsive_container.dart';
import 'package:wrestling_scoreboard_client/ui/edit/club_edit.dart';
import 'package:wrestling_scoreboard_client/ui/edit/team_match/league_edit.dart';
import 'package:wrestling_scoreboard_client/ui/overview/club_overview.dart';
import 'package:wrestling_scoreboard_client/ui/overview/team_match/league_overview.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    final webSocketManager = ref.read(dataManagerProvider).webSocketManager;
    webSocketManager.onWebSocketConnection.stream.distinct().listen((connectionState) {
      if (mounted && connectionState == WebSocketConnectionState.disconnected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
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
                    webSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
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
            ResponsiveScrollView(
              child: ManyConsumer<Club, Null>(
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
                        builder: (context, data) {
                          return ContentItem(
                            title: data.name,
                            icon: Icons.foundation,
                            onTap: () => handleSelectedClub(data, context),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ResponsiveScrollView(
              child: ManyConsumer<League, Null>(
                builder: (BuildContext context, List<League> leagues) {
                  return ListGroup(
                    header: HeadingItem(
                      title: localizations.leagues,
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeagueEdit())),
                      ),
                    ),
                    items: leagues.map(
                      (e) => SingleConsumer<League>(
                        id: e.id!,
                        initialData: e,
                        builder: (context, data) {
                          return ContentItem(
                            title: data.name,
                            icon: Icons.emoji_events,
                            onTap: () => handleSelectedLeague(data, context),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleSelectedClub(Club club, BuildContext context) {
    context.push('/${ClubOverview.route}/${club.id}');
  }

  handleSelectedLeague(League league, BuildContext context) {
    context.push('/${LeagueOverview.route}/${league.id}');
  }
}
