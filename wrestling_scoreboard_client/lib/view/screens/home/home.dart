import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/clubs_view.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/competitions_view.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/leagues_view.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    ref.read(dataManagerNotifierProvider).then((dataManager) {
      void showDisconnectedAlert([Object? exception]) {
        final localizations = AppLocalizations.of(context)!;
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectableText(localizations.noWebSocketConnection),
                // TODO: add show more button
                // if (exception != null)
                //   SelectableText(exception.toString(), style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  dataManager.webSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
                },
                child: Text(localizations.retry),
              ),
            ],
          ),
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataManager.webSocketManager.onWebSocketConnection.stream.distinct().listen((connectionState) {
          if (mounted && connectionState == WebSocketConnectionState.disconnected) {
            showDisconnectedAlert();
          }
        }, onError: (e, [trace]) {
          showDisconnectedAlert(e);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
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
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const Icon(Icons.social_leaderboard),
                    const Icon(Icons.leaderboard),
                    const SizedBox(width: 8),
                    Text(localizations.competitions),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeaguesView(),
            ClubsView(),
            CompetitionsView(),
          ],
        ),
      ),
    );
  }
}
