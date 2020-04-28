#!/bin/sh
# check if pyenv is available
# edit: fixed redirect issue in earlier version
if which pyenv >/dev/null 2>&1; then
  # assumes default location of brew in `/usr/local/bin/brew`
  /usr/bin/env PATH="${PATH//$(pyenv root)\/shims:/}" /usr/local/bin/brew "$@"
else
  /usr/local/bin/brew "$@"
fi