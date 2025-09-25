#!/bin/sh
# check if pyenv is available
# edit: fixed redirect issue in earlier version
if which pyenv >/dev/null 2>&1; then
  # assumes default location of brew in `/opt/homebrew/bin/brew`
  /usr/bin/env PATH="${PATH//$(pyenv root)\/shims:/}" /opt/homebrew/bin/brew "$@"
else
  /opt/homebrew/bin/brew "$@"
fi