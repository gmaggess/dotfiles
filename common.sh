#!/bin/bash
##############################################################################################################
### install of common things
###

# Type `git open` to open the GitHub page or website for a repository.
npm install -g git-open

# fancy listing of recent branches
npm install -g git-recent

# sexy git diffs
npm install -g diff-so-fancy

# trash as the safe `rm` alternative
npm install --global trash-cli


# nvm — install current LTS node
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
nvm install --lts


# add brew bash to /etc/shells if not already there
BASHPATH="$(brew --prefix)/bin/bash"
if ! grep -qF "$BASHPATH" /etc/shells; then
    echo "$BASHPATH" | sudo tee -a /etc/shells
fi
chsh -s "$BASHPATH"
echo "$BASH_VERSION" # should be 4.x+


###
##############################################################################################################
