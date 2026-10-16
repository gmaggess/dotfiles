# ~/.bashrc - sourced by bash for interactive non-login shells

# Silence Apple's default shell warning for bash sessions
export BASH_SILENCE_DEPRECATION_WARNING=1

# Source .bash_profile if it exists (for login shell configurations)
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
