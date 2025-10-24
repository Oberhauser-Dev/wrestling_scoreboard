import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/app.dart';
import 'package:wrestling_scoreboard_client/mocks/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';

final mockProviderScope = ProviderScope(
  // Never retry any provider
  retry: (retryCount, error) => null,
  overrides: [
    dataManagerProvider.overrideWith(() => MockDataManagerNotifier()),
    webSocketManagerProvider.overrideWith(() => MockWebsocketManagerNotifier()),
  ],
  child: const WrestlingScoreboardApp(),
);
