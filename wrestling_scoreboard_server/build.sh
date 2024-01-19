#!/usr/bin/env bash

while getopts v: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
    esac
done

VERSION=${VERSION:-v$(grep -oP '^version:\s*\K[0-9A-Za-z.\-]*\s*$' pubspec.yaml)}
ARCH=$(uname -m)
case $ARCH in
    i386)   ARCH="amd32" ;;
    i686)   ARCH="amd32" ;;
    x86_64) ARCH="amd64" ;;
    arm)    ARCH="arm32" ;;
    aarch64)   ARCH="arm64" ;;
esac

echo "Version: $VERSION";
echo "Arch: $ARCH ($(uname -m))";

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
OUTPUT_PATH="build/wrestling_scoreboard_server-${PLATFORM}-${ARCH}-${VERSION}.tar.gz"
tar -czf ${OUTPUT_PATH} bin/${EXEC_NAME} public database .env.example
echo ${OUTPUT_PATH}
