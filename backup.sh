#!/bin/bash

# Configuration
BACKUP_DIR="./backups"
SOURCE_DIR="./generated_config"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE_NAME="backup_$DATE.tar.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Starting backup of $SOURCE_DIR..."
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

# Check result
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Backup created at $BACKUP_DIR/$ARCHIVE_NAME"
    ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +6 | xargs -r rm --
else
    echo "[ERROR] Backup failed!"
    exit 1
fi
