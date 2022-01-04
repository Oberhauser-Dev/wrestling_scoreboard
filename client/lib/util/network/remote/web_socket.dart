import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard/util/environment.dart';
import 'package:wrestling_scoreboard/util/network/remote/url.dart';

final _wsUrl = adaptLocalhost(env(webSocketUrl, fallBack: 'ws://localhost:8080/ws'));

final _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

dynamic addToSink(String val) {
  _channel.sink.add(val);
  return null;
}

Stream getSinkStream() => _channel.stream;
