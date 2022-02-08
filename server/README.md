# Wrestling Scoreboard Server

A HTTP-server application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

## Build package

```shell
dart pub get
dart compile exe bin/server.dart -o ./bin/server
```

## Systemd service
```
sudo nano /etc/systemd/system/wrestling-scoreboard-server.service
```

```
[Unit]
Description=Wrestling-scoreboard-server

[Service]
ExecStart=/var/www/wrestling_scoreboard/server/bin/server
Restart=on-failure
User=www
Group=www
WorkingDirectory=/var/www/wrestling_scoreboard/server

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
sudo systemctl enable wrestling-scoreboard-server.service
sudo systemctl start wrestling-scoreboard-server.service
```
