import 'dart:async';
import 'dart:developer';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard/ui/settings/settings.dart';
import 'package:wrestling_scoreboard/util/environment.dart';
import 'package:wrestling_scoreboard/util/network/remote/url.dart';

class WebSocketManager {
  late WebSocketChannel _channel;
  late Function(dynamic message) messageHandler;

  static final StreamController<bool> onWebSocketConnected = StreamController.broadcast();
  static bool? webSocketConnected;

  WebSocketManager(this.messageHandler) {
    updateWebSocketChannel();
    CustomSettingsScreen.onConnectWebSocket.stream.listen((url) {
      _channel.sink.close();
      updateWebSocketChannel(url);
    });
  }

  void updateWebSocketChannel([String? wsUrl]) {
    wsUrl ??= Settings.getValue<String>(
        CustomSettingsScreen.keyWsUrl, env(webSocketUrl, fallBack: 'ws://localhost:8080/ws'))!;
    // TODO try removing backslash if https://github.com/google/dart-neats/pull/146 is merged.
    wsUrl = adaptLocalhost(wsUrl.endsWith('/') ? wsUrl : (wsUrl + '/'));
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _channel.stream.listen(messageHandler, onError: (e) {
      // print('Websocket: onError');
      // print(e);
    }, onDone: () {
      log('Websocket connection closed');
      onWebSocketConnected.sink.add(false);
    });
    log('Listen to WebSocket: $wsUrl');
    onWebSocketConnected.sink.add(true);
  }

  dynamic addToSink(String val) {
    _channel.sink.add(val);
    return null;
  }
}
