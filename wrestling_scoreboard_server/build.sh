#!/usr/bin/env bash

while getopts v: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
    esac
done

VERSION=${VERSION:-v$(grep -oP '^version:\s*\K[0-9A-Za-z.\-]*\s*$' pubspec.yaml)}

echo "Version: $VERSION";
echo "Arch: $(uname -m)";

if [[ "$OSTYPE" =~ ^msys ]]; then
    EXEC_NAME="wrestling-scoreboard-server.exe"
    PLATFORM="windows"
elif [[ "$OSTYPE" =~ ^darwin ]]; then
    EXEC_NAME="wrestling-scoreboard-server"
    PLATFORM="macos"
else
    EXEC_NAME="wrestling-scoreboard-server"
    PLATFORM="linux"
fi

mkdir ./build
dart pub get
dart compile exe bin/server.dart -o ./bin/${EXEC_NAME}
chmod +x ./bin/${EXEC_NAME}
tar -czf build/wrestling_scoreboard_server-${PLATFORM}-${VERSION}.tar.gz bin/${EXEC_NAME} public .env.example
