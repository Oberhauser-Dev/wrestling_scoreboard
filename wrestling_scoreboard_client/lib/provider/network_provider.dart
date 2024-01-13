import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/web_socket.dart';

part 'network_provider.g.dart';

@Riverpod(keepAlive: true)
Raw<Stream<WebSocketConnectionState>> webSocketStateStream(WebSocketStateStreamRef ref) {
  final webSocketConnectionStream = WebSocketManager.onWebSocketConnection.stream
      .distinct()
      .where((event) => event == WebSocketConnectionState.disconnected || event == WebSocketConnectionState.connected);

  // ref.onDispose(webSocketConnectionStream.close);
  return webSocketConnectionStream;
}


