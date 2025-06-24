**End-user document**

This document serves as a guide for the end-user to understand and use the monitoring tool. The tools enables monitoring of the following:

1. CPU Information
2. Ram Information
3. Disk Information
4. Network Information 
5. User/system logs

There are Scripts each for General System information, CPU, Ram, Disk and Network. They can be launched with the launcher file.

Tools used for window management:

Tmux: tmux is a terminal multiplexer. It allows easy switching between programs in one terminal, detach them (they keep running in the background) or reattach them to a different terminal.
Multitail: Allows viewing of multiple files/windows on the console

**Installation needs:**
Tmux and Multitail need to be installed on the system beforehand.

**User Guide:**
Use sudo -E ./launcher.sh

This command will launch and manage 2 different terminal windows on the screen, one with the real-time monitoring split-screen metrics and another with logs. The logs are also saved to a separate folder.

**All required files/scripts**

1. System.sh

Displays information about the system like OS, Kernel.

2. CPU.sh

Displays top 10 most CPU consuming programs with the command that formats the output into a human-readable table with aligned columns:

ps -eo pid,user,comm,%cpu,etime --no-headers | sort -k4 -nr | head -n 10 | \
    awk 'BEGIN {
        printf "%-6s %-10s %-20s %-10s %-10s\n", "PID", "USER", "COMMAND", "%CPU", "ELAPSED"
    }
    {
        printf "%-6s %-10s %-20s %-10s %-10s\n", $1, $2, $3, $4"%", $5
    }'

3. Ram.sh

Displays top 10 most Ram consuming programs with the command that sorts the programs from most to least consuming:

 ps -eo pid,user,comm,%mem,etime --no-headers | sort -k4 -nr | head -n 10 | \
    awk 'BEGIN {
        printf "%-6s %-10s %-20s %-10s %-10s\n", "PID", "USER", "COMMAND", "%MEM", "ELAPSED"
    }
    {
        printf "%-6s %-10s %-20s %-10s %-10s\n", $1, $2, $3, $4"%", $5
    }'

4. Disk.sh

The following command allows disk monitoring with real-time overall disk I/O stats and lists the top processes consuming disk resources, sorted by usage.

    iostat -d 1 1
    echo "=== DISK I/O USAGE BY PROCESS ==="
    pidstat -d 1 1 | awk '
    /^[ 0-9]/ && NF >= 9 && ($4+$5)>0 {
        printf "%-6s %-20s %10s\n", $3, $9, ($4+$5)" KB/s"
    }' | sort -k3 -nr | awk '
    BEGIN { printf "\n%-6s %-20s %-10s\n", "PID", "COMMAND", "DISK I/O" }
    { print }
    '

5. Network.sh

//Julien//

6. Launcher.sh

This will first validate sudo permission. This once sudo is checked the launcher will start the tmux_launcher.sh and multitail_logs.sh


7. Multitails_logs.sh

It live-monitors and logs SSH, authentication, network connections, system errors, firewall activity, and service/process events in parallel using multitail in the following command:
multitail -s 2 \
    -l "journalctl -f -u ssh -u sshd | tee -a $dir_name/ssh.logs" \
    -l "journalctl -f --no-pager | grep -i -E '(authentication|login|session|pam|accepted|failed|invalid|sudo|su|privilege|password|security)' | tee -a $dir_name/auth.logs" \
    -rc 1 -l "ss -tupn | tee -a $dir_name/conn.logs" \
    -l "journalctl -f -p err --no-pager | tee -a $dir_name/err_sys.logs" \
    -l "journalctl -f --no-pager | grep -i -E '(iptables|ufw|firewall|DROP|REJECT|BLOCK)' | tee -a $dir_name/firewall.logs" \
    -l "journalctl -f --no-pager | grep -E -i '(started|stopped|failed|reloaded)' | tee -a $dir_name/services_processes.logs"

8. Tmux.sh

Window management
