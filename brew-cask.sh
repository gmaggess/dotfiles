#!/bin/bash


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`


# Install native apps

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# daily
brew cask install 1password
brew cask install alfred
brew cask install dash
brew cask install dropbox
brew cask install flux
brew cask install google-drive
brew cask install google-photos-backup
brew cask install onedrive
#brew cask install spectacle

# dev
brew cask install balsamiq-mockups
brew cask install docker
brew cask install docker-toolbox
brew cask install intellij-idea-ce
brew cask install iterm2
brew cask install sourcetree
brew cask install sublime-text
brew cask install vagrant-manager
brew cask install virtualbox
brew cask install virtualbox-extension-pack
brew cask install visual-studio-code
#brew cask install webstorm

# fun
brew cask install limechat
brew cask install skype

# browsers
# brew cask install chromium
# brew cask install firefoxnightly
# brew cask install webkit-nightly
brew cask install firefox-esr
brew cask install firefoxdeveloperedition
brew cask install google-chrome
brew cask install google-chrome-canary
#brew cask install opera
#brew cask install torbrowser

# less often
brew cask install appcleaner
brew cask install arrsync
brew cask install bartender
brew cask install caffeine
brew cask install disk-inventory-x
brew cask install forklift
brew cask install gimp
brew cask install keka
brew cask install kindle
brew cask install smcfancontrol
brew cask install the-unarchiver
brew cask install transmission
brew cask install vlc
brew cask install whatsapp

#font
brew tap caskroom/fonts
brew cask install font-source-code-pro
brew cask install font-source-code-pro-for-powerline
brew cask install font-sourcecodepro-nerd-font-mono