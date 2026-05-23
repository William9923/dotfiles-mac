#!/bin/sh
# Open (or attach to) a per-directory background tmux session in a popup.
#
# Usage:
#   popup-session.sh <prefix> <cwd> <command...>
#
# Example (from a tmux binding):
#   run-shell "~/.config/tmux/scripts/popup-session.sh opencode '#{pane_current_path}' opencode"
#
# Behavior:
#   - Hashes <cwd> to derive a stable session name: "<prefix>-<hash>"
#   - Creates the session detached (cwd=<cwd>, running <command...>) if it
#     doesn't already exist.
#   - Opens a tmux popup that attaches to that session.
#
# Pair this with a toggle-aware binding so pressing the key while attached
# to the popup detaches and closes it. See utility.conf.

set -eu

prefix=$1
cwd=$2
shift 2

# md5sum on Linux, md5 on macOS; fall back gracefully.
hash=$(printf '%s' "$cwd" | { md5sum 2>/dev/null || md5; } | cut -c1-8)
session="${prefix}-${hash}"

tmux has-session -t "$session" 2>/dev/null || \
    tmux new-session -d -s "$session" -c "$cwd" "$@"

tmux display-popup -w 95% -h 95% -E "tmux attach-session -t $session"
