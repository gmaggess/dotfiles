#!/bin/bash

# Install GUI apps using Homebrew Cask

brew update

install_cask() {
    if brew list --cask "$1" &>/dev/null; then
        echo "  $1 already installed, skipping."
    else
        brew install --cask "$1"
    fi
}

install_cask 1password
install_cask alfred
install_cask appcleaner
install_cask bartender
install_cask firefox@esr
install_cask font-fira-code
install_cask font-fira-code-nerd-font
install_cask font-source-code-pro
install_cask font-montserrat
install_cask brave-browser
install_cask intellij-idea-ce
install_cask iterm2
install_cask keka
install_cask postman
install_cask slack
install_cask sublime-merge
install_cask sublime-text
install_cask transmission
install_cask docker
install_cask visual-studio-code
install_cask whatsapp
install_cask zoom
