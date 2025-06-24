#!/bin/bash

# Function to get monitoring data
get_monitoring_data() {
    echo "===== RAM - $(date +%c) ====="
    echo
    echo "MOST RAM-CONSUMING PROCESSES: "
    ps -eo pid,user,comm,%mem,etime --no-headers | sort -k4 -nr | head -n 10 | \
    awk 'BEGIN {
        printf "%-6s %-10s %-20s %-10s %-10s\n", "PID", "USER", "COMMAND", "%MEM", "ELAPSED"
    }
    {
        printf "%-6s %-10s %-20s %-10s %-10s\n", $1, $2, $3, $4"%", $5
    }'
}

# Hide cursor for cleaner display
tput civis

# Trap to restore cursor on exit
trap 'tput cnorm; exit' INT TERM
clear 
# Initial display
get_monitoring_data

while true; do
    sleep 1
    # Move cursor to top-left (1,1) without clearing
    tput cup 0 0
    get_monitoring_data
done