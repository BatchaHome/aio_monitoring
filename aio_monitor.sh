#!/bin/bash

function WelcomeMessage {
    echo $'
			   / \  |_ _/ _ \  |  \/  |/ _ \| \ | |_ _|_   _/ _ \|  _ \|_ _| \ | |/ ___|
			  / _ \  | | | | | | |\/| | | | |  \| || |  | || | | | |_) || ||  \| | |  _ 
			 / ___ \ | | |_| | | |  | | |_| | |\  || |  | || |_| |  _ < | || |\  | |_| |
			/_/   \_\___\___/  |_|  |_|\___/|_| \_|___| |_| \___/|_| \_\___|_| \_|\____|
	   	\n'

    echo $'WELCOME TO AIO MONITORING\n'

    echo $'Here is a resume of your system:\n'
    DisplaySystemResumeInfo
    echo $'\nFor further informations please enter a command associate to a services'
    echo $'If you need help, please enter the command "0" to get all command available\n'
}

function DisplaySystemResumeInfo {
    printf "\tHOSTNAME: $(hostname)\n"
    printf "\tUSERNAME: $(echo $USER)\n"
    printf "\tOPERATING SYSTEM: $()\n"
    printf "\tCPU USAGE/TEMP: $()\n"
    printf "\tRAM USAGE: $()\n"
    printf "\tDISK USAGE: $()\n"
}

function Menu {
    while true ; do
        echo "[0] HELP"
        echo "[1] CPU"
        echo "[2] RAM"
        echo "[3] PROCESS"
        echo $'[4] QUIT\n'

        read -p "Enter a command : " action

        case $action in
            1)
                echo "Entering cpu details ..."
                break
            ;;
            2)
                echo "Entering ram details ..."
                break
            ;;
            3)
                echo "Entering process details ..."
                break
            ;;
            4)
                echo "Exiting ..."
                break
            ;;
            *)
                echo "Wrong command ..."
        esac
    done
}

function MainScript {
    clear
    WelcomeMessage
    Menu
}

MainScript