# Wrestling Scoreboard Server

Wrestling software server for managing team matches and competitions.

## Setup

Download the latest server version from the [releases section](https://github.com/Oberhauser-Dev/wrestling_scoreboard/releases)
and extract it into e.g. inside `$HOME/.local/share/wrestling_scoreboard_server`.

It is recommended to start the app with user privileges, here `www`. Avoid using `root`, especially if the server is open to the public.

### Environment variables:

Create file `.env` in the `wrestling_scoreboard_server` directory.
A pre-configuration can be found in `.env.example` file (`cp .env.example .env`). Change the values to your needs.

Alternatively, run `wrestling-scoreboard-server config` to create or change the config file by answering
questions in the terminal. This also happens automatically when starting the server in a terminal without any config file.

On Windows, the config file is located at `%ProgramData%\WrestlingScoreboard\Server\.env` instead, which is shared by all
users of the system and overrides the values of the bundled `.env` file.

Use `--config-file <path>` or the environment variable `WRESTLING_SCOREBOARD_SERVER_CONFIG_FILE` to choose another
config file, which overrides the values of the bundled `.env` file.

If the PostgreSQL client tools (`psql`, `pg_dump`) are not on the `PATH`, set `POSTGRES_BIN_DIR` to their directory.

### Database

For a manual / more detailed setup of the Postgres database, see the [database docs](./database/README.md).

### Run server

Execute the `./bin/wrestling-scoreboard-server` executable from within the `wrestling_scoreboard_server` directory, to handle resource paths correctly.

See `--help` for all commands and options.

On start, the server checks its configuration, the PostgreSQL connection and the port, and exits with a description of the problem, if one of them fails.

For managing app users and access, a default administration user for the app is created:
  - Username: `admin`
  - Password: `admin`

It is recommended to sign in to the client and change the password, especially if providing a public server.

## Deployment

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

To view server logs:
`journalctl --user -u wrestling-scoreboard-server`

### Web server

If using [Nginx](https://en.wikipedia.org/wiki/Nginx) as Reverse Proxy, you can take advantage of [this config](docs/nginx/wrestling-scoreboard-server.conf) files.

## Development

### Build package

```shell
dart compile exe bin/server.dart
```
