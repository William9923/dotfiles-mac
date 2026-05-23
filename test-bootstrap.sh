#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TART_IMAGE="${TART_IMAGE:-ghcr.io/cirruslabs/macos-sequoia-vanilla:latest}"
VM_NAME="${VM_NAME:-dotfiles-bootstrap-$(date +%Y%m%d-%H%M%S)}"
VM_USER="${VM_USER:-admin}"
VM_PASSWORD="${VM_PASSWORD:-admin}"
SSH_OPTS=(-A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10)
RUN_LOG="${TMPDIR:-/tmp}/${VM_NAME}.log"
SSH_MODE=""

log() {
  printf '[test-bootstrap] %s\n' "$*"
}

die() {
  printf '[test-bootstrap] error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<EOF
Usage: ${0##*/} [minimal|full]

Profiles:
  minimal  test the portable baseline (default)
  full     test the full personal/dev profile
EOF
}

profile_from_args() {
  case "${1:-${TEST_BOOTSTRAP_PROFILE:-minimal}}" in
    minimal|full) printf '%s\n' "${1:-${TEST_BOOTSTRAP_PROFILE:-minimal}}" ;;
    *) die "unknown profile '${1:-}'; expected minimal or full" ;;
  esac
}

cleanup() {
  set +e
  if command -v tart >/dev/null 2>&1; then
    tart stop --timeout 30 "$VM_NAME" >/dev/null 2>&1
    tart delete "$VM_NAME" >/dev/null 2>&1
  fi
}

require() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

ssh_plain() {
  ssh "${SSH_OPTS[@]}" "$VM_USER@$VM_IP" "$@"
}

ssh_expect() {
  local command="$1"
  expect <<EOF_EXPECT
set timeout -1
spawn ssh ${SSH_OPTS[*]} $VM_USER@$VM_IP $command
expect {
  "*assword:" { send "$VM_PASSWORD\r"; exp_continue }
  eof
}
catch wait result
exit [lindex \$result 3]
EOF_EXPECT
}

scp_expect() {
  local src="$1"
  local dst="$2"
  expect <<EOF_EXPECT
set timeout -1
spawn scp -r ${SSH_OPTS[*]} "$src" "$VM_USER@$VM_IP:$dst"
expect {
  "*assword:" { send "$VM_PASSWORD\r"; exp_continue }
  eof
}
catch wait result
exit [lindex \$result 3]
EOF_EXPECT
}

remote() {
  case "$SSH_MODE" in
    plain) ssh_plain "$@" ;;
    expect) ssh_expect "$*" ;;
    *) die "SSH mode was not initialized" ;;
  esac
}

copy_repo() {
  case "$SSH_MODE" in
    plain) scp -r "${SSH_OPTS[@]}" "$REPO_DIR" "$VM_USER@$VM_IP:~/dotfiles" ;;
    expect) scp_expect "$REPO_DIR" "~/dotfiles" ;;
    *) die "SSH mode was not initialized" ;;
  esac
}

wait_for_ssh() {
  local attempt
  VM_IP="$(tart ip --wait 300 "$VM_NAME")"
  log "VM IP: $VM_IP"

  for attempt in $(seq 1 60); do
    if ssh_plain true >/dev/null 2>&1; then
      SSH_MODE="plain"
      return
    fi
    if command -v expect >/dev/null 2>&1 && ssh_expect true >/dev/null 2>&1; then
      SSH_MODE="expect"
      return
    fi
    sleep 5
  done

  die "SSH did not become available"
}

main() {
  local profile

  if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
  fi

  [ "$#" -le 1 ] || die "expected at most one profile argument"
  profile="$(profile_from_args "${1:-}")"

  require tart
  trap cleanup EXIT

  log "cloning $TART_IMAGE to $VM_NAME"
  if ! tart clone "$TART_IMAGE" "$VM_NAME"; then
    die "failed to clone $TART_IMAGE; try TART_IMAGE=ghcr.io/cirruslabs/macos-sequoia-base:latest ./test-bootstrap.sh or authenticate to GHCR"
  fi

  log "booting $VM_NAME headlessly"
  tart run --no-graphics "$VM_NAME" >"$RUN_LOG" 2>&1 &

  wait_for_ssh

  log "copying local repo into VM"
  remote "rm -rf ~/dotfiles"
  copy_repo

  log "running setup.sh $profile inside VM"
  remote "cd ~/dotfiles && chmod +x setup.sh bin/.local/bin/sync-dots test-bootstrap.sh && HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_ENV_HINTS=1 ./setup.sh '$profile'"

  log "verifying bootstrap state"
  remote "command -v brew >/dev/null && command -v stow >/dev/null && command -v git >/dev/null"
  remote "test -L ~/.zshrc && test -L ~/.gitconfig && test -L ~/.Brewfile && test -L ~/.local/bin/sync-dots"

  log "bootstrap verification passed"
}

main "$@"
