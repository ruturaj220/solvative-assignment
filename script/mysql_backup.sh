#!/bin/bash

BACKUP_DIR="/home/ubuntu/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"
MYSQL_USER="root"
MYSQL_PASS="your_mysql_password"  # In production, use a secure env var or Vault

echo "========== MYSQL BACKUP =========="

# Check if MySQL is installed
if ! command -v mysqldump &> /dev/null; then
    echo "MySQL client not installed. Skipping backup."
    exit 1
fi

mkdir -p "$BACKUP_DIR"

mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASS" --all-databases > "$BACKUP_FILE" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup successful! File: $BACKUP_FILE"
else
    echo "Backup failed. Please check credentials or permissions."
fi

