import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard/ui/settings/settings.dart';
import 'package:wrestling_scoreboard/util/environment.dart';
import 'package:wrestling_scoreboard/util/network/remote/url.dart';

class WebSocketManager {

  late WebSocketChannel _channel;
  late Function(dynamic message) messageHandler;
  
  WebSocketManager(this.messageHandler) {
    _updateWebSocketChannel(Settings.getValue<String>(
        CustomSettingsScreen.keyWsUrl, env(webSocketUrl, fallBack: 'ws://localhost:8080/ws'))!);
    CustomSettingsScreen.onChangeWsUrl.stream.listen((event) {
      _channel.sink.close();
      _updateWebSocketChannel(event);
    });
  }

  void _updateWebSocketChannel(String wsUrl) {
    // TODO try removing backslash if https://github.com/google/dart-neats/pull/146 is merged.
    wsUrl = adaptLocalhost(wsUrl.endsWith('/') ? wsUrl : (wsUrl + '/'));
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _channel.stream.listen(messageHandler);
    print('Listen to WebSocket: $wsUrl');
  }

  dynamic addToSink(String val) {
    _channel.sink.add(val);
    return null;
  }
}
