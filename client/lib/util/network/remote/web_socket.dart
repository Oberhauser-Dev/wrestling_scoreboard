import 'dart:async';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard/ui/settings/preferences.dart';
import 'package:wrestling_scoreboard/util/environment.dart';
import 'package:wrestling_scoreboard/util/network/remote/url.dart';

enum WebSocketConnectionState {
  connecting,
  connected,
  disconnecting,
  disconnected,
}

class WebSocketManager {
  late Function(dynamic message) messageHandler;
  WebSocketChannel? _channel;
  String? wsUrl;

  /// Manages connection state of WebSocket
  /// true: try to connect, but not guaranteed
  /// false: close connection (usually no need to use, as Widgets throw an error and display connection state accordingly)
  static final StreamController<WebSocketConnectionState> onWebSocketConnection = StreamController.broadcast();

  WebSocketManager(this.messageHandler) {
    // TODO try removing backslash if https://github.com/google/dart-neats/pull/146 is merged.
    Preferences.onChangeWsUrlWebSocket.stream.listen((url) {
      wsUrl = adaptLocalhost(url.endsWith('/') ? url : (url + '/'));
      onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
    });
    onWebSocketConnection.stream.listen((connectionState) async {
      if (connectionState == WebSocketConnectionState.connecting && wsUrl != null) {
        await _channel?.sink.close();
        _channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
        _channel?.stream.listen(messageHandler,
            onError: (e) {
          if (e is WebSocketChannelException) {
            log('Websocket connection refused by server');
            onWebSocketConnection.sink.add(WebSocketConnectionState.disconnecting);
          }
        }, onDone: () {
          if (_channel?.closeCode != null) {
            // closeCode == 1005
            log('Websocket connection closed by server');
            onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
          } else {
            log('Websocket connection closed by client');
            onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
          }
          _channel = null;
        });
        log('Websocket connection established: $wsUrl');
        onWebSocketConnection.sink.add(WebSocketConnectionState.connected);
      } else if (connectionState == WebSocketConnectionState.disconnecting) {
        await _channel?.sink.close();
        _channel = null;
      }
    });
    Preferences.getString(Preferences.keyWsUrl)
        .then((value) => Preferences.onChangeWsUrlWebSocket.sink.add(value ?? env(webSocketUrl)));
  }

  dynamic addToSink(String val) {
    _channel?.sink.add(val);
    return null;
  }
}
