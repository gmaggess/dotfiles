#!/bin/bash


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`


# Install native apps

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# daily
# brew cask install spectacle
brew cask install dropbox
brew cask install 1password
# brew cask install rescuetime
brew cask install flux
brew cask install dash
brew cask install alfred
brew cask install google-drive
brew cask install google-photos-backup

# dev
brew cask install iterm2
brew cask install sublime-text
brew cask install visual-studio-code
brew cask install webstorm
brew cask install intellij-idea-ce
brew cask install sourcetree
brew cask install virtualbox
brew cask install virtualbox-extension-pack
brew cask install docker
brew cask install docker-toolbox
brew cask install vagrant-manager
brew cask install balsamiq-mockups
# brew cask install imagealpha
# brew cask install imageoptim

# fun
brew cask install limechat
# brew cask install miro-video-converter
# brew cask install horndis # usb tethering
brew cask install skype

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox-esr
brew cask install firefoxdeveloperedition
brew cask install opera
# brew cask install firefoxnightly
# brew cask install webkit-nightly
# brew cask install chromium
brew cask install torbrowser

# less often
brew cask install disk-inventory-x
# brew cask install screenflow
brew cask install vlc
brew cask install gimp
# brew cask install gpgtools
# brew cask install licecap
brew cask install utorrent
brew cask install smcfancontrol
brew cask install arrsync
brew cask install appcleaner
brew cask install forklift
brew cask install keka
brew cask install the-unarchiver
brew cask install kindle
brew cask install bartender
brew cask install caffeine
brew cask install transmission
brew cask install whatsapp

# Not on cask but I want regardless.

# File Multi Tool 5
# Phosphor
