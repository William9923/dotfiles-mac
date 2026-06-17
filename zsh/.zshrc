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
alias lg="lazygit"
alias ldiff="lazygit status --screen-mode=full"
alias ld=lazydocker
alias t=tmux
alias v=nvim
alias ping=gping
alias ll="ls -la"
alias lla="ll -a"

# scripts shortcuts
alias zshconfig="nvim ~/.zshrc"
alias syncnotes="z vimwiki && sh ~/vimwiki/sync.sh"

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
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/theme/solarized-osaka/palette.zsh" ]] &&
  source "${XDG_CONFIG_HOME:-$HOME/.config}/theme/solarized-osaka/palette.zsh"

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

# Cross-session history sync for tmux panes/windows.
if [[ -o interactive ]]; then
  HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
  HISTSIZE=50000
  SAVEHIST=50000

  setopt APPEND_HISTORY
  setopt INC_APPEND_HISTORY
  setopt INC_APPEND_HISTORY_TIME
  setopt EXTENDED_HISTORY
  setopt SHARE_HISTORY

  __sync_zsh_history() {
    fc -RII "$HISTFILE" 2>/dev/null
  }

  precmd_functions+=(__sync_zsh_history)
fi

# fzf shell integration
if [[ -o interactive ]] && command -v fzf >/dev/null 2>&1; then
  # Allow Ctrl-S to be used as a key binding instead of terminal flow control.
  stty -ixon 2>/dev/null

  if [[ -n "${DOT_THEME_FG:-}" ]]; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--color=fg:${DOT_THEME_FG},fg+:${DOT_THEME_FG},bg:-1,bg+:-1,hl:${DOT_THEME_YELLOW},hl+:${DOT_THEME_ORANGE},info:${DOT_THEME_MUTED},border:${DOT_THEME_DIM},prompt:${DOT_THEME_BLUE},pointer:${DOT_THEME_MAGENTA},marker:${DOT_THEME_GREEN},spinner:${DOT_THEME_CYAN},header:${DOT_THEME_MUTED},gutter:-1,query:${DOT_THEME_FG},disabled:${DOT_THEME_MUTED}"
  fi

  export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"

  export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --bind 'ctrl-y:execute-silent(pbcopy < {+f})+abort'
    --color header:italic
    --header 'ENTER opens in nvim; CTRL-Y copies selected path(s) into clipboard'"

  export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target"
  if command -v tree >/dev/null 2>&1; then
    FZF_ALT_C_OPTS+=" --preview 'tree -C {}'"
  fi

  source <(fzf --zsh)

  if (( ${+functions[fzf-history-widget]} )); then
    # Wrap once per definition so re-sourcing does not nest wrappers.
    if (( ! ${+functions[fzf-history-widget-orig]} )) || [[ ${functions[fzf-history-widget]} != *"__sync_zsh_history"* ]]; then
      functions[fzf-history-widget-orig]=$functions[fzf-history-widget]
      function fzf-history-widget() {
        __sync_zsh_history
        fzf-history-widget-orig
      }
    fi
  fi

  fzf-file-widget() {
    local selected="$(__fzf_select)"
    local ret=$?
    if [[ -n "${selected//[[:space:]]/}" ]]; then
      zle push-line
      BUFFER="nvim -- ${selected}"
      zle accept-line
      return $?
    fi
    zle reset-prompt
    return $ret
  }
  zle -N fzf-file-widget

  fzf-rg-widget() {
    if ! command -v rg >/dev/null 2>&1; then
      zle -M "rg is required for Ctrl-S search"
      return 1
    fi

    local selected ret file line rest
    local preview_opts=()

    if command -v bat >/dev/null 2>&1; then
      preview_opts=(--preview 'bat --style=numbers --color=always --highlight-line {2} -- {1}')
    fi

    selected="$(
      printf '' |
        fzf --disabled \
          --prompt='rg> ' \
          --delimiter=':' \
          --header='Type to search with rg; ENTER opens match in nvim' \
          --bind='change:reload:test -n {q} && rg --column --line-number --no-heading --color=never --smart-case -- {q} || true' \
          "${preview_opts[@]}"
    )"
    ret=$?

    if [[ -n "${selected//[[:space:]]/}" ]]; then
      file="${selected%%:*}"
      rest="${selected#*:}"
      line="${rest%%:*}"

      if [[ -n "$file" && "$line" =~ '^[0-9]+$' ]]; then
        zle push-line
        BUFFER="nvim +${line} -- ${(q)file}"
        zle accept-line
        return $?
      fi
    fi

    zle reset-prompt
    return $ret
  }
  zle -N fzf-rg-widget
  bindkey '^S' fzf-rg-widget
fi


# For profiling purposes
# zprof

# opt out openspec telemetry
export OPENSPEC_TELEMETRY=0

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Pi
export PATH="/Users/william.ong/.local/share/mise/installs/node/26.2.0/bin:$PATH"
