#!/bin/bash

# === CONFIG ===
BACKUP_DIR="/home/ubuntu/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"
MYSQL_USER="root"
MYSQL_PASS="your_mysql_password"  # REPLACE with env variable in production

# Create backup dir if missing
mkdir -p "$BACKUP_DIR"

# === 1. CPU & Memory Report ===
echo "========== SYSTEM MONITOR REPORT =========="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

echo "[CPU USAGE]"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Load: " $2 "% used"}'

echo
echo "[MEMORY USAGE]"
free -h

echo
echo "[TOP 5 CPU CONSUMING PROCESSES]"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

echo
echo "[TOP 5 MEMORY CONSUMING PROCESSES]"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

# === 2. MySQL Backup ===
echo
echo "========== MYSQL BACKUP =========="

# Check if MySQL is installed
if ! command -v mysqldump &> /dev/null; then
    echo "MySQL client not installed. Skipping backup."
    exit 1
fi

# Create backup dir if missing
mkdir -p "$BACKUP_DIR"

# Perform backup
mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASS" --all-databases > "$BACKUP_FILE" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "Backup successful! File: $BACKUP_FILE"
else
    echo "Backup failed. Please check credentials or permissions."
fi

