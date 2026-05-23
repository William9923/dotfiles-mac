#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP_ROOT="${DOTFILES_BACKUP_ROOT:-$HOME/.dotfiles-backups}"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)-setup"
PACKAGES=(zsh git homebrew bin config claude vim ideavim)

log() {
  printf '[setup] %s\n' "$*"
}

die() {
  printf '[setup] error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<EOF
Usage: ${0##*/} [minimal|full]

Profiles:
  minimal  portable shell, Git, editor, and dotfiles baseline (default)
  full     curated personal/dev setup without company-private packages
EOF
}

is_macos() {
  [ "$(uname -s)" = "Darwin" ]
}

brewfile_for_profile() {
  case "$1" in
    minimal) printf '%s\n' "$DOTFILES_DIR/homebrew/.Brewfile.minimal" ;;
    full) printf '%s\n' "$DOTFILES_DIR/homebrew/.Brewfile.full" ;;
    *) die "unknown profile '$1'; expected minimal or full" ;;
  esac
}

ensure_xcode_cli_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed"
    return
  fi

  log "installing Xcode Command Line Tools"
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  local label
  label="$(
    softwareupdate -l 2>/dev/null |
      awk -F'* Label: ' '/\* Label: Command Line Tools/ { print $2 }' |
      tail -n 1
  )"

  if [ -n "$label" ]; then
    sudo softwareupdate -i "$label" --verbose
  else
    xcode-select --install || true
    die "Xcode Command Line Tools installer was started; rerun setup.sh after it completes"
  fi
}

load_homebrew_env() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_homebrew() {
  load_homebrew_env
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed"
    return
  fi

  log "installing Homebrew"
  local installer
  installer="$(mktemp)"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
  NONINTERACTIVE=1 /bin/bash "$installer"
  rm -f "$installer"
  load_homebrew_env
  command -v brew >/dev/null 2>&1 || die "Homebrew installation did not place brew on PATH"
}

ensure_brew_tools() {
  local formula
  for formula in git stow mas; do
    if brew list --formula "$formula" >/dev/null 2>&1; then
      log "$formula already installed"
    else
      log "installing $formula"
      brew install "$formula"
    fi
  done
}

same_file() {
  [ -e "$1" ] && [ -e "$2" ] &&
    [ "$(stat -L -f '%d:%i' "$1" 2>/dev/null)" = "$(stat -L -f '%d:%i' "$2" 2>/dev/null)" ]
}

should_skip_source() {
  case "$1" in
    */.DS_Store|*/.gitignore|*/.env|*/.env.*|*.log|*.tmp|*.bak|*.bak.*) return 0 ;;
    config/.config/Cursor/*) return 0 ;;
    *) return 1 ;;
  esac
}

prepare_stow_conflicts() {
  local package src rel target conflict_dir
  conflict_dir="$BACKUP_DIR/conflicts"
  mkdir -p "$conflict_dir"

  for package in "${PACKAGES[@]}"; do
    [ -d "$DOTFILES_DIR/$package" ] || continue
    while IFS= read -r src; do
      rel="${src#"$DOTFILES_DIR/$package/"}"
      should_skip_source "$package/$rel" && continue
      target="$HOME/$rel"

      if same_file "$src" "$target"; then
        continue
      fi

      if [ -L "$target" ]; then
        log "removing stale symlink $target"
        rm "$target"
      elif [ -e "$target" ]; then
        log "backing up conflicting $target"
        mkdir -p "$conflict_dir/$(dirname "$rel")"
        mv "$target" "$conflict_dir/$rel"
      fi
    done < <(find "$DOTFILES_DIR/$package" \( -type f -o -type l \) -print)
  done
}

stow_packages() {
  log "stowing packages into $HOME"
  prepare_stow_conflicts
  stow --dir="$DOTFILES_DIR" --target="$HOME" --no-folding "${PACKAGES[@]}"
}

link_macos_app_configs() {
  local cursor_src cursor_dst file
  cursor_src="$DOTFILES_DIR/config/.config/Cursor/User"
  cursor_dst="$HOME/Library/Application Support/Cursor/User"

  [ -d "$cursor_src" ] || return
  mkdir -p "$cursor_dst"

  for file in settings.json keybindings.json; do
    [ -e "$cursor_src/$file" ] || continue
    if same_file "$cursor_src/$file" "$cursor_dst/$file"; then
      log "Cursor $file already linked"
    elif [ -L "$cursor_dst/$file" ]; then
      rm "$cursor_dst/$file"
      ln -s "$cursor_src/$file" "$cursor_dst/$file"
      log "relinked Cursor $file"
    elif [ -e "$cursor_dst/$file" ]; then
      mkdir -p "$BACKUP_DIR/Cursor"
      mv "$cursor_dst/$file" "$BACKUP_DIR/Cursor/$file"
      ln -s "$cursor_src/$file" "$cursor_dst/$file"
      log "linked Cursor $file after backup"
    else
      ln -s "$cursor_src/$file" "$cursor_dst/$file"
      log "linked Cursor $file"
    fi
  done
}

install_bundle() {
  local profile brewfile
  profile="$1"
  brewfile="$(brewfile_for_profile "$profile")"

  if [ -e "$brewfile" ]; then
    log "installing Homebrew bundle ($profile)"
    GIT_CONFIG_GLOBAL=/dev/null brew bundle install --file="$brewfile" --no-lock --no-upgrade
  else
    log "skipping brew bundle because $brewfile is missing"
  fi
}

main() {
  local profile

  if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
  fi

  [ "$#" -le 1 ] || die "expected at most one profile argument"
  profile="${1:-${DOTFILES_PROFILE:-minimal}}"
  brewfile_for_profile "$profile" >/dev/null

  is_macos || die "setup.sh currently supports macOS only"
  mkdir -p "$BACKUP_DIR"

  ensure_xcode_cli_tools
  ensure_homebrew
  ensure_brew_tools
  stow_packages
  link_macos_app_configs
  install_bundle "$profile"

  log "done"
  log "profile: $profile"
  log "conflict backups, if any: $BACKUP_DIR"
}

main "$@"
