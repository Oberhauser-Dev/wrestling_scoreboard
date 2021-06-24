import 'package:shelf_web_socket/shelf_web_socket.dart';

var websocketHandler = webSocketHandler((webSocket) {
  webSocket.stream.listen((message) {
    webSocket.sink.add("echo $message");
  });
});
