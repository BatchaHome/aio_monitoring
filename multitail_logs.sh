#!/bin/bash

dir_name="logs_$(date '+%Y-%m-%d_%H-%M-%S')"

mkdir $dir_name ; chmod 777 $dir_name
touch "$dir_name/ssh.logs" ; chmod 777 "$dir_name/ssh.logs"
touch "$dir_name/auth.logs" ; chmod 777 "$dir_name/auth.logs"
touch "$dir_name/conn.logs" ; chmod 777 "$dir_name/conn.logs"
touch "$dir_name/err_sys.logs" ; chmod 777 "$dir_name/err_sys.logs"
touch "$dir_name/firewall.logs" ; chmod 777 "$dir_name/firewall.logs"
touch "$dir_name/services_processes.logs" ; chmod 777 "$dir_name/services_processes.logs"
touch "$dir_name/last_users.logs"; chmod 777 "$dir_name/last_users.logs"

echo "LAST USERS CONNECTED: " >>  $dir_name/last_users.logs
last -F > $dir_name/last_users.logs

for user in $(last -F | awk '{print $1}' | sort -u); do
    echo "=== History for user: $user ===" >> $dir_name/last_users.logs
    home_dir="/home/$user"
    
    # For root user, home might be /root
    if [ "$user" = "root" ]; then
        home_dir="/root"
    fi
    
    # Use glob to match all history files starting with a dot and ending with _history
    shopt -s nullglob dotglob  # Enable globbing of dotfiles and no-match to empty list
    history_files=("$home_dir"/.*_history)
    
    if [ ${#history_files[@]} -gt 0 ]; then
        for history_file in "${history_files[@]}"; do
            echo "== Contents of $history_file ==" >> $dir_name/last_users.logs
            cat "$history_file" >> $dir_name/last_users.logs
            echo >> $dir_name/last_users.logs
        done
    else
        echo "No history files found for $user in $home_dir" >> $dir_name/last_users.logs
    fi
done

multitail \
    -l "journalctl -f --no-pager -u ssh -u sshd | tee -a $dir_name/ssh.logs" \
    -l "journalctl -f --no-pager | grep -i -E '(authentication|login|session|pam|accepted|failed|invalid|sudo|su|privilege|password|security)' | tee -a $dir_name/auth.logs" \
    -rc 1 -l "ss -tupn | tee -a $dir_name/conn.logs" \
    -l "journalctl -f -p err --no-pager | tee -a $dir_name/err_sys.logs" \
    -l "journalctl -f --no-pager | grep -i -E '(iptables|ufw|firewall|DROP|REJECT|BLOCK)' | tee -a $dir_name/firewall.logs" \
    -l "journalctl -f --no-pager | grep -E -i '(started|stopped|failed|reloaded)' | tee -a $dir_name/services_processes.logs" \
    
    # Display SSH/SSHD logs
    # Display AUTHENTICATION/SECURITY logs
    # Display CONNECTION IN REAL TIME logs
    # Display ERROR SYSTEM logs
    # Display FIREWALL logs
    # Display SERVICES/PROCESSES logs
