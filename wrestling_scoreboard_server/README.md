# Wrestling Scoreboard Server

Wrestling software server for managing team matches and competitions.

## Setup

Download the latest server version from the [releases section](https://github.com/Oberhauser-Dev/wrestling_scoreboard/releases)
and extract it into e.g. inside `$HOME/.local/share/wrestling_scoreboard_server`.

It is recommended to start the app with user privileges, here `www`. Avoid using `root`, especially if the server is open to the public.

### Environment variables:

Create file `.env` in the `wrestling_scoreboard_server` directory.
A pre-configuration can be found in `.env.example` file (`cp .env.example .env`). Change the values to your needs.

### Database

You can run the database e.g. in a docker container:

```shell
source .env
docker pull postgres:latest
docker run --detach --name wrestling_scoreboard_database -p ${DATABASE_HOST}:${DATABASE_PORT}:5432 -e POSTGRES_USER=${DATABASE_USER} -e POSTGRES_DB=${DATABASE_NAME} -e POSTGRES_PASSWORD=${DATABASE_PASSWORD} postgres
```

For a manual / more detailed setup of the Postgres database, see the [database docs](./database/README.md).

### Run server

Execute the `./bin/wrestling-scoreboard-server` executable from within the `wrestling_scoreboard_server` directory, to handle resource paths correctly.

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
