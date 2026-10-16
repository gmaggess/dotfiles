# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
export EDITOR="code --wait"
# Theme configuration
ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
fpath=(/opt/homebrew/share/zsh-completions $fpath)
# Optimize compinit - only regenerate .zcompdump once a day
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -u
else
  compinit -u -C
fi

# Debug helper: allow tracing callers of the system java stub when needed.
if [[ -n "${DOTFILES_TRACE_JAVA:-}" ]]; then
  function java() {
    print -r -- "java called with: $*" >>"$DOTFILES_TRACE_JAVA"
    return 127
  }
  function java_home() {
    print -r -- "java_home called with: $*" >>"$DOTFILES_TRACE_JAVA"
    return 0
  }
fi

if [[ -n "${DOTFILES_ZSH_TRACE:-}" ]]; then
  export PS4='+zshrc:$LINENO: '
  set -x
fi

# Shared functions and Homebrew prefix detection (sets DOTFILES_BREW_PREFIX etc.)
source ~/.shell_common

# Lazy load NVM - only load when node/npm/nvm commands are used
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  # Lazy load nvm
  nvm() {
    unset -f nvm node npm npx
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    nvm "$@"
  }
  node() {
    unset -f nvm node npm npx
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    node "$@"
  }
  npm() {
    unset -f nvm node npm npx
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    npm "$@"
  }
  npx() {
    unset -f nvm node npm npx
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    npx "$@"
  }
fi

# Lazy load RVM
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  rvm() {
    unset -f rvm
    source "$HOME/.rvm/scripts/rvm"
    rvm "$@"
  }
fi

typeset -gi DOTFILES_ENABLE_INTERACTIVE_INIT=1
if [[ -n "${VSCODE_RESOLVING_ENVIRONMENT:-}" ]]; then
  DOTFILES_ENABLE_INTERACTIVE_INIT=0
fi

if (( DOTFILES_ENABLE_INTERACTIVE_INIT )); then
# Plugins
# Note: zsh-autosuggestions and zsh-syntax-highlighting are sourced manually
# below to control load order; do not add them here to avoid double-loading.
plugins=(
  git
  macos
  fzf
  fzf-tab
)

# Load oh-my-zsh first
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Defer loading of slow plugins to avoid blocking startup
if [[ -f $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f $ZSH_CUSTOM/plugins/zsh-peco-history/zsh-peco-history.zsh ]]; then
  source $ZSH_CUSTOM/plugins/zsh-peco-history/zsh-peco-history.zsh
fi

# Defer syntax highlighting to the very end (must be last)
if [[ -f $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Command execution time tracking (shows elapsed time for commands >= 3 seconds)
zmodload zsh/datetime
_cmd_time_start=0

_cmd_time_preexec() {
  _cmd_time_start=$EPOCHREALTIME
}

_cmd_time_precmd() {
  (( _cmd_time_start == 0 )) && return
  local -F elapsed=$(( EPOCHREALTIME - _cmd_time_start ))
  _cmd_time_start=0
  (( elapsed < 3 )) && return
  local -i total=$(( elapsed ))
  local -i h=$(( total / 3600 ))
  local -i m=$(( (total % 3600) / 60 ))
  local -i s=$(( total % 60 ))
  local result=""
  (( h > 0 )) && result+="${h}h "
  (( m > 0 )) && result+="${m}m "
  if (( h == 0 && m == 0 )); then
    local -i ms=$(( (elapsed - total) * 1000 ))
    result+="${s}.$(printf '%03d' $ms)s"
  else
    result+="${s}s"
  fi
  print -P "%F{yellow}took ${result}%f"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _cmd_time_preexec
add-zsh-hook precmd _cmd_time_precmd

source ~/.aliases
if [[ $- == *i* ]] && [[ ! -o noexec ]] && command -v ssh-agent >/dev/null 2>&1; then
  typeset -i dotfiles_need_agent=0
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    dotfiles_need_agent=1
  elif command -v ssh-add >/dev/null 2>&1; then
    ssh-add -l >/dev/null 2>&1
    dotfiles_ssh_add_status=$?
    [[ $dotfiles_ssh_add_status -eq 2 ]] && dotfiles_need_agent=1
    unset dotfiles_ssh_add_status
  fi
  if (( dotfiles_need_agent )); then
    eval "$(
      ssh-agent -s | grep -v '^echo '
    )"
  fi
  unset dotfiles_need_agent
fi

# Lazy load kubectl completion
if [[ $- == *i* ]] && [[ ! -o noexec ]] && command -v kubectl >/dev/null 2>&1; then
  kubectl() {
    unfunction kubectl
    source <(command kubectl completion zsh)
    kubectl "$@"
  }
fi
fi

# Unify and deduplicate PATH modifications
typeset -gU path
typeset -a dotfiles_path_entries=(
  /usr/local/bin
  /usr/local/sbin
  "$HOME/bin"
)

if [[ -n "$DOTFILES_BREW_PREFIX" ]]; then
  dotfiles_path_entries+=(
    "$DOTFILES_BREW_PREFIX/bin"
    "$DOTFILES_BREW_PREFIX/sbin"
  )
else
  dotfiles_path_entries+=(
    /opt/homebrew/bin
    /opt/homebrew/sbin
  )
fi

[[ -n "$DOTFILES_OPENSSL_BIN" ]] && dotfiles_path_entries+=("$DOTFILES_OPENSSL_BIN")
dotfiles_path_entries+=(
  "$HOME/.rbenv/bin"
  "$HOME/.rvm/bin"
  "$HOME/.rd/bin"
  "$HOME/.pyenv/bin"
)

typeset -a dotfiles_path_existing=()
for entry in "${dotfiles_path_entries[@]}"; do
  [[ -d "$entry" ]] && dotfiles_path_existing+=("$entry")
done
path=("${dotfiles_path_existing[@]}" "${path[@]}")
unset dotfiles_path_entries dotfiles_path_existing

openssl_lib_path=""
if [[ -n "$DOTFILES_OPENSSL_BIN" ]]; then
  openssl_lib_path="${DOTFILES_OPENSSL_BIN%/bin}/lib"
elif [[ -d "/opt/homebrew/opt/openssl@3/lib" ]]; then
  openssl_lib_path="/opt/homebrew/opt/openssl@3/lib"
fi
[[ -n "$openssl_lib_path" && -d "$openssl_lib_path" ]] && export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$openssl_lib_path"
unset openssl_lib_path
export VIRTUAL_ENV_DISABLE_PROMPT=1

if (( DOTFILES_ENABLE_INTERACTIVE_INIT )); then
# Lazy load thefuck
if [[ $- == *i* ]] && [[ ! -o noexec ]] && command -v thefuck >/dev/null 2>&1; then
  fuck() {
    unset -f fuck
    eval "$(thefuck --alias)"
    fuck "$@"
  }
fi

if [[ "${TERM_PROGRAM:-}" == "iTerm.app" ]] && [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi
fi

# Add Homebrew Ruby and pyenv to path array (respects typeset -gU deduplication)
[[ -d "/opt/homebrew/opt/ruby/bin" ]] && path=("/opt/homebrew/opt/ruby/bin" $path)

# Lazy load pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ] && [ -w "$PYENV_ROOT" ] && command -v pyenv >/dev/null 2>&1; then
  [[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
  pyenv() {
    unset -f pyenv
    eval "$(command pyenv init --path)"
    eval "$(command pyenv init -)"
    pyenv "$@"
  }
fi

# Lazy load rbenv - consistent with nvm/pyenv/sdkman patterns
if [ -d "$HOME/.rbenv" ] && command -v rbenv >/dev/null 2>&1; then
  rbenv() {
    unset -f rbenv ruby gem bundle
    eval "$(command rbenv init - zsh)"
    rbenv "$@"
  }
  ruby() { rbenv exec ruby "$@"; }
  gem()  { rbenv exec gem "$@"; }
  bundle() { rbenv exec bundle "$@"; }
fi

# openapi completions are in ~/.oh-my-zsh/custom/completions/_openapi

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# THIS MUST BE NEAR THE END FOR SDKMAN TO WORK
if [[ -z "${SKIP_SDKMAN:-}" ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    sdk() {
      unset -f sdk
      source "$HOME/.sdkman/bin/sdkman-init.sh"
      sdk "$@"
    }
  fi
fi

# zoxide - smarter cd with frecency (replaces plain cd)
# Init script pre-generated via: zoxide init zsh > ~/.zoxide.zsh
# Regenerate after zoxide updates.
[[ -f ~/.zoxide.zsh ]] && source ~/.zoxide.zsh

# Disable watchman-based file watching in sandboxed environments.
export WATCHMAN_DISABLE=true
export WATCHMAN_SOCK=/dev/null
export JEST_NO_WATCHMAN=1

# bat - syntax-highlighted pager; 'bcat' avoids shadowing system cat
if command -v bat >/dev/null 2>&1; then
  alias bcat='bat --pager=never'
fi

# Load powerlevel10k config (must be at end of file)
if (( DOTFILES_ENABLE_INTERACTIVE_INIT )) && [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.local/bin:$PATH"

# Local dev services - manual start/stop (none auto-start at login)
# PostgreSQL 18 (Homebrew, keg-only)
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"
export PGDATA="/opt/homebrew/var/postgresql@18"
alias pg-start='pg_ctl -D "$PGDATA" -l /opt/homebrew/var/log/postgresql@18.log start'
alias pg-stop='pg_ctl -D "$PGDATA" stop'
alias pg-status='pg_ctl -D "$PGDATA" status'

# Redis
alias redis-start='redis-server /opt/homebrew/etc/redis.conf --daemonize yes --logfile /opt/homebrew/var/log/redis.log && echo "redis started (port 6379)"'
alias redis-stop='redis-cli shutdown && echo "redis stopped"'
alias redis-status='redis-cli ping >/dev/null 2>&1 && echo "redis running (port 6379)" || echo "redis not running"'

# Arize Phoenix (UI at http://localhost:6006)
PHOENIX_PIDFILE="$HOME/.phoenix/phoenix.pid"
alias phoenix-start='mkdir -p ~/.phoenix; nohup phoenix serve >~/.phoenix/phoenix.log 2>&1 & echo $! >"$PHOENIX_PIDFILE"; echo "phoenix started (http://localhost:6006)"'
alias phoenix-stop='[ -f "$PHOENIX_PIDFILE" ] && kill $(cat "$PHOENIX_PIDFILE") && rm -f "$PHOENIX_PIDFILE" && echo "phoenix stopped" || echo "phoenix not running"'
alias phoenix-status='[ -f "$PHOENIX_PIDFILE" ] && kill -0 $(cat "$PHOENIX_PIDFILE") 2>/dev/null && echo "phoenix running (pid $(cat "$PHOENIX_PIDFILE"))" || echo "phoenix not running"'


# opencode
export PATH="$HOME/.opencode/bin":$PATH

# Optional settings from a separate private repository or this machine.
[[ ! -f "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"
