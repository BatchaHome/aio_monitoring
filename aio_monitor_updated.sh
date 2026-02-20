#!/bin/bash

if ! sudo -v; then
    echo "ERROR: This script requires sudo privileges"
    exit 1
fi

echo "Launching the script ..."
sleep 1
clear
tput civis

cols=$(tput cols)
rows=$(tput lines)
sizeOneThirdCols=$(( $(tput cols) / 3 ))

function WelcomeMessage {
    echo $'
			   / \  |_ _/ _ \  |  \/  |/ _ \| \ | |_ _|_   _/ _ \|  _ \|_ _| \ | |/ ___|
			  / _ \  | | | | | | |\/| | | | |  \| || |  | || | | | |_) || ||  \| | |  _ 
			 / ___ \ | | |_| | | |  | | |_| | |\  || |  | || |_| |  _ < | || |\  | |_| |
			/_/   \_\___\___/  |_|  |_|\___/|_| \_|___| |_| \___/|_| \_\___|_| \_|\____|
	   	\n'

    echo $'WELCOME TO AIO MONITORING\n'
}

function DateIdleBox {

    tput cup 1 5
    date +%c

    uptime=$(uptime -p)
    tput cup 1 $(( cols - ${#uptime} - 5 ))
    echo $uptime
}


function StaticInfoSystem {

    tput cup 6 5
    echo "HOSTNAME: $(hostname)"
    tput cup 7 5
    echo "USERNAME: $(whoami)"
    tput cup 8 5
    echo "OS: $(uname -o 2>/dev/null || echo "Unavailable")"
    tput cup 9 5
    echo "KERNEL: $(uname -r)"

}

function NetworkInformation {


    tput cup 6 $(( sizeOneThirdCols + 5 ))
    echo "IP ADDRESS: "

    tput cup 7 $(( sizeOneThirdCols + 5 ))
    echo "PORT OPEN: "

    tput cup 8 $(( sizeOneThirdCols + 5 ))
    echo "DOWNLOAD: "

    tput cup 9 $(( sizeOneThirdCols + 5 ))
    echo "UPLOAD: "

}


function NetworkByProcess {

    
    tput cup 6 $(( (sizeOneThirdCols * 2) + 5 ))
    echo "PROCESS"

}


function CpuInformation {

    tput cup 15 5
    echo "CPU USAGE:  $(top -bn1 | grep "Cpu(s)" | awk '{print $2 "%"}')"

    tput cup 16 5
    echo "CPU SPEED: $(awk -F: '/^cpu MHz/ {print $2 " MHz"; exit}' /proc/cpuinfo | xargs)"

    tput cup 17 5
    echo "CPU TEMP: "

    tput cup 19 5
    echo "CPU-INTENSIVE PROCESS: $(ps aux --sort=-%cpu | awk 'NR==2 {print $11, $3 "%"}')"


}

function RamInformation {

    tput cup 15 $(( sizeOneThirdCols + 5 ))
    echo "RAM USAGE: $(free -h | awk '/Mem:/ {print "Used: " $3 " / Total: " $2}')"

    tput cup 16 $(( sizeOneThirdCols + 5 ))
    echo "RAM SPEED: "

    tput cup 17 $(( sizeOneThirdCols + 5 ))
    echo "RAM TEMP: "

    tput cup 19 $(( sizeOneThirdCols + 5 ))
    echo "RAM-INTENSIVE PROCESS: $(ps aux --sort=-%mem | awk 'NR==2 {print $11, $4 "%"}')"

}


function DiskInformation {
    
    tput cup 15 $(( (sizeOneThirdCols * 2) + 5 ))
    echo "DISK USAGE/DISK TOTAL: $(df -h --output=source,size,used,avail,pcent / | tail -n 1)"

    tput cup 16 $(( (sizeOneThirdCols * 2) + 5 ))
    echo "DISK READ: $(iostat -d 1 1 | awk '/^[a-z]/ {total_read+=$3} END {print total_read " KB/s"}')"

    tput cup 17 $(( (sizeOneThirdCols * 2) + 5 ))
    echo "DISK WRITE: $(iostat -d 1 1 | awk '/^[a-z]/ {total_write+=$4} END {print total_write " KB/s"}')"
    tput cup 19 $(( (sizeOneThirdCols * 2) + 5 ))
    echo "DISK-INTENSIVE PROCESS: $(sudo pidstat -d 1 1 | awk 'NR>3 && NF>1 && ($4+$5)>0 {print $9, ($4+$5)" KB/s"}' | sort -k2 -nr | head -n 1)"
}


function DisplayStructure {

    # ============ LINE SEPARATOR ============

    tput cup 0 0 # FIRST LINE SEPARATOR
    printf '=%.0s' $(seq 1 $cols)

    tput cup 2 0 # SECOND LINE SEPARTOR
    printf '=%.0s' $(seq 1 $cols)

    tput cup 11 0 # THIRD LINE SEPARATOR
    printf '=%.0s' $(seq 1 $cols)

    tput cup 21 0 # FOURTH LINE SEPARATOR
    printf '=%.0s' $(seq 1 $cols)

    tput cup 31 0 # FIFTH LINE SEPARATOR
    printf '=%.0s' $(seq 1 $cols)



    # | COLUMN SEPARATOR |

    tput cup 1 0 # LEFT FIRST BLOCK
    echo "|"

    tput cup 1 $cols # RIGHT FIRST BLOCK
    echo "|"


    # LEFT SECOND BLOCK

    title="INFO SYSTEM"
    tput cup 4 $(( ((sizeOneThirdCols - ${#title}) / 2) ))
    echo $title

    i=3
    while [ $i -le 10 ] ; do

        tput cup $i 0
        echo "|"
        i=$((i + 1))

    done

    # SECOND SEPARATOR SECOND BLOCK

    title="NETWORK INFO"
    tput cup 4 $(( (((sizeOneThirdCols - ${#title}) / 2 ) + sizeOneThirdCols)))
    echo $title

    i=3
    while [ $i -le 10 ] ; do

        tput cup $i $(( (sizeOneThirdCols ) + 1 ))
        echo "|"
        i=$((i + 1))

    done


    # THIRD SEPARATOR SECOND BLOCK

    title="PROCESS BY NETWORK"
    tput cup 4 $(( ((((sizeOneThirdCols) - ${#title}) / 2 ) + (sizeOneThirdCols * 2))))
    echo $title

    i=3
    while [ $i -le 10 ] ; do

        tput cup $i $(( (sizeOneThirdCols * 2) + 1 ))
        echo "|"
        i=$((i + 1))

    done


    # RIGHT SECOND BLOCK SEPARATOR

    i=3
    while [ $i -le 10 ] ; do

        tput cup $i $cols
        echo "|"
        i=$((i + 1))

    done

    # LEFT THIRD BLOCK SEPARATOR

    title="CPU"
    tput cup 13 $(( ((sizeOneThirdCols - ${#title}) / 2) ))
    echo $title 

    i=12
    while [ $i -le 20 ] ; do

        tput cup $i 0
        echo "|"
        i=$((i + 1))

    done

    # SECOND SEPARATOR THIRD BLOCK

    title="RAM"
    tput cup 13 $(( (((sizeOneThirdCols - ${#title}) / 2 ) + sizeOneThirdCols)))
    echo $title

    i=12
    while [ $i -le 20 ] ; do

        tput cup $i $(( (sizeOneThirdCols ) + 1 ))
        echo "|"
        i=$((i + 1))

    done

    # THIRD SEPARATOR THIRD BLOCK

    title="DISK"
    tput cup 13 $(( ((((sizeOneThirdCols) - ${#title}) / 2 ) + (sizeOneThirdCols * 2))))
    echo $title

    i=12
    while [ $i -le 20 ] ; do

        tput cup $i $(( (sizeOneThirdCols * 2) + 1 ))
        echo "|"
        i=$((i + 1))

    done


    # RIGHT THIRD BLOCK SEPARATOR
    i=12
    while [ $i -le 20 ] ; do

        tput cup $i $cols
        echo "|"
        i=$((i + 1))

    done

    # LEFT FOURTH BLOCK SEPARATOR
   
    title="PROCESS RUNNING"
    tput cup 23 $(( (cols - ${#title}) / 2 ))
    echo $title

    i=22
    while [ $i -le 30 ] ; do

        tput cup $i 0
        echo "|"
        i=$((i + 1))

    done

     # RIGHT FOURTH BLOCK SEPARATOR
   
    i=22
    while [ $i -le 30 ] ; do

        tput cup $i $cols
        echo "|"
        i=$((i + 1))

    done

    # INFO TO QUIT THE SCRIPT
    tput cup 33 5
    echo "CTRL+C to quit ..."
}

function QuitScript {
    clear
    echo -e "You have quit the script ..."
    tput cnorm
    exit 0
}

function MainScript {

    trap QuitScript SIGINT SIGTERM
    DisplayStructure
    StaticInfoSystem

    while true ; do
        DateIdleBox
        NetworkInformation
        NetworkByProcess
        CpuInformation
        RamInformation
        DiskInformation
        sleep 1
    done
}


MainScript "$@"
