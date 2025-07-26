#!/bin/bash

# Check locally if the reverse SSH tunnel is already running
if pgrep -f "ssh -N -R 2200:localhost:22 steamuser@jariel.ddns.net" > /dev/null; then
  echo "Reverse tunnel already running."
  exit 0
fi

# Connect to jariel.ddns.net and start or reuse a tmux session with the reverse tunnel
ssh -p 1995 steamuser@jariel.ddns.net bash <<'EOF'
if ! tmux has-session -t ssh-tunnel 2>/dev/null; then
  tmux new-session -d -s ssh-tunnel
fi

tmux send-keys -t ssh-tunnel "pkill -f 'ssh -N -R 2200'" C-m
tmux send-keys -t ssh-tunnel "ssh -N -R 2200:localhost:22 root@localhost -p 22" C-m
EOF
