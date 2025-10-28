# AIO Monitoring

> A comprehensive, real-time system monitoring tool that provides unified visibility into CPU, RAM, disk, network performance, and system logs.

## 📖 Overview

**AIO Monitoring** is an all-in-one system monitoring solution designed to give system administrators and power users complete visibility into their system's health and resource utilization. It combines multiple monitoring capabilities into a single, easy-to-use interface with real-time metrics and persistent log archival.

## ✨ Features

### Core Monitoring Capabilities

- 📊 **CPU Monitoring** - Display top 10 CPU-consuming processes with PID, user, command, CPU usage, and elapsed time
- 🧠 **RAM Monitoring** - Track top 10 memory-consuming processes with detailed resource breakdown
- 💾 **Disk I/O Monitoring** - Real-time disk I/O statistics and process-level disk usage tracking
- 🌐 **Network Monitoring** - Network connection statistics and socket information
- 📋 **System Information** - Operating system, kernel, and hardware details
- 🔐 **Comprehensive Logging** - Multi-stream log monitoring including:
  - SSH connection logs
  - Authentication and security events
  - Network connections
  - System errors
  - Firewall activity
  - Service and process state changes

### User Interface

- **Tmux-based windowing** - Terminal multiplexer for easy window management and detachable sessions
- **Multitail integration** - View multiple log streams in parallel with color-coded output
- **Split-screen monitoring** - Real-time metrics dashboard in one terminal, logs in another
- **Automatic terminal detection** - Support for GNOME Terminal, XFCE Terminal, Konsole, and more

## 📋 Requirements

### System Requirements

- Linux system with systemd (for journalctl)
- Sudo/root privileges for certain operations
- Bash shell

### Dependencies

| Dependency | Purpose | Installation |
|-----------|---------|--------------|
| **multitail** | Multi-stream log monitoring | `sudo apt install multitail` |
| **tmux** | Terminal multiplexing | `sudo apt install tmux` |
| **sysstat** | CPU and I/O statistics tools (iostat, pidstat) | `sudo apt install sysstat` |
| **iproute2** | Network socket statistics (ss) | `sudo apt install iproute2` |
| **lsof** | List open files | `sudo apt install lsof` |
| **util-linux** | System utilities (last command) | `sudo apt install util-linux` |

#### Quick Install (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install multitail tmux sysstat iproute2 lsof util-linux
```

## 🚀 Quick Start

### Basic Usage

```bash
sudo -E ./launcher.sh
```

This command will:
1. Validate sudo privileges
2. Check for all required dependencies
3. Launch two terminal windows:
   - **Window 1**: Real-time monitoring dashboard (CPU, RAM, Disk, Network, System Info)
   - **Window 2**: Live log streams with automatic archival

### Advanced Usage

For standalone monitoring of specific metrics, you can run individual scripts:

```bash
# CPU monitoring only
./monitoring_script/cpu_information.sh

# RAM monitoring only
./monitoring_script/ram_infos.sh

# Disk I/O monitoring only
./monitoring_script/disk_infos.sh

# Network monitoring only
./monitoring_script/network_information.sh

# System information only
./monitoring_script/basic_information.sh
```

## 📁 Project Structure

```
aio_monitoring/
├── README.md                          # This file
├── End-user Documentation.md          # Detailed end-user guide
├── launcher.sh                        # Main entry point (runs dependency checks)
├── tmux_launcher.sh                   # Tmux window manager for metrics
├── multitail_logs.sh                  # Log streaming and archival
├── monitoring_script/
│   ├── basic_information.sh           # System OS/kernel information
│   ├── cpu_information.sh             # Top 10 CPU consumers
│   ├── ram_infos.sh                   # Top 10 RAM consumers
│   ├── disk_infos.sh                  # Disk I/O and usage
│   └── network_information.sh         # Network statistics
└── [log archives]/                    # Automatically created log directory
```

## 📊 Monitoring Details

### CPU Monitoring

Displays the top 10 processes consuming the most CPU resources with:
- **PID** - Process ID
- **USER** - Process owner
- **COMMAND** - Command name
- **%CPU** - CPU usage percentage
- **ELAPSED** - Time running

### RAM Monitoring

Shows the top 10 processes consuming the most memory with:
- **PID** - Process ID
- **USER** - Process owner
- **COMMAND** - Command name
- **%MEM** - Memory usage percentage
- **ELAPSED** - Time running

### Disk I/O Monitoring

Provides:
- Overall disk I/O statistics
- Top processes by disk I/O (KB/s)
- Real-time I/O performance metrics

### Network Monitoring

Tracks:
- Active network connections
- Socket statistics (TCP/UDP)
- Connection states and ports

### System Information

Displays:
- Operating System details
- Kernel version
- Hardware information

### Log Archival

Automatically captures and saves to dedicated log files:
- **ssh.logs** - SSH connection activity
- **auth.logs** - Authentication and security events
- **conn.logs** - Network connections
- **err_sys.logs** - System errors
- **firewall.logs** - Firewall activity (iptables, ufw)
- **services_processes.logs** - Service and process state changes

All logs are timestamped and persisted for audit and analysis purposes.

## 🛠️ Architecture

### Launcher (launcher.sh)

The main entry point that:
1. Validates sudo privileges
2. Checks for all required commands with user-friendly error messages
3. Detects available terminal emulators (GNOME, XFCE, Konsole, etc.)
4. Launches the monitoring and logging scripts in separate terminals

### Tmux Launcher (tmux_launcher.sh)

Manages the monitoring window:
- Creates a tmux session with multiple panes
- Runs each monitoring script in a split-pane layout
- Allows easy navigation and detachment

### Multitail Logs (multitail_logs.sh)

Handles log streaming and archival:
- Monitors system journal in real-time
- Filters logs by category (SSH, auth, network, etc.)
- Displays multiple streams with color coding
- Writes all data to persistent log files

## 💡 Use Cases

- **System Administration** - Monitor server health and resource usage
- **Performance Troubleshooting** - Identify resource bottlenecks and heavy processes
- **Security Monitoring** - Track authentication attempts and system access
- **Audit Compliance** - Maintain comprehensive log archives
- **Development** - Debug application resource consumption
- **System Maintenance** - Monitor system during maintenance windows

## 🔒 Security Considerations

- The script requires **sudo privileges** for accessing system-level metrics and logs
- Uses `-E` flag to preserve environment variables: `sudo -E ./launcher.sh`
- All logs are stored locally; consider encryption for sensitive environments
- Run on systems where you have administrative privileges

## 📝 Logging

By default, logs are saved to a timestamped directory created by the script. Each log category is stored separately for easy filtering and analysis.

Example log locations:
```
./logs_YYYYMMDD_HHMMSS/
├── ssh.logs
├── auth.logs
├── conn.logs
├── err_sys.logs
├── firewall.logs
└── services_processes.logs
```

## 🐛 Troubleshooting

### Missing Dependencies

If you see an error about missing commands, the launcher will provide installation instructions for your distribution (Ubuntu/Debian, CentOS/RHEL, Fedora).

### Terminal Not Found

If your terminal emulator is not supported, you can add it to `launcher.sh` or run the scripts manually in your terminal.

### Permission Denied

Ensure you're running with sudo and using the `-E` flag:
```bash
sudo -E ./launcher.sh
```

### Scripts Not Executable

Make scripts executable with:
```bash
chmod +x *.sh monitoring_script/*.sh
```

## 🔄 How It Works

1. **Initialization**: `launcher.sh` checks for dependencies and validates permissions
2. **Monitoring**: `tmux_launcher.sh` creates a split-screen interface with multiple monitoring panes
3. **Logging**: `multitail_logs.sh` streams and archives logs in parallel
4. **Display**: Both windows run simultaneously, providing real-time insight into system state

## �️ Roadmap & Future Enhancements

Planned features for upcoming releases:
- 🌡️ **Temperature Monitoring** - Add alerts for temperature thresholds
- 🛡️ **IDS Integration** - Monitoring logs using Intrusion Detection Systems
- 📧 **Email Alerts** - Notify administrator by email when alerts are triggered
- 📈 **Historical Analytics** - Long-term trend analysis and reporting

## 📄 License

This project is maintained by **BatchaHome**.

---

**Last Updated:** October 28, 2025  
