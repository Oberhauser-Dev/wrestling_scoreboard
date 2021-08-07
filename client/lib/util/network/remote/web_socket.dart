import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final _wsUrl = dotenv.env['WEB_SOCKET_URL'] ?? 'ws://localhost:8080/ws';

// TODO try removing backslash if https://github.com/google/dart-neats/pull/146 is merged.
final _channel = WebSocketChannel.connect(Uri.parse(_wsUrl.endsWith('/') ? _wsUrl : (_wsUrl + '/')));

dynamic addToSink(String val) {
  _channel.sink.add(val);
  return null;
}

Stream getSinkStream() => _channel.stream;
