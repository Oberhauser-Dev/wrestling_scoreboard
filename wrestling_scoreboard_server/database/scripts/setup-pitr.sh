#!/usr/bin/env bash

source .env
export PGPASSWORD=$DATABASE_PASSWORD
source database/scripts/helper.sh

PGDATA=$(pgDataDir)
BACKUP_DIR=$(backupDir)
ARCHIVE_DIR=$(archiveDir)
RESTORE_DIR=$(restoreDir)

echo "PGDATA: $PGDATA"
echo "BACKUP_DIR: $BACKUP_DIR"
echo "ARCHIVE_DIR: $ARCHIVE_DIR"
echo "RESTORE_DIR: $RESTORE_DIR"

if ! test -d "$ARCHIVE_DIR"; then
    mkdir -p "$ARCHIVE_DIR"
    chmod 700 "$ARCHIVE_DIR"
fi

# Configure WAL archiving if not already set
if ! grep -q "archive_mode = on" "$PGDATA/postgresql.conf"; then
    echo "Setting up WAL archiving..."
    cat >> "$PGDATA/postgresql.conf" <<EOF
archive_mode = on
archive_command = 'cp %p $ARCHIVE_DIR/%f'
wal_level = replica
EOF
    restart_postgresql
fi


# Take a base backup
echo "Taking a base backup..."
if [ -d "$BACKUP_DIR" ]; then
    rm -rf "$BACKUP_DIR"
fi
mkdir -p "$BACKUP_DIR"
pg_basebackup -D "$BACKUP_DIR" -F tar -z -P -X stream -U "postgres"
