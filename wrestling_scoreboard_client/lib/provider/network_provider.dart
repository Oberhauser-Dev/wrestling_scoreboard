import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';

part 'network_provider.g.dart';

@Riverpod(keepAlive: true)
class DataManagerNotifier extends _$DataManagerNotifier {
  @override
  Raw<Future<DataManager>> build() async {
    final apiUrl = await ref.watch(apiUrlNotifierProvider);
    final wsUrl = await ref.watch(webSocketUrlNotifierProvider);

    return RestDataManager(apiUrl: apiUrl, wsUrl: wsUrl);
  }
}

@Riverpod(keepAlive: true)
Stream<WebSocketConnectionState> webSocketStateStream(WebSocketStateStreamRef ref) async* {
  final dataManager = await ref.watch(dataManagerNotifierProvider);
  // TODO: integrate in updating websocket URL from stream provider
  final webSocketConnectionStream = dataManager.webSocketManager.onWebSocketConnection.stream
      .distinct()
      .where((event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected);
  yield* webSocketConnectionStream;
}
