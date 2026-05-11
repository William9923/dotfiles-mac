# For profiling purposes
# zmodload zsh/zprof

source ~/zsh-defer/zsh-defer.plugin.zsh

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
export PATH="/opt/homebrew/Cellar:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/env"
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
# export PATH="/opt/homebrew/Cellar/openjdk/21/bin:$PATH"

# Directory for temporary trash
export GRAVEYARD="~/.local/share/Trash"

# Colima docker virtualbox
export DOCKER_HOST=unix://$HOME/.colima/true/docker.sock

# Postgres related library
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# Protobuf protoc (proto compiler)
export PATH="/opt/homebrew/opt/protobuf@3/bin:$PATH"

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
zsh-defer eval "$(atuin init zsh)"

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/william.ong/Downloads/google-cloud-sdk/path.zsh.inc' ]; then zsh-defer . '/Users/william.ong/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/william.ong/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then zsh-defer . '/Users/william.ong/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# gvm (go version manger)
zsh-defer source "/Users/william.ong/.gvm/scripts/gvm"

# Enable syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable directory jumping
source ~/zsh-z/zsh-z.plugin.zsh

# Enable auto-suggestion
source ~/zsh-autosuggestions/zsh-autosuggestions.zsh

# # kubernetes auto-completion
# [[ $commands[kubectl] ]] && zsh-defer source <(kubectl completion zsh)

# Load secrets from separate file (not tracked in version control)
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

# kubectl color
alias kubectl="kubecolor"

source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

zsh-defer eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
zsh-defer [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
zsh-defer [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
zsh-defer eval "$(pyenv init --path)"
zsh-defer eval "$(pyenv init -)"

# Following line was automatically added by arttime installer
export MANPATH=/Users/william.ong/.local/share/man:$MANPATH

# Following line was automatically added by arttime installer
export PATH=/Users/william.ong/.local/bin:$PATH

export PATH="$HOME/.rbenv/versions/3.2.2/bin:$HOME/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/bin:$PATH"
zsh-defer eval "$(rbenv init -)"

# pnpm
export PNPM_HOME="/Users/william.ong/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
zsh-defer [ -s "/Users/william.ong/.bun/_bun" ] && source "/Users/william.ong/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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

# Added by Antigravity
export PATH="/Users/william.ong/.antigravity/antigravity/bin:$PATH"
