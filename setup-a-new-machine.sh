#!/bin/bash
set -e

#
# Bootstrap a new macOS machine
# Run each step interactively with confirmation
#

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

print_step() {
    printf "\n\e[0;35m━━━ Step %s: %s ━━━\e[0m\n\n" "$1" "$2"
}

confirm() {
    read -r -p "  Run this step? (y/n) " choice
    case "$choice" in
        y|Y) return 0 ;;
        *) echo "  Skipped."; return 1 ;;
    esac
}

total_steps=7
current=0

# Step 1: Backup old machine
current=$((current + 1))
print_step "$current/$total_steps" "Backup old machine (migration.sh)"
if confirm; then
    ./migration.sh
fi

# Step 2: Xcode Command Line Tools
current=$((current + 1))
print_step "$current/$total_steps" "Install Xcode Command Line Tools"
if confirm; then
    ./xcode.sh
fi

# Step 3: Homebrew + packages
current=$((current + 1))
print_step "$current/$total_steps" "Install Homebrew and packages"
if confirm; then
    ./homebrew.sh
fi

# Step 4: Common tools
current=$((current + 1))
print_step "$current/$total_steps" "Install common tools"
if confirm; then
    ./common.sh
fi

# Step 5: macOS defaults
current=$((current + 1))
print_step "$current/$total_steps" "Set macOS defaults (.osx)"
if confirm; then
    sh .osx
fi

# Step 6: SDKMAN
current=$((current + 1))
print_step "$current/$total_steps" "Install SDKMAN (Java SDK manager)"
if confirm; then
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash
        echo "  SDKMAN installed. Restart your shell or run: source \"\$HOME/.sdkman/bin/sdkman-init.sh\""
    else
        echo "  SDKMAN already installed, skipping."
    fi
fi

# Step 7: Symlinks
current=$((current + 1))
print_step "$current/$total_steps" "Create symlinks (symlink-setup.sh)"
echo "  Set Git identity in ~/.gitconfig.local; keep credentials in your credential manager."
if confirm; then
    ./symlink-setup.sh
fi

printf "\n\e[0;32m  [✔] Setup complete!\e[0m\n"
