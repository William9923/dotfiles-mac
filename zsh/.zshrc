# For profiling purposes
# zmodload zsh/zprof

if [ -r "$HOME/zsh-defer/zsh-defer.plugin.zsh" ]; then
  source "$HOME/zsh-defer/zsh-defer.plugin.zsh"
else
  zsh-defer() { "$@"; }
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export K9S_EDITOR=nvim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"
if java_home="$(/usr/libexec/java_home -v 1.8 2>/dev/null)"; then
  export JAVA_HOME="$java_home"
fi
# export PATH="/opt/homebrew/Cellar/openjdk/21/bin:$PATH"

# Directory for temporary trash
export GRAVEYARD="$HOME/.local/share/Trash"

# Colima docker virtualbox
export DOCKER_HOST=unix://$HOME/.colima/true/docker.sock

# Postgres related library
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# Protobuf protoc (proto compiler)
export PATH="/opt/homebrew/opt/protobuf/bin:$PATH"

# Useful alias
alias ls="ls -p -G"
alias la="ls -A"
alias ll="ls -l"
alias lla="ll -A"
alias g=git
alias lg=lazygit
alias ld=lazydocker
alias t=tmux
alias v=nvim
alias ping=gping
alias ll="ls -la"
alias lla="ll -a"
alias c="claude"

# scripts shortcuts
alias zshconfig="nvim ~/.zshrc"
alias syncnotes="z vimwiki && sh ~/vimwiki/sync.sh"

# for atuin (commmand history) widget
if command -v atuin >/dev/null 2>&1; then
  zsh-defer eval "$(atuin init zsh)"
fi

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/william.ong/Downloads/google-cloud-sdk/path.zsh.inc' ]; then zsh-defer . '/Users/william.ong/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/william.ong/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then zsh-defer . '/Users/william.ong/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Enable syntax highlighting
if [ -r "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Enable directory jumping
if [ -r "$HOME/zsh-z/zsh-z.plugin.zsh" ]; then
  source "$HOME/zsh-z/zsh-z.plugin.zsh"
fi

# Enable auto-suggestion
if [ -r "$HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# # kubernetes auto-completion
# [[ $commands[kubectl] ]] && zsh-defer source <(kubectl completion zsh)

# Load secrets from separate file (not tracked in version control)
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

# kubectl color
if command -v kubecolor >/dev/null 2>&1; then
  alias kubectl="kubecolor"
fi

if [ -r "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]; then
  source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
[ -r "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"

if command -v direnv >/dev/null 2>&1; then
  zsh-defer eval "$(direnv hook zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  zsh-defer eval "$(mise activate zsh)"
fi

# Following line was automatically added by arttime installer
export MANPATH="$HOME/.local/share/man:$MANPATH"

# Following line was automatically added by arttime installer
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# opencode - Function to run OpenCode on an available port
unalias op 2>/dev/null
op() {
  local start_port=3000
  local end_port=3100
  local found_port=""

  for port in {$start_port..$end_port}; do
    # Check if port is in use
    if ! lsof -i :$port -stcp:listen -P -n >/dev/null 2>&1; then
      found_port=$port
      break
    fi
  done

  if [[ -n "$found_port" ]]; then
    echo "🚀 Launching OpenCode on port $found_port"
    rtk opencode --port "$found_port" "$@"
  else
    echo "⚠️ No ports available in range 3000-3010. Trying default..."
    rtk opencode "$@"
  fi
}

# opencode preset switcher
op-preset() {
  local config_file="$HOME/.config/opencode/oh-my-opencode-slim.json"
  local presets=("tier-google" "tier-opencode" "tier-github" "tier-antigravity")

  # Show current preset if no arguments
  if [[ $# -eq 0 ]]; then
    local current=$(grep -o '"preset": "[^"]*"' "$config_file" | cut -d'"' -f4)
    echo "Current preset: $current"
    echo ""
    echo "Available presets:"
    for p in "${presets[@]}"; do
      if [[ "$p" == "$current" ]]; then
        echo "  * $p (active)"
      else
        echo "    $p"
      fi
    done
    echo ""
    echo "Usage: op-preset <preset-name>"
    echo "       op-preset --fzf    # interactive selection"
    return 0
  fi

  # Interactive fzf mode
  if [[ "$1" == "--fzf" ]] || [[ "$1" == "-i" ]]; then
    local current=$(grep -o '"preset": "[^"]*"' "$config_file" | cut -d'"' -f4)
    local selected=$(printf '%s\n' "${presets[@]}" | fzf --prompt="Select opencode preset: " --preview="echo Current: $current")
    if [[ -n "$selected" ]]; then
      op-preset "$selected"
    fi
    return 0
  fi

  # Validate preset name
  local preset="$1"
  local valid=false
  for p in "${presets[@]}"; do
    if [[ "$p" == "$preset" ]]; then
      valid=true
      break
    fi
  done

  if [[ "$valid" == false ]]; then
    echo "Error: Invalid preset '$preset'"
    echo "Valid presets: ${presets[*]}"
    return 1
  fi

  # Switch preset
  sed -i "" "s/\"preset\": \".*\"/\"preset\": \"$preset\"/" "$config_file"
  echo "Switched to preset: $preset"
}

# For profiling purposes
# zprof


# kc - Kubernetes database helper
export PATH="$HOME/dev/tools/kc:$PATH"

# opt out openspec telemetry
export OPENSPEC_TELEMETRY=0

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
