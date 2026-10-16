# Silence Apple's default shell warning for bash sessions
export BASH_SILENCE_DEPRECATION_WARNING=1

# Shared functions and Homebrew prefix detection (sets DOTFILES_BREW_PREFIX etc.)
source ~/.shell_common

# Set up PATH early before using brew-dependent commands, avoiding duplicates
path_candidates=(
    /usr/local/bin
    /usr/local/sbin
    "$HOME/bin"
)
if [[ -n "$DOTFILES_BREW_PREFIX" ]]; then
    path_candidates+=(
        "$DOTFILES_BREW_PREFIX/bin"
        "$DOTFILES_BREW_PREFIX/sbin"
    )
else
    path_candidates+=(
        /opt/homebrew/bin
        /opt/homebrew/sbin
    )
fi
[[ -n "$DOTFILES_OPENSSL_BIN" ]] && path_candidates+=("$DOTFILES_OPENSSL_BIN")
path_candidates+=(
    "$HOME/.rbenv/bin"
    "$HOME/.rvm/bin"
    "$HOME/.pyenv/bin"
    "$HOME/.rd/bin"
)
to_add=()
for dir in "${path_candidates[@]}"; do
    [[ -d "$dir" ]] || continue
    case ":$PATH:" in
        *":$dir:"*) continue ;;
    esac
    to_add+=("$dir")
done
for (( idx=${#to_add[@]}-1; idx>=0; idx-- )); do
    PATH="${to_add[idx]}:$PATH"
done
unset path_candidates to_add
export PATH

openssl_lib_path=""
if [[ -n "$DOTFILES_OPENSSL_BIN" ]]; then
    openssl_lib_path="${DOTFILES_OPENSSL_BIN%/bin}/lib"
elif [[ -d "/opt/homebrew/opt/openssl@3/lib" ]]; then
    openssl_lib_path="/opt/homebrew/opt/openssl@3/lib"
fi
[[ -n "$openssl_lib_path" && -d "$openssl_lib_path" ]] && export LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$openssl_lib_path"
unset openssl_lib_path

# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.extra can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# to help sublimelinter etc with finding my PATHS
case $- in
   *i*) [[ ! -f ~/.extra ]] || source ~/.extra
esac

# generic colouriser
GRC=$(which grc)
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        for app in {diff,make,gcc,g++,ping,traceroute}; do
            alias "$app"='colourify '$app
    done
fi

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

##
## gotta tune that bash_history…
##
if [ -n "$BASH_VERSION" ]; then
  # Enable history expansion with space
  # E.g. typing !!<space> will replace the !! with your last command
  bind Space:magic-space

  # keep history up to date, across sessions, in realtime
  #  http://unix.stackexchange.com/a/48113
  type shopt &> /dev/null && shopt -s histappend  # append to history, don't overwrite it

  # Save multi-line commands as one command
  shopt -s cmdhist

  # Save and reload the history after each command finishes
  export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
fi

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
export HISTTIMEFORMAT='%F %T '

export HISTCONTROL="erasedups:ignoreboth"       # no duplicate entries
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.

##
## hooking in other apps…
##
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# z beats cd most of the time. `brew install z`
if command -v brew >/dev/null 2>&1; then
    zpath="$(brew --prefix)/etc/profile.d/z.sh"
    [ -s "$zpath" ] && source "$zpath"
fi


# NVM - lazy load (mirrors zsh pattern for faster startup)
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  _nvm_load() { unset -f nvm node npm npx _nvm_load; . "/opt/homebrew/opt/nvm/nvm.sh"; }
  nvm()  { _nvm_load; nvm  "$@"; }
  node() { _nvm_load; node "$@"; }
  npm()  { _nvm_load; npm  "$@"; }
  npx()  { _nvm_load; npx  "$@"; }
fi

# Python environment (pyenv) - mirror zsh guarded init
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ] && [ -w "$PYENV_ROOT" ] && command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  if [[ $- == *i* ]]; then
    eval "$(pyenv init -)"
  fi
fi

# Ruby environment (rbenv) - mirror zsh guarded init
if [ -d "$HOME/.rbenv" ] && command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# Only enable 'thefuck' alias if installed to avoid errors
if [[ $- == *i* ]] && command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi

# kubectl completion for bash (guarded)
if [[ $- == *i* ]] && command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
fi

##
## Completion…
##

if [[ $- == *i* ]]; then
    if [[ -n "$ZSH_VERSION" ]]; then  # quit now if in zsh
        return 1 2> /dev/null || exit 1
    fi

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

    # bash completion.
    if command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
        source "$(brew --prefix)/share/bash-completion/bash_completion"
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi

    # homebrew completion
    if command -v brew >/dev/null 2>&1; then
        source "$(brew --prefix)/etc/bash_completion.d/brew"
    fi

    # gh completion
    if command -v gh >/dev/null 2>&1; then
        eval "$(gh completion -s bash)"
    fi

    # Enable tab completion for `g` by marking it as an alias for `git`
    if type __git_complete &> /dev/null; then
        __git_complete g __git_main
    fi

    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults
fi


##
## better `cd`'ing
##
if [ -n "$BASH_VERSION" ]; then
  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob;

  # Correct spelling errors in arguments supplied to cd
  shopt -s cdspell;

  # Autocorrect on directory names to match a glob.
  shopt -s dirspell 2> /dev/null

  # Turn on recursive globbing (enables ** to recurse all directories)
  shopt -s globstar 2> /dev/null
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

[[ ! -f "$HOME/.bash_profile.local" ]] || source "$HOME/.bash_profile.local"
