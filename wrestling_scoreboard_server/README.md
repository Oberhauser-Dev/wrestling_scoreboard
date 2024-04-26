# Wrestling Scoreboard Server

Wrestling software server for managing team matches and competitions.

## Setup

See [database docs](./database/README.md), to set up the Postgres database.

It is recommended to start the app with user privileges, here `www`. Avoid using root.

Download the latest server version from the [releases section](https://github.com/Oberhauser-Dev/wrestling_scoreboard/releases)
and extract it into e.g. inside `$HOME/.local/share/wrestling_scoreboard_server`

### Environment variables:

Create file `.env` in the `wrestling_scoreboard_server` directory.
A pre-configuration can be found in `.env.example` file. Change the values to your needs.

### Run server

Execute the `./bin/wrestling-scoreboard-server` executable from within the `wrestling_scoreboard_server` directory, to handle resource paths correctly.

### Linux Systemd service

```shell
nano $HOME/.config/systemd/user/wrestling-scoreboard-server.service
```

```ini
[Unit]
Description=Wrestling-Scoreboard-Server

[Service]
ExecStart=%h/.local/share/wrestling_scoreboard_server/bin/wrestling-scoreboard-server
WorkingDirectory=%h/.local/share/wrestling_scoreboard_server
Restart=on-failure
RestartSec=15
#User=www
#Group=www

[Install]
WantedBy=default.target
```

```shell
systemctl --user daemon-reload
systemctl --user enable wrestling-scoreboard-server.service
systemctl --user start wrestling-scoreboard-server.service
```

Additionally, enable session for user `www` on boot:
```bash
sudo loginctl enable-linger www
```

## Development

### Build package

```shell
dart compile exe bin/server.dart
```
