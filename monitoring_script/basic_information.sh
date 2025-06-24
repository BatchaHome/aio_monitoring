#!/bin/bash

function get_temp {
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        echo "$((temp/1000))°C"
    else
        echo "Unavailable"
    fi
}

function get_ram {
    mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}' &)
    mem_free_kb=$(grep MemFree /proc/meminfo | awk '{print $2}' &)
    mem_available_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}' &)

    
    mem_total_mb=$((mem_total_kb / 1024))
    mem_free_mb=$((mem_free_kb / 1024))
    mem_available_mb=$((mem_available_kb / 1024))
    mem_used_mb=$((mem_total_mb - mem_free_mb - buffers_mb - cached_mb))

    # Swap info
    swap_total_kb=$(grep SwapTotal /proc/meminfo | awk '{print $2}' &)
    swap_free_kb=$(grep SwapFree /proc/meminfo | awk '{print $2}' &)
    swap_total_mb=$((swap_total_kb / 1024))
    swap_free_mb=$((swap_free_kb / 1024))
    swap_used_mb=$((swap_total_mb - swap_free_mb))
    mem_used_pct=$(( 100 * mem_used_mb / mem_total_mb ))
    # Display RAM
    echo "RAM: ${mem_used_mb}/${mem_total_mb} MB ${mem_used_pct}% Used"
    # Display Swap
    echo "SWAP: ${swap_used_mb}/${swap_total_mb} MB"   
}

# Function to get monitoring data
function get_monitoring_data {
    echo "===== AIO MONITORING - $(date +%c) ====="
    echo
    echo "UPTIME: $(uptime -p &)"
    echo "HOSTNAME: $(hostname &)"
    echo "USERNAME: $(whoami &)"
    echo "OS: $(uname -o 2>/dev/null || echo "Unavailable" &)"
    echo "KERNEL: $(uname -r &)"
    echo
    echo "CPU USAGE: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 "%"}' &)"
    echo "CPU TEMPERATURE: $(get_temp &)"
    get_ram 
    echo "DISK:"
    df -h --output=source,size,used,avail / &
}

# Hide cursor for cleaner display

# Trap to restore cursor on exit
# Initial display
clear
get_monitoring_data

# while true; do
#     sleep 1
#     # Move cursor to top-left (1,1) without clearing
#     tput cup 0 0
#     get_monitoring_data
# done