import 'package:flutter_dotenv/flutter_dotenv.dart';

const apiUrl = 'API_URL';
const webSocketUrl = 'WEB_SOCKET_URL';
const appEnvironment = 'APP_ENVIRONMENT';

String env(String variable, {String fallBack = ''}) {
  String? fromEnv;
  switch (variable) {
    case apiUrl:
      fromEnv = const String.fromEnvironment(apiUrl);
      break;
    case webSocketUrl:
      fromEnv = const String.fromEnvironment(webSocketUrl);
      break;
    case appEnvironment:
      fromEnv = const String.fromEnvironment(appEnvironment);
      break;
  }
  if (fromEnv == null || fromEnv.isEmpty) {
    fromEnv = dotenv.env[variable];
    if (fromEnv == null) {
      fromEnv = fallBack;
    }
  }
  return fromEnv;
}
