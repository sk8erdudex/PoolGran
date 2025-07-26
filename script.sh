#!/bin/bash

REMOTE_HOST="jariel.ddns.net"
REMOTE_PORT=1995
SSH_USER="steamuser"
SESSION_NAME="ssh-tunnel"
REVERSE_PORT=2200
LOCAL_SSH_PORT=22

# Check locally if the reverse SSH process is already running
if pgrep -f "ssh -N -R $REVERSE_PORT:localhost:$LOCAL_SSH_PORT steamuser@$REMOTE_HOST" > /dev/null; then
  echo "Reverse tunnel already running."
  exit 0
fi

# Start or reuse a tmux session on the remote host and run the tunnel in it
ssh -p "$REMOTE_PORT" "$SSH_USER@$REMOTE_HOST" bash <<EOF
if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
  tmux new-session -d -s $SESSION_NAME
fi

# Kill any stale tunnel in the session
tmux send-keys -t $SESSION_NAME "pkill -f 'ssh -N -R $REVERSE_PORT'" C-m
# Start fresh tunnel back to this NATed server
tmux send-keys -t $SESSION_NAME "ssh -N -R $REVERSE_PORT:localhost:$LOCAL_SSH_PORT root@localhost -p $LOCAL_SSH_PORT" C-m
EOF
