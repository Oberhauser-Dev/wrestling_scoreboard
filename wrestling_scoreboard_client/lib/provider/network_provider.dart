import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/mocks/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'network_provider.g.dart';

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
@Riverpod(keepAlive: true, dependencies: [])
class DataManagerNotifier extends _$DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    final apiUrl = await ref.watch(apiUrlProvider);
    final jwtToken = await ref.watch(jwtProvider);
    return RestDataManager(
      apiUrl: apiUrl,
      authService: jwtToken == null ? null : BearerAuthService(token: jwtToken),
      onResetAuth: () async {
        if (ref.mounted) await ref.read(jwtProvider.notifier).setState(null);
      },
    );
  }
}

/// This provider can be scoped, so it can be overridden in a sub scope of the app.
@Riverpod(keepAlive: true, dependencies: [DataManagerNotifier])
class WebSocketManagerNotifier extends _$WebSocketManagerNotifier {
  @override
  Raw<Future<WebSocketManager>> build() async {
    final wsUrl = await ref.watch(webSocketUrlProvider);
    final dataManager = await ref.watch(dataManagerProvider);

    final webSocketManager = WebSocketManager(dataManager, url: wsUrl);
    dataManager.webSocketManager = webSocketManager;

    return webSocketManager;
  }
}

@Riverpod(
  keepAlive: true,
  dependencies: [WebSocketManagerNotifier, LocalWebsocketManagerNotifier, MockWebsocketManagerNotifier],
)
Stream<WebSocketConnectionState> webSocketStateStream(Ref ref) async* {
  final webSocketManager = await ref.watch(webSocketManagerProvider);
  final webSocketConnectionStream = webSocketManager.onWebSocketConnection.stream.distinct().where(
    (event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected,
  );
  yield* webSocketConnectionStream;
}
