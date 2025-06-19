#!/bin/bash

# Configuration
ROWS=40
COLS=120
WIDTH=1200
HEIGHT=900
SCRIPT="./aio_monitor.sh"

# Tentatives de lancement selon le terminal disponible
if command -v gnome-terminal &>/dev/null; then
    gnome-terminal --geometry=${COLS}x${ROWS} -- bash -c "$SCRIPT; exec bash"

elif command -v xfce4-terminal &>/dev/null; then
    xfce4-terminal --geometry=${COLS}x${ROWS} --command="$SCRIPT"

elif command -v xterm &>/dev/null; then
    xterm -geometry ${COLS}x${ROWS} -e "$SCRIPT"

elif command -v konsole &>/dev/null; then
    konsole --geometry ${COLS}x${ROWS} -e "$SCRIPT"

elif command -v qterminal &>/dev/null; then
    qterminal --geometry ${WIDTH}x${HEIGHT} -e "bash $SCRIPT"

elif [[ "$TERM" == xterm* ]]; then
    echo "⚠️ Terminal détecté mais aucun terminal graphique trouvé."
    echo "▶️ Lancement direct du script dans ce terminal..."
    "$SCRIPT"

else
    echo "❌ Aucun terminal compatible trouvé."
    echo "💡 Installez-en un comme : gnome-terminal, xfce4-terminal, xterm, etc."
    exit 1
fi
