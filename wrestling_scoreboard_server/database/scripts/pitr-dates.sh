#!/usr/bin/env bash

source .env
export PGPASSWORD=$DATABASE_PASSWORD
source database/scripts/helper.sh

ARCHIVE_DIR=$(archiveDir)

FIRST_WAL=$(ls "$ARCHIVE_DIR" | sort | head -n 1)
LAST_WAL=$(ls "$ARCHIVE_DIR" | sort | tail -n 1)

echo "First created file: $FIRST_WAL"
echo "Last created file: $LAST_WAL"

pg_waldump "$ARCHIVE_DIR/$FIRST_WAL"
#pg_waldump "$ARCHIVE_DIR/$LAST_WAL" | grep 'timestamp'  | tail -n 1
