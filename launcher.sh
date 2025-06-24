#!/bin/bash

if ! sudo -v; then
    echo "ERROR: This script requires sudo privileges"
    exit 1
fi

if ! command -v multitail &> /dev/null; then
    echo "multitail is not installed."
    echo "We are using multitail as monitor display so please install it to use this tool."
    echo "Installation:"
    echo "  Ubuntu/Debian: sudo apt install multitail"
    echo "  CentOS/RHEL: sudo yum install multitail"
    echo "  Fedora: sudo dnf install multitail"
    exit 1
fi

if ! command -v tmux &> /dev/null; then
    echo "tmux is not installed."
    echo "We are using tmux as monitor display so please install it to use this tool."
    echo "Installation:"
    echo "  Ubuntu/Debian: sudo apt install tmux"
    echo "  CentOS/RHEL: sudo yum install tmux"
    echo "  Fedora: sudo dnf install tmux"
    exit 1
fi

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
    echo "⚠️ Terminal détecté mais aucun terminal graphique trouvé."
    echo "▶️ Lancement direct du script dans ce terminal..."
    "$MONITOR_SCRIPT"
    "$LOGS_SCRIPT"
else
    echo "❌ Aucun terminal compatible trouvé."
    echo "💡 Installez-en un comme : gnome-terminal, xfce4-terminal, xterm, etc."
    exit 1
fi