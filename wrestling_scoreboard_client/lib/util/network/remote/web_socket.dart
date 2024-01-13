import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences.dart';
import 'package:wrestling_scoreboard_client/util/environment.dart';
import 'package:wrestling_scoreboard_client/util/network/remote/url.dart';

enum WebSocketConnectionState {
  connecting,
  connected,
  disconnecting,
  disconnected,
}

/// Close event codes: https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code
/// Custom:
/// - 4210: Client attempts to reconnect
class WebSocketManager {
  late Function(dynamic message) messageHandler;
  WebSocketChannel? _channel;
  String? wsUrl;

  /// Manages connection state of WebSocket
  static final StreamController<WebSocketConnectionState> onWebSocketConnection = StreamController.broadcast();

  WebSocketManager(this.messageHandler) {
    Preferences.onChangeWsUrlWebSocket.stream.listen((url) {
      wsUrl = adaptLocalhost(url);
      onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
    });
    onWebSocketConnection.stream.listen((connectionState) async {
      if (connectionState == WebSocketConnectionState.connecting && wsUrl != null) {
        await _channel?.sink.close(4210);
        try {
          _channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
          _channel?.stream.listen(messageHandler, onError: (e) {
            if (e is WebSocketChannelException) {
              log('Websocket connection refused by server');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnecting);
            }
          }, onDone: () {
            if (_channel?.closeCode == 4210) {
              log('Websocket connection reconnecting');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
            } else if (_channel?.closeCode == 1001) {
              log('Websocket connection closed by client');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
            } else {
              log('Websocket connection closed by server');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
            }
            _channel = null;
          });
          await _channel?.ready.timeout(const Duration(seconds: 5));
          log('Websocket connection established: $wsUrl');
          onWebSocketConnection.sink.add(WebSocketConnectionState.connected);
        } on SocketException catch (e) {
          // Thrown, when connection failed, waiting for `ready` state.
          log('Websocket connection refused by server: $e');
          onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
        }
      } else if (connectionState == WebSocketConnectionState.disconnecting) {
        await _channel?.sink.close(1001);
        _channel = null;
      }
    });
    Preferences.getString(Preferences.keyWsUrl)
        .then((value) => Preferences.onChangeWsUrlWebSocket.sink.add(value ?? Env.webSocketUrl.fromString()));
  }

  dynamic addToSink(String val) {
    _channel?.sink.add(val);
    return null;
  }
}
