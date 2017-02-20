#!/bin/bash
for c in $(brew cask list); do
    info=$(brew cask info $c)
    installed_ver=$(echo "$info" | cut -d$'\n' -f1 | tr -d ' ' | cut -d':' -f 2)
    current_ver=$(echo "$info" | cut -d$'\n' -f3 | cut -d' ' -f 1 | rev | cut -d'/' -f 1 | rev)
    if [ "$installed_ver" != "$current_ver" ]; then
        echo "$c is installed '$installed_ver', current is '$current_ver'"
        brew cask reinstall $c
    fi
done