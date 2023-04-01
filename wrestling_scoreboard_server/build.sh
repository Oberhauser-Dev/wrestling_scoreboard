#!/bin/bash

mkdir ./build
dart compile exe bin/server.dart -o ./bin/wrestling-scoreboard-server
tar -czf build/wrestling-scoreboard-server-$(grep -oP '^version:\s*\K[0-9.]*\s*$' pubspec.yaml)-$(uname -m).tar.gz bin/wrestling-scoreboard-server public .env
