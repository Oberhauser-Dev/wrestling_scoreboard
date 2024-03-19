import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/organizations_view.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrganizationState();
}

class OrganizationState extends ConsumerState<Explore> {
  @override
  void initState() {
    super.initState();
    ref.read(dataManagerNotifierProvider).then((dataManager) {
      void onRetry() {
        Navigator.of(context).pop();
        dataManager.webSocketManager.onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataManager.webSocketManager.onWebSocketConnection.stream.distinct().listen((connectionState) {
          if (mounted && connectionState == WebSocketConnectionState.disconnected) {
            final localizations = AppLocalizations.of(context)!;
            showExceptionDialog(
                context: context, exception: localizations.noWebSocketConnection, stackTrace: null, onRetry: onRetry);
          }
        }, onError: (e, [trace]) {
          showExceptionDialog(exception: e, context: context, stackTrace: trace, onRetry: onRetry);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.explore),
      ),
      body: const OrganizationsView(),
    );
  }
}
