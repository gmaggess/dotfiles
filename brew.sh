#!/bin/bash

# Install command-line tools using Homebrew

# Make sure we're using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade


# GNU core utilities (those that come with macOS are outdated)
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils

brew install peco
brew install thefuck

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# run this script when this file changes guy.
brew install entr

# github util. imho better than hub
brew install gh

# mtr - ping & traceroute. best.
brew install mtr

# allow mtr to run without sudo
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//')
if [ -n "$mtrlocation" ]; then
    sudo chmod 4755 "$mtrlocation/sbin/mtr"
    sudo chown root "$mtrlocation/sbin/mtr"
else
    echo "Warning: could not find mtr Cellar path, skipping sudo setup"
fi

# Install other useful binaries
brew install fzf
brew install git
brew install kubernetes-cli
brew install nvm
brew install pv
brew install pyenv
brew install rbenv
brew install rename
brew install terminal-notifier
brew install tree
brew install watchman
brew install yarn
brew install z
brew install pygments

brew install zsh zsh-completions

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ -d "$ZSH_CUSTOM/plugins/zsh-peco-history" ] || \
    git clone https://github.com/jimeh/zsh-peco-history.git "$ZSH_CUSTOM/plugins/zsh-peco-history"

[ -d "$ZSH_CUSTOM/plugins/zsh-nvm" ] || \
    git clone https://github.com/lukechilds/zsh-nvm "$ZSH_CUSTOM/plugins/zsh-nvm"

[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

[ -d "$ZSH_CUSTOM/plugins/fzf-tab" ] || \
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"

[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# npm packages
brew install diff-so-fancy

brew tap dart-lang/dart
brew install dart

# Remove outdated versions from the cellar
brew cleanup
