import 'package:flutter_dotenv/flutter_dotenv.dart';

const apiUrl = 'API_URL';
const webSocketUrl = 'WEB_SOCKET_URL';
const appEnvironment = 'APP_ENVIRONMENT';
const bellSoundPath = 'BELL_SOUND_PATH';

/// Priority:
/// - environment variable
/// - Dotenv variable from `.env`
/// - custom fallBack
/// - default value
String env(String variable, {String? fallBack}) {
  String? fromEnv = _env(variable);
  if (fromEnv?.isEmpty ?? true) fromEnv = dotenv.env[variable];
  if (fromEnv?.isEmpty ?? true) fromEnv = fallBack;
  if (fromEnv?.isEmpty ?? true) fromEnv = _defaultValue(variable);
  return fromEnv!;
}

String? _env(String variable) {
  switch (variable) {
    case apiUrl:
      return const String.fromEnvironment(apiUrl);
    case webSocketUrl:
      return const String.fromEnvironment(webSocketUrl);
    case appEnvironment:
      return const String.fromEnvironment(appEnvironment);
  }
  return null;
}

String _defaultValue(String variable) {
  switch (variable) {
    case apiUrl:
      return 'http://localhost:8080/api';
    case webSocketUrl:
      return 'ws://localhost:8080/ws';
    case appEnvironment:
      return 'development';
    case bellSoundPath:
      return 'assets/audio/BoxingBell.mp3';
  }
  throw 'Unknown variable';
}
