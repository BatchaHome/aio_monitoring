#!/usr/bin/env bash

SESSION="aio_monitoring"

# Kill any existing session with the same name
if tmux has-session -t $SESSION 2>/dev/null; then
  tmux kill-session -t $SESSION
fi

# Start a new tmux session in detached mode
tmux new-session -d -s $SESSION -n main

# Split layout into 5 panes:
# Start with one pane (pane 0)
# Split horizontally to get pane 1
tmux split-window -h -t $SESSION:main  # now panes 0 and 1 side by side

# Split pane 0 vertically to get pane 2 below pane 0
tmux split-window -v -t $SESSION:main.0

# Split pane 1 vertically to get pane 3 below pane 1
tmux split-window -v -t $SESSION:main.1

# Now split pane 3 vertically again to get pane 4 below pane 3
tmux split-window -v -t $SESSION:main.3

# Now assign commands to each pane:

tmux select-pane -t 0
tmux send-keys 'watch -t -n 1 monitoring_script/basic_information.sh' C-m

# Pane 1: CPU & memory usage
tmux select-pane -t 1
tmux send-keys "watch -t -n 1 ./monitoring_script/cpu_information.sh" C-m

# Pane 2: disk usage
tmux select-pane -t 2
tmux send-keys "watch -t -n 1 ./monitoring_script/disk_infos.sh" C-m

# Pane 3: top (process viewer)
tmux select-pane -t 3
tmux send-keys "watch -t -n 1 ./monitoring_script/ram_infos.sh" C-m

# Pane 4: new pane - e.g. logs tail or something else
tmux select-pane -t 4
tmux send-keys "watch -t -n 1 ./monitoring_script/network_information.sh" C-m

# Optional: adjust layout to tiled for better distribution
tmux select-layout tiled
tmux set mouse on


# Attach to the session
tmux attach -t $SESSION
