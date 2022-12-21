#!/usr/bin/env bash

-eu

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo '# Set ATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
echo 'eval "`/opt/homebrew/bin/brew shellenv`"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
