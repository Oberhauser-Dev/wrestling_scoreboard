const apiUrl = 'API_URL';
const webSocketUrl = 'WEB_SOCKET_URL';
const appEnvironment = 'APP_ENVIRONMENT';
const bellSoundPath = 'BELL_SOUND_PATH';

/// Priority:
/// - environment variable
/// - custom fallBack
/// - default value
String env(String variable, {String? fallBack}) {
  String? fromEnv = _env(variable);
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
      // 'mock' -> debug and mock data
      // 'development' -> debug and connect to API
      // 'production' -> connect to API
      return 'development';
    case bellSoundPath:
      return 'assets/audio/BoxingBell.mp3';
  }
  throw 'Unknown variable';
}
