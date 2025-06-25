#!/bin/bash

# Longueur max de la barre
BAR_LENGTH=30

# Couleurs ANSI
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

function draw_bar() {
    local value=$1
    local max=$2
    local color=$3
    local label=$4
    local unit=$5
    
    # Calcul du pourcentage (limité à 100%)
    local percent=$(awk "BEGIN {printf \"%.0f\", ($value * 100) / $max}")
    if (( percent > 100 )); then
        percent=100
    fi
    
    local filled=$(( percent * BAR_LENGTH / 100 ))
    local empty=$(( BAR_LENGTH - filled ))
    
    local bar_filled=$(printf "%${filled}s" | tr ' ' '#')
    local bar_empty=$(printf "%${empty}s" | tr ' ' '-')
    
    printf "%-18s %6.1f %-6s [%b%s%s%b] %3d%%\n" "$label" "$value" "$unit" "$color" "$bar_filled" "$bar_empty" "$RESET" "$percent"
}

function read_rx_tx {
    # Lecture des statistiques réseau pour eth0 et wlan0
    awk '/eth0|wlan0/ {rx += $2; tx += $10} END {print rx+0, tx+0}' /proc/net/dev
}

function get_bandwidth_status {
    # Première lecture
    read old_rx old_tx < <(read_rx_tx)
    
    # Attendre 1 seconde
    sleep 1
    
    # Deuxième lecture
    read new_rx new_tx < <(read_rx_tx)
    
    # Calcul des différences
    delta_rx=$(( new_rx - old_rx ))
    delta_tx=$(( new_tx - old_tx ))
    
    # Conversion en KB/s
    rx_speed=$(awk "BEGIN {printf \"%.2f\", $delta_rx / 1024}")
    tx_speed=$(awk "BEGIN {printf \"%.2f\", $delta_tx / 1024}")
    
    # Fonction pour convertir et formater les unités
    convert_and_get_unit() {
        local speed_kb=$1
        if (( $(awk "BEGIN {print ($speed_kb >= 1024)}") )); then
            echo "MB/s"
        else
            echo "KB/s"
        fi
    }
    
    convert_speed() {
        local speed_kb=$1
        if (( $(awk "BEGIN {print ($speed_kb >= 1024)}") )); then
            awk "BEGIN {printf \"%.2f\", $speed_kb / 1024}"
        else
            printf "%.2f" "$speed_kb"
        fi
    }
    
    # Conversion des vitesses
    rx_converted=$(convert_speed "$rx_speed")
    tx_converted=$(convert_speed "$tx_speed")
    rx_unit=$(convert_and_get_unit "$rx_speed")
    tx_unit=$(convert_and_get_unit "$tx_speed")
    
    # Affichage des barres (max à 1000 KB/s = 1 MB/s pour la barre)
    local max_kb=1000
    draw_bar "$rx_converted" "$max_kb" "$CYAN" "DOWNLOAD ↓:" "$rx_unit"
    draw_bar "$tx_converted" "$max_kb" "$BLUE" "UPLOAD   ↑:" "$tx_unit"
}

# Fonction principale pour tester
function get_monitoring_data {
    echo "===== NETWORK - $(date +%c) ====="
    echo
    echo "LOCAL IP ADDRESS: $(hostname -I | awk '{print $1}')"
    echo "OPEN PORTS:"
    ss -tulpn
    echo 
    get_bandwidth_status
    echo
    echo "=== ACTIVE NETWORK PROCESSES ===:"
    echo
    echo "PID    COMMAND           CONNEXIONS"
    echo "----   -------           ----------"
    lsof -i -n | grep -v COMMAND | awk '{print $2, $1}' | sort | uniq -c | sort -nr | head -10 | 
    while read count pid cmd; do
        printf "%-6s %-15s %10s\n" "$pid" "$cmd" "$count"
    done
}

clear
get_monitoring_data