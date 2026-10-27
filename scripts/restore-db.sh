#!/usr/bin/env bash
set -euo pipefail

# YanMata Production Database Restore Script
# Verifies sha256 checksum and integrity before restoring database.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <path-to-backup.sqlite> [target-db-path]" >&2
    exit 1
fi

BACKUP_FILE="$1"
TARGET_DB="${2:-"$ROOT_DIR/apps/api/database/database.sqlite"}"
CHECKSUM_FILE="${BACKUP_FILE}.sha256"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE" >&2
    exit 1
fi

if [ -f "$CHECKSUM_FILE" ]; then
    echo "==> Verifying SHA-256 checksum..."
    EXPECTED_SHA="$(cat "$CHECKSUM_FILE" | awk '{print $1}')"
    ACTUAL_SHA="$(shasum -a 256 "$BACKUP_FILE" | awk '{print $1}')"
    if [ "$EXPECTED_SHA" != "$ACTUAL_SHA" ]; then
        echo "Error: Checksum mismatch!" >&2
        echo "  Expected: $EXPECTED_SHA" >&2
        echo "  Actual:   $ACTUAL_SHA" >&2
        exit 1
    fi
    echo "    Checksum OK: $ACTUAL_SHA"
else
    echo "Warning: No accompanying .sha256 file found. Proceeding with integrity check only."
fi

# Verify SQLite integrity
echo "==> Verifying SQLite database integrity..."
INTEGRITY="$(sqlite3 "$BACKUP_FILE" "PRAGMA integrity_check;")"
if [ "$INTEGRITY" != "ok" ]; then
    echo "Error: SQLite integrity check failed: $INTEGRITY" >&2
    exit 1
fi
echo "    Integrity OK."

# If target DB exists, create safety rollback copy first
if [ -f "$TARGET_DB" ]; then
    PRE_RESTORE_BACKUP="${TARGET_DB}.pre-restore-$(date -u +"%Y%m%d_%H%M%SZ")"
    echo "==> Creating safety rollback snapshot at $PRE_RESTORE_BACKUP..."
    cp "$TARGET_DB" "$PRE_RESTORE_BACKUP"
fi

echo "==> Restoring database to $TARGET_DB..."
cp "$BACKUP_FILE" "$TARGET_DB"

echo "==> Verifying restored database..."
RESTORED_INTEGRITY="$(sqlite3 "$TARGET_DB" "PRAGMA integrity_check;")"
if [ "$RESTORED_INTEGRITY" != "ok" ]; then
    echo "Error: Restored database integrity check failed: $RESTORED_INTEGRITY" >&2
    exit 1
fi

echo "==> Database restore completed successfully."
