#!/usr/bin/env bash
# Apply macOS system preferences via `defaults write`.
# Safe to re-run; only changes keys listed below.
#
# Usage:
#   ./macos/defaults.sh           # apply
#   ./macos/defaults.sh --dry-run # print commands only
#
# After bootstrap on a new Mac:
#   cd ~/dotfiles && make macos-defaults

set -euo pipefail

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'macos/defaults.sh supports macOS only.\n' >&2
  exit 1
fi

log() {
  printf '[macos-defaults] %s\n' "$*"
}

write_default() {
  local domain="$1" key="$2" type="$3" value="$4"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'defaults write %q %q -%s %q\n' "$domain" "$key" "$type" "$value"
    return
  fi
  defaults write "$domain" "$key" "-$type" "$value"
}

restart_apps() {
  local app
  for app in Dock Finder SystemUIServer; do
    if [[ "$DRY_RUN" -eq 1 ]]; then
      log "would restart $app"
    else
      killall "$app" 2>/dev/null || true
    fi
  done
}

log "applying system defaults (dry_run=$DRY_RUN)"

# --- Keyboard (matches this repo's primary Mac: fast repeat, no press-and-hold delay) ---
write_default NSGlobalDomain KeyRepeat int 2
write_default NSGlobalDomain InitialKeyRepeat int 25
write_default NSGlobalDomain ApplePressAndHoldEnabled bool false
write_default NSGlobalDomain AppleKeyboardUIMode int 3

# --- Dock ---
write_default com.apple.dock autohide bool true
write_default com.apple.dock orientation string left
write_default com.apple.dock no-bouncing bool true
write_default com.apple.dock autohide-delay float 1000
# Do not rearrange Spaces based on most recent use (helps window managers)
write_default com.apple.dock mru-spaces bool false

# --- Finder ---
write_default com.apple.finder ShowPathbar bool true
write_default com.apple.finder ShowStatusBar bool true
write_default com.apple.finder _FXShowPosixPathInTitle bool true
# Show all files in Finder (disable if you prefer hidden files hidden)
write_default com.apple.finder AppleShowAllFiles bool true
# Avoid .DS_Store on network/USB volumes
write_default com.apple.desktopservices DSDontWriteNetworkStores bool true
write_default com.apple.desktopservices DSDontWriteUSBStores bool true

# --- Screenshots ---
SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
if [[ "$DRY_RUN" -eq 0 ]]; then
  mkdir -p "$SCREENSHOT_DIR"
fi
write_default com.apple.screencapture location string "$SCREENSHOT_DIR"
write_default com.apple.screencapture type string png

# --- Menu bar clock (24h with seconds) ---
write_default com.apple.menuextra.clock DateFormat string "HH:mm:ss"
write_default com.apple.menuextra.clock FlashDateSeparators bool false
write_default com.apple.menuextra.clock ShowSeconds bool true

# --- Trackpad: tap to click (laptop) ---
write_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking bool true
write_default com.apple.AppleMultitouchTrackpad Clicking bool true

log "restarting UI apps to pick up changes"
restart_apps

log "done"
if [[ "$DRY_RUN" -eq 0 ]]; then
  log "screenshots save to: $SCREENSHOT_DIR"
fi
