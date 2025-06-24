#!/bin/bash

dir_name="logs_$(date '+%Y-%m-%d_%H-%M-%S')"

mkdir $dir_name ; chmod 777 $dir_name
touch "$dir_name/ssh.logs" ; chmod 777 "$dir_name/ssh.logs"
touch "$dir_name/auth.logs" ; chmod 777 "$dir_name/auth.logs"
touch "$dir_name/conn.logs" ; chmod 777 "$dir_name/conn.logs"
touch "$dir_name/err_sys.logs" ; chmod 777 "$dir_name/err_sys.logs"
touch "$dir_name/firewall.logs" ; chmod 777 "$dir_name/firewall.logs"
touch "$dir_name/services_processes.logs" ; chmod 777 "$dir_name/services_processes.logs"


multitail -s 2 \
    -l "journalctl -f -u ssh -u sshd | tee -a $dir_name/ssh.logs" \
    -l "journalctl -f --no-pager | grep -i -E '(authentication|login|session|pam|accepted|failed|invalid|sudo|su|privilege|password|security)' | tee -a $dir_name/auth.logs" \
    -rc 1 -l "ss -tupn | tee -a $dir_name/conn.logs" \
    -l "journalctl -f -p err --no-pager | tee -a $dir_name/err_sys.logs" \
    -l "journalctl -f --no-pager | grep -i -E '(iptables|ufw|firewall|DROP|REJECT|BLOCK)' | tee -a $dir_name/firewall.logs" \
    -l "journalctl -f --no-pager | grep -E -i '(started|stopped|failed|reloaded)' | tee -a $dir_name/services_processes.logs"

    # Display SSH/SSHD logs
    # Display AUTHENTICATION/SECURITY logs
    # Display CONNECTION IN REAL TIME logs
    # Display ERROR SYSTEM logs
    # Display FIREWALL logs
    # Display SERVICES/PROCESSES logs