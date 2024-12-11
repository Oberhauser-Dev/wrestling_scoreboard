#!/usr/bin/env bash

source .env
export PGPASSWORD=$DATABASE_PASSWORD
source database/scripts/helper.sh

RECOVERY_TARGET_TIME="${1}"

PARENT_DIR=$(parentDir)
BACKUP_DIR=$(backupDir)
PGDATA=$(pgDataDir)
ARCHIVE_DIR=$(archiveDir)
RESTORE_DIR=$(restoreDir)

echo "PGDATA: $PGDATA"
echo "BACKUP_DIR: $BACKUP_DIR"
echo "ARCHIVE_DIR: $ARCHIVE_DIR"
echo "RESTORE_DIR: $RESTORE_DIR"
echo "RECOVERY_TARGET_TIME: $RECOVERY_TARGET_TIME"

# Restore from backup and prepare for PITR
echo "Restoring backup and preparing for PITR..."

stop_postgresql

# Restore backup
rm -rf "$RESTORE_DIR"
mkdir -p "$RESTORE_DIR"
tar -xzvf "$BACKUP_DIR/base.tar.gz" -C "$RESTORE_DIR"

if [ -n "$RECOVERY_TARGET_TIME" ]; then
  RECOVERY_TARGET_ASSIGNMENT="recovery_target_time = '$RECOVERY_TARGET_TIME'"
else
  RECOVERY_TARGET_ASSIGNMENT="recovery_target = 'immediate'"
fi

# Configure recovery
cat > "$RESTORE_DIR/postgresql.conf" <<EOF
restore_command = 'cp $ARCHIVE_DIR/%f %p'
$RECOVERY_TARGET_ASSIGNMENT
EOF

touch "$RESTORE_DIR/recovery.signal"

# Replace PGDATA with restored data directory
cp -r "$PGDATA" "$PARENT_DIR/$(date +"%Y-%m-%d_%H-%M")_pgData"
rm -r "${PGDATA:?}/"*
mv "$RESTORE_DIR/"* "$PGDATA/"

start_postgresql

# Verify recovery
echo "Verifying recovery..."
psql -U postgres -c "SELECT pg_is_in_recovery();"
