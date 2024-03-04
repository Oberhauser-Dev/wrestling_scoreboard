# Wrestling Scoreboard Server

Wrestling software server for managing team matches and competitions.

## Setup

See [database docs](./database/README.md), to set up the Postgres database.

### Environment variables:

Create file `.env` in `wrestling_scoreboard_server` directory.
A pre-configuration can be found in `.env.example` file. Change the values to your needs.

### Run server

Execute the `./bin/wrestling-scoreboard-server` executable from within the `wrestling_scoreboard_server` directory, to handle resource paths correctly.

### Linux Systemd service

```shell
sudo nano /etc/systemd/system/wrestling-scoreboard-server.service
```

```
[Unit]
Description=Wrestling-Scoreboard-Server

[Service]
ExecStart=/opt/wrestling_scoreboard_server/bin/wrestling-scoreboard-server
Restart=on-failure
RestartSec=15
User=www
Group=www
WorkingDirectory=/opt/wrestling_scoreboard_server

[Install]
WantedBy=multi-user.target
```

```shell
sudo systemctl daemon-reload
sudo systemctl enable wrestling-scoreboard-server.service
sudo systemctl start wrestling-scoreboard-server.service
```

## Development

### Build package

```shell
./build.sh -v 0.0.1
```
