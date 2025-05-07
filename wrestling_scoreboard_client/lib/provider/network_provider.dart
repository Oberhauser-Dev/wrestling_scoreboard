import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

part 'network_provider.g.dart';

@Riverpod(keepAlive: true)
class DataManagerNotifier extends _$DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    final apiUrl = await ref.watch(apiUrlNotifierProvider);
    final jwtToken = await ref.watch(jwtNotifierProvider);
    return RestDataManager(
      apiUrl: apiUrl,
      authService: jwtToken == null ? null : BearerAuthService(token: jwtToken),
      onResetAuth: () async {
        if (ref.mounted) await ref.read(jwtNotifierProvider.notifier).setState(null);
      },
    );
  }
}

@Riverpod(keepAlive: true)
class WebSocketManagerNotifier extends _$WebSocketManagerNotifier {
  @override
  Raw<Future<WebSocketManager>> build() async {
    final wsUrl = await ref.watch(webSocketUrlNotifierProvider);
    final dataManager = await ref.watch(dataManagerNotifierProvider);

    final webSocketManager = WebSocketManager(dataManager, url: wsUrl);
    dataManager.webSocketManager = webSocketManager;

    return webSocketManager;
  }
}

@Riverpod(keepAlive: true)
Stream<WebSocketConnectionState> webSocketStateStream(Ref ref) async* {
  final webSocketManager = await ref.watch(webSocketManagerNotifierProvider);
  final webSocketConnectionStream = webSocketManager.onWebSocketConnection.stream.distinct().where(
    (event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected,
  );
  yield* webSocketConnectionStream;
}
