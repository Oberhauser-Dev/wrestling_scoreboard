# Wrestling Scoreboard Client

Wrestling software client for managing team matches and competitions.

## Deployment

### Web Server

```shell
flutter build web
```

Publish files in `build/web`.

If using [Nginx](https://en.wikipedia.org/wiki/Nginx) as Reverse Proxy, you can take advantage of [this config](docs/nginx/wrestling-scoreboard-client-web.conf) files.

## Development

### Environment variables:

```shell
flutter run \
--dart-define=APP_ENVIRONMENT=development \
--dart-define=API_URL='http://localhost:8080/api' \
--dart-define=WEB_SOCKET_URL='ws://localhost:8080/ws' \
--dart-define=USE_PATH_URL_STRATEGY=false
```

Values for `APP_ENVIRONMENT`:
- `mock`: debug and mock data
- `production`: connect to API
- `development`: debug and connect to API

### Icons & AppName

Generate launcher icons with: `flutter pub run flutter_launcher_icons`

Change App name with: `flutter pub global activate rename` & `rename setAppName --targets ios,android,macos,windows,web --value "YourAppName"`
You can also set the name for linux, but this isn't the launcher name. Update debians `.desktop` file manually.
