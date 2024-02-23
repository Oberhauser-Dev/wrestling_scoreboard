# Wrestling Scoreboard

Repository for managing Wrestling software client, server and shared libraries.

Tags: scoreboard, wrestling, scoring, bracket, mat, team fight, competition, tournament

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

## Setup & Installation

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

Please read the documentation for setting up the according components:
- [Server](wrestling_scoreboard_server/README.md)
- [Database](wrestling_scoreboard_server/database/README.md)
- [Client](wrestling_scoreboard_client/README.md)

If using [Nginx](https://en.wikipedia.org/wiki/Nginx) as Reverse Proxy, you can take advantage of [these config](docs/nginx) files.

## License

Published under [MIT license](./LICENSE.md).
