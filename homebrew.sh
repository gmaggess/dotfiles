#!/bin/bash
##############################################################################################################
### homebrew!

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon Macs
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed."
fi

# install all the things
./brew.sh
./brew-cask.sh

### end of homebrew
##############################################################################################################
