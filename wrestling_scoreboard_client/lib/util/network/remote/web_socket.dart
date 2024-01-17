import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
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
  String? _wsUrl;

  /// Manages connection state of WebSocket
  final StreamController<WebSocketConnectionState> onWebSocketConnection = StreamController.broadcast();

  WebSocketManager(this.messageHandler, {String? url}) {
    if (url != null) {
      _wsUrl = adaptLocalhost(url);
    }
    onWebSocketConnection.stream.listen((connectionState) async {
      if (connectionState == WebSocketConnectionState.connecting && _wsUrl != null) {
        await _channel?.sink.close(4210);
        try {
          _channel = WebSocketChannel.connect(Uri.parse(_wsUrl!));
          _channel?.stream.listen(messageHandler, onError: (e) {
            if (e is WebSocketChannelException) {
              log('Websocket connection refused by server');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnecting);
            }
          }, onDone: () {
            if (_channel?.closeCode == 4210) {
              log('Websocket connection reconnecting: ${_channel?.closeReason}');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
            } else if (_channel?.closeCode == 1001) {
              log('Websocket connection closed by client ${_channel?.closeReason}');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
            } else if (_channel?.closeCode == null) {
              log('Websocket connection closed by server');
              // Avoid overriding previous SocketException with setting a disconnected state
            } else {
              log('Websocket connection closed by server ${_channel?.closeReason}');
              onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
            }
            _channel = null;
          });
          await _channel?.ready.timeout(const Duration(seconds: 5));
          log('Websocket connection established: $_wsUrl');
          onWebSocketConnection.sink.add(WebSocketConnectionState.connected);
        } on SocketException catch (e) {
          // Thrown, when connection failed, waiting for `ready` state.
          log('Websocket connection refused by server: $e');
          onWebSocketConnection.sink.addError(e);
        }
      } else if (connectionState == WebSocketConnectionState.disconnecting) {
        await _channel?.sink.close(1001);
        _channel = null;
      }
    });
    onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
  }

  dynamic addToSink(String val) {
    _channel?.sink.add(val);
    return null;
  }
}
