#!/bin/bash

# Function to get monitoring data
function get_monitoring_data {
    echo "===== DISK - $(date +%c) ====="
    echo
    iostat -d 1 1
    echo "=== DISK I/O USAGE BY PROCESS ==="
    pidstat -d 1 1 | awk '
    /^[ 0-9]/ && NF >= 9 && ($4+$5)>0 {
        printf "%-6s %-20s %10s\n", $3, $9, ($4+$5)" KB/s"
    }' | sort -k3 -nr | awk '
    BEGIN { printf "\n%-6s %-20s %-10s\n", "PID", "COMMAND", "DISK I/O" }
    { print }
    '
}

clear
get_monitoring_data