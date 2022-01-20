import 'dart:async';
import 'dart:developer';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard/ui/settings/settings.dart';
import 'package:wrestling_scoreboard/util/environment.dart';
import 'package:wrestling_scoreboard/util/network/remote/url.dart';

class WebSocketManager {
  late Function(dynamic message) messageHandler;
  WebSocketChannel? _channel;
  String? wsUrl;

  /// Manages connection state of WebSocket
  /// true: try to connect, but not guaranteed
  /// false: close connection (usually no need to use, as Widgets throw an error and display connection state accordingly)
  static final StreamController<bool> onWebSocketConnecting = StreamController.broadcast();
  static bool? webSocketConnected;

  WebSocketManager(this.messageHandler) {
    // TODO try removing backslash if https://github.com/google/dart-neats/pull/146 is merged.
    CustomSettingsScreen.onChangeWsUrlWebSocket.stream.listen((url) {
      wsUrl = adaptLocalhost(url.endsWith('/') ? url : (url + '/'));
      onWebSocketConnecting.sink.add(true);
    });
    onWebSocketConnecting.stream.listen((isConnecting) {
      if (isConnecting && wsUrl != null) {
        _channel?.sink.close();
        _channel = WebSocketChannel.connect(Uri.parse(wsUrl!));
        _channel?.stream.listen(messageHandler, onError: (e) {
          // print('Websocket: onError');
          // print(e);
        }, onDone: () {
          log('Websocket connection closed');
          onWebSocketConnecting.sink.add(false);
        });
        log('Listen to WebSocket: $wsUrl');
      } else {
        _channel?.sink.close();
      }
    });
    CustomSettingsScreen.onChangeWsUrlWebSocket.sink.add(Settings.getValue<String>(
        CustomSettingsScreen.keyWsUrl, env(webSocketUrl, fallBack: 'ws://localhost:8080/ws'))!);
  }

  dynamic addToSink(String val) {
    _channel?.sink.add(val);
    return null;
  }
}
