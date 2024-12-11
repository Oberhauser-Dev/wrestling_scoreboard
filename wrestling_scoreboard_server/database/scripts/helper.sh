#!/usr/bin/env bash

# Recommended backup paths:
# https://askubuntu.com/questions/575679/what-is-the-default-location-for-backup-files-of-another-server
#/var/lib/<app>/backups
#/var/local/<app>/backups
#/var/opt/<app>/backups

PARENT_DIR="${PARENT_DIR:-database/pitr}"
# Make relative path absolute
if [[ "$PARENT_DIR" != /* ]]; then
    PARENT_DIR="$(cd "$PARENT_DIR" && pwd)"
fi
PGDATA_PATH="$PARENT_DIR/.pg_data_path"

# Retrieve PostgreSQL parameters dynamically
function get_pg_data_path() {
    local param="data_directory"

    if [[ -f "$PGDATA_PATH" ]]; then
        # Return saved data folder path
        cat "$PGDATA_PATH"
    else
        # Get the value of the parameter, trim whitespace, and write to the file
        local result
        result=$(psql -U postgres -t -c "SHOW $param;" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
      
        echo "$result" > "$PGDATA_PATH"
        echo "$result"
    fi
}

# Automatically retrieve PGDATA
PGDATA=$(get_pg_data_path)

# Define ARCHIVE_DIR dynamically (extracted from postgresql.conf or defaulted)
ARCHIVE_DIR=$(grep -E "^[^#]*archive_command" "$PGDATA/postgresql.conf" | sed -E "s/.*'cp %p (.*)\/%f'.*/\1/")
if [ -z "$ARCHIVE_DIR" ]; then
    ARCHIVE_DIR="$PARENT_DIR/archive" # Default path if not set
fi

# Set backup and restore directories
BACKUP_DIR="${BACKUP_DIR:-$PARENT_DIR/backup}" # Allow overrides
RESTORE_DIR="${RESTORE_DIR:-$PARENT_DIR/restore}" # Allow overrides

# Function to restart PostgreSQL dynamically
restart_postgresql() {
  pg_ctl -D "$PGDATA" restart
}

start_postgresql() {
  pg_ctl -D "$PGDATA" start
}

stop_postgresql() {
  if test -d "$PGDATA"; then
    pg_ctl -D "$PGDATA" stop
  fi
}

function pgDataDir() {
    echo "$PGDATA"
}

function parentDir() {
    echo "$PARENT_DIR"
}

function backupDir() {
    echo "$BACKUP_DIR"
}

function restoreDir() {
    echo "$RESTORE_DIR"
}

function archiveDir() {
    echo "$ARCHIVE_DIR"
}
