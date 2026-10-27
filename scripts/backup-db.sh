#!/usr/bin/env bash
set -euo pipefail

# YanMata Production Database Backup Script
# Creates a verified, sha256-checksummed backup of the database.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DB_PATH="${1:-"$ROOT_DIR/apps/api/database/database.sqlite"}"
BACKUP_DIR="${2:-"$ROOT_DIR/backups"}"

if [ ! -f "$DB_PATH" ]; then
    echo "Error: Database file does not exist at $DB_PATH" >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"
TIMESTAMP="$(date -u +"%Y%m%d_%H%M%SZ")"
BACKUP_FILE="$BACKUP_DIR/yanmata_db_${TIMESTAMP}.sqlite"
CHECKSUM_FILE="${BACKUP_FILE}.sha256"

echo "==> Creating database backup to $BACKUP_FILE..."

# Use SQLite online backup VACUUM INTO for atomic snapshot
sqlite3 "$DB_PATH" "VACUUM INTO '$BACKUP_FILE';"

# Verify integrity of the backup file
INTEGRITY="$(sqlite3 "$BACKUP_FILE" "PRAGMA integrity_check;")"
if [ "$INTEGRITY" != "ok" ]; then
    echo "Error: Backup integrity check failed: $INTEGRITY" >&2
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Generate SHA-256 checksum
shasum -a 256 "$BACKUP_FILE" | awk '{print $1}' > "$CHECKSUM_FILE"

echo "==> Backup complete and verified."
echo "    File: $BACKUP_FILE"
echo "    Size: $(wc -c < "$BACKUP_FILE" | tr -d ' ') bytes"
echo "    SHA-256: $(cat "$CHECKSUM_FILE")"
