#!/bin/sh
# Open (or attach to) a global background tmux session in a popup.
#
# Usage:
#   popup-global-session.sh <session-name> <command...>
#
# Example (from a tmux binding):
#   run-shell "~/.config/tmux/scripts/popup-global-session.sh k9s k9s"
#
# Behavior:
#   - Uses <session-name> directly, without current-directory scoping.
#   - Creates the session detached, running <command...>, if it doesn't exist.
#   - Opens a tmux popup that attaches to that session.

set -eu

if [ "$#" -lt 2 ]; then
    printf 'Usage: %s <session-name> <command...>\n' "$0" >&2
    exit 2
fi

session=$1
shift
target="=$session"
tmux_bin=$(command -v tmux)

tmux has-session -t "$target" 2>/dev/null || \
    tmux new-session -d -s "$session" "$@"

tmux display-popup -w 95% -h 95% -E "exec \"$tmux_bin\" attach-session -t \"$target\""
