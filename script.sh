#!/bin/bash

# Check if the reverse tunnel process is already running locally
if pgrep -f "ssh -N -R 2200:localhost:22 steamuser@jariel.ddns.net" > /dev/null; then
  echo "Reverse tunnel already running."
  exit 0
fi

# Connect to jariel.ddns.net and run a test command in tmux
ssh -p 1995 steamuser@jariel.ddns.net bash <<'EOF'
if ! tmux has-session -t ssh-tunnel 2>/dev/null; then
  tmux new-session -d -s ssh-tunnel
fi

# For debugging: create a timestamped file in /tmp
tmux send-keys -t ssh-tunnel "date > /tmp/connected_from_nat_\$(date +%s)" C-m

# Start the reverse SSH tunnel after the test file is created
tmux send-keys -t ssh-tunnel "pkill -f 'ssh -N -R 2200'" C-m
tmux send-keys -t ssh-tunnel "ssh -N -R 2200:localhost:22 root@localhost -p 22" C-m
EOF
