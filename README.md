# Wrestling Scoreboard

Repository for managing Wrestling software: client, server and shared libraries.
Available for Linux, Windows, macOS, Web, Android and iOS.

Tags: scoreboard, wrestling, scoring, bracket, mat, team, fight, competition, tournament, display, points, bracket, team, athlete, bout

## Screenshots

<table>
  <tr>
    <td width="73%"><img src="docs/images/screen_fight_01.png"></td>
    <td><img src="docs/images/screen_settings_01.png"></td>
  </tr>
  <tr>
    <td width="73%"><img src="docs/images/screen_team_match_01.png"></td>
    <td><img src="docs/images/screen_home_01.png"></td>
  </tr>
</table>

## Installation

The App consists of three components, the client, the server and the database.
You can download the client and the server for your preferred platforms from the [Releases section](https://github.com/Oberhauser-Dev/wrestling_scoreboard/releases).

For setting up the database and hosting a server, see:
- [Database](wrestling_scoreboard_server/database/README.md)
- [Server](wrestling_scoreboard_server/README.md#setup)

## Development

All the code is based on Dart and Flutter. For setting up Flutter, see the [getting started guide](https://docs.flutter.dev/get-started).

Wrestling Scoreboard is a monorepo.
Therefor it uses [Melos](https://github.com/invertase/melos) to manage the project and dependencies.
All the commands can be found in the [melos.yaml](melos.yaml) file.

To install Melos, run the following command from your terminal:

```bash
flutter pub global activate melos
```

Next, at the root of your locally cloned repository bootstrap the projects dependencies:

```bash
melos bs
```

To format your code, call:
```bash
melos format
```

To create a new version of all packages, call:
```bash
melos version --all --prerelease --preid=beta --diff=v0.0.1-beta.9 --no-git-tag-version
```

Please read the documentation for setting up the according components:
- [Database](wrestling_scoreboard_server/database/README.md)
- [Server](wrestling_scoreboard_server/README.md#development)
- [Client](wrestling_scoreboard_client/README.md)

If using [Nginx](https://en.wikipedia.org/wiki/Nginx) as Reverse Proxy, you can take advantage of [these config](docs/nginx) files.

## License

Published under [MIT license](./LICENSE.md).
