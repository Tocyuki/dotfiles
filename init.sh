#!/usr/bin/env bash

set -eu

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo '# Set ATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
echo 'eval "`/opt/homebrew/bin/brew shellenv`"' >> $HOME/.zprofile
curl -fsSL https://claude.ai/install.sh | bash
eval "$(/opt/homebrew/bin/brew shellenv)"
