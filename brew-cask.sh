#!/bin/bash


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup


# Install native apps
brew tap homebrew/cask
brew update

# daily
# brew cask install 1password
brew cask install alfred
brew cask install dash
brew cask install dropbox
brew cask install flux
# brew cask install google-drive
# brew cask install google-photos-backup
# brew cask install onedrive
# brew cask install keep
# brew cask install spectacle
brew cask install proxifier

# dev
brew cask install vnc-viewer
brew cask install balsamiq-mockups
brew cask install docker
# brew cask install docker-toolbox
brew cask install intellij-idea-ce
brew cask install iterm2
brew cask install sourcetree
brew cask install atom
brew cask install sublime-text
brew cask install sublime-merge
# brew cask install vagrant-manager
# brew cask install virtualbox
# brew cask install virtualbox-extension-pack
brew cask install visual-studio-code
# brew cask install webstorm

# fun
# brew cask install limechat
# brew cask install skype

#browsers
brew cask install google-chrome
# brew cask install google-chrome-canary
# brew cask install chromium
# brew cask install firefoxdeveloperedition
# brew cask install firefoxnightly
# brew cask install webkit-nightly
# brew cask install opera

# less often
brew cask install appcleaner
# brew cask install arrsync
brew cask install bartender
brew cask install caffeine
brew cask install disk-inventory-x
brew cask install gimp
brew cask install keka
brew cask install kindle
# brew cask install smcfancontrol
brew cask install the-unarchiver
brew cask install transmission
# brew cask install vlc
brew cask install whatsapp
# brew cask install android-studio
# brew cask install anaconda

brew tap homebrew/cask-versions
brew cask install firefox-esr

#font
brew tap homebrew/cask-fonts
brew cask install font-source-code-pro
brew cask install font-source-code-pro-for-powerline
brew cask install font-sourcecodepro-nerd-font-mono
brew cask install font-fira-code
brew cask install font-firacode-nerd-font
brew cask install font-firacode-nerd-font-mono
