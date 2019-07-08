#!/bin/bash

# Install command-line tools using Homebrew

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade


# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --with-default-names


# Bash 4
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`.
# brew install bash
brew tap homebrew/versions
# brew install bash-completion2
brew install peco
brew install thefuck

# brew install homebrew/completions/brew-cask-completion

# generic colouriser  http://kassiopeia.juls.savba.sk/~garabik/software/grc/
brew install grc

# Install wget with IRI support
brew install wget --with-iri

# Install more recent versions of some OS X tools
brew install vim --with-override-system-vi
# brew install homebrew/dupes/grep
# brew install homebrew/dupes/openssh
# brew install homebrew/dupes/screen


# run this script when this file changes guy.
brew install entr

# github util. imho better than hub
brew install gh


# mtr - ping & traceroute. best.
brew install mtr

# allow mtr to run without sudo
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//') #  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
sudo chmod 4755 $mtrlocation/sbin/mtr
sudo chown root $mtrlocation/sbin/mtr


# Install other useful binaries
# brew install the_silver_searcher
# brew install fzf
brew install git
# brew install imagemagick --with-webp
# brew install graphicsmagick
brew install nvm # This installs `npm` too using the recommended installation method
brew install yarn
brew install watchman
brew install pv
brew install rename
brew install tree
# brew install zopfli
# brew install ffmpeg --with-libvpx
brew install terminal-notifier

# brew install Caskroom/cask/java
brew install pyenv
brew install rbenv
# brew install pidcat   # colored logcat guy

brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# npm packages
brew install diff-so-fancy

brew tap dart-lang/dart
# brew install dart

# Remove outdated versions from the cellar
brew cleanup
