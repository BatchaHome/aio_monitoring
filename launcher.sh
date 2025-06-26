#!/bin/bash

if ! sudo -v; then
    echo "ERROR: This script requires sudo privileges"
    exit 1
fi

function CheckCommand {
    declare -A commands=(
        ["multitail"]="We are using multitail as monitor display so please install it to use this tool."
        ["tmux"]="We are using tmux as monitor display so please install it to use this tool."
        ["iostat"]="iostat reports CPU and I/O statistics for devices, partitions, and the system overall."
        ["pidstat"]="pidstat shows statistics per PID (process), including CPU usage, I/O, memory, and task scheduling info."
        ["ss"]="ss displays socket statistics (TCP, UDP, etc.)."
        ["lsof"]="lsof Lists all open files by processes. In Unix, everything is a file (sockets, devices, etc.)."
    )

    # Check for missing commands
    missing_commands=()
    for cmd in "${!commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_commands+=("$cmd")
        fi
    done

    # If any commands are missing, display installation instructions and exit
    if [ ${#missing_commands[@]} -gt 0 ]; then
        echo "The following required commands are not installed:"
        echo
        
        for cmd in "${missing_commands[@]}"; do
            echo "• $cmd is not installed."
            echo "  ${commands[$cmd]}"
            echo "  Installation:"
            echo "    Ubuntu/Debian: sudo apt install $cmd"
            echo "    CentOS/RHEL: sudo yum install $cmd"
            echo "    Fedora: sudo dnf install $cmd"
            echo
        done
        
        exit 1
    fi
}

CheckCommand

# Configuration
ROWS=40
COLS=120
WIDTH=1440
HEIGHT=900
W_LOG=1600
H_LOG=1050
MONITOR_SCRIPT="./tmux_launcher.sh"
LOGS_SCRIPT="./multitail_logs.sh"



# Tentatives de lancement selon le terminal disponible
if command -v gnome-terminal &>/dev/null; then
    gnome-terminal --geometry=${COLS}x${ROWS} -- bash -c "$MONITOR_SCRIPT; exec bash" &
    gnome-terminal --geometry=${COLS}x${ROWS} -- bash -c "$LOGS_SCRIPT; exec bash" &

elif command -v xfce4-terminal &>/dev/null; then
    xfce4-terminal --geometry=${COLS}x${ROWS} --command="$MONITOR_SCRIPT" &
    xfce4-terminal --geometry=${COLS}x${ROWS} --command="$LOGS_SCRIPT" &
   
elif command -v xterm &>/dev/null; then
    xterm -geometry ${COLS}x${ROWS} -e "$MONITOR_SCRIPT" &
    xterm -geometry ${COLS}x${ROWS} -e "$LOGS_SCRIPT" &

elif command -v konsole &>/dev/null; then
    konsole --geometry ${COLS}x${ROWS} -e "$MONITOR_SCRIPT" &
    konsole --geometry ${COLS}x${ROWS} -e "$LOGS_SCRIPT" &

elif command -v qterminal &>/dev/null; then
    qterminal --geometry ${W_LOG}x${H_LOG} -e "$MONITOR_SCRIPT" &
    qterminal --geometry ${W_LOG}x${H_LOG} -e "$LOGS_SCRIPT" &
    
elif [[ "$TERM" == xterm* ]]; then
    $MONITOR_SCRIPT
    $LOGS_SCRIPT
else
    echo "Sorry didn't find any terminal suit to run this script."
    echo "Please install another one."
    exit 1
fi