#!/bin/bash

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

