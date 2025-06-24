#!/bin/bash
function get_monitoring_data {
    echo "===== CPU - $(date +%c) ====="
    echo
    echo "MOST CPU-CONSUMING PROCESSES: "
    echo
    ps -eo pid,user,comm,%cpu,etime --no-headers | sort -k4 -nr | head -n 10 | \
    awk 'BEGIN {
        printf "%-6s %-10s %-20s %-10s %-10s\n", "PID", "USER", "COMMAND", "%CPU", "ELAPSED"
    }
    {
        printf "%-6s %-10s %-20s %-10s %-10s\n", $1, $2, $3, $4"%", $5
    }'
}

# Trap to restore cursor on exit
clear 
# Initial display
get_monitoring_data

# while true; do
#     sleep 1
#     # Move cursor to top-left (1,1) without clearing
#     tput cup 0 0
#     get_monitoring_data
# done