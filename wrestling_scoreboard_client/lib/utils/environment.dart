enum Env {
  apiUrl,
  webSocketUrl,
  webClientUrl,

  /// 'mock' -> debug and mock data
  /// 'development' -> debug and connect to API
  /// 'production' -> connect to API
  appEnvironment,
  bellSoundPath,
  timeCountDown,

  /// Use [PathUrlStrategy] instead of the [HashUrlStrategy]. This must be supported by your server, see
  /// https://docs.flutter.dev/ui/navigation/url-strategies#configuring-your-web-server
  usePathUrlStrategy;

  String fromString() {
    switch (this) {
      case Env.apiUrl:
        return const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080/api');
      case Env.webSocketUrl:
        return const String.fromEnvironment('WEB_SOCKET_URL', defaultValue: 'ws://localhost:8080/ws');
      case Env.webClientUrl:
        return const String.fromEnvironment('WEB_CLIENT_URL');
      case Env.appEnvironment:
        return const String.fromEnvironment('APP_ENVIRONMENT', defaultValue: 'development');
      case Env.bellSoundPath:
        return const String.fromEnvironment('BELL_SOUND_PATH', defaultValue: 'assets/audio/BoxingBell.mp3');
      default:
        throw '$this is not of type `String`';
    }
  }

  bool fromBool() {
    switch (this) {
      case Env.usePathUrlStrategy:
        return const bool.fromEnvironment('USE_PATH_URL_STRATEGY', defaultValue: false);
      case Env.timeCountDown:
        return const bool.fromEnvironment('IS_TIME_COUNT_DOWN', defaultValue: true);
      default:
        throw '$this is not of type `bool`';
    }
  }

  int fromInt() {
    switch (this) {
      default:
        throw '$this is not of type `int`';
    }
  }
}
