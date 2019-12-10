# ==============================
# Global
# ==============================
export LANG=ja_JP.UTF-8
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# ==============================
# Golang
# ==============================
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# ==============================
# Ruby
# ==============================
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# ==============================
# dein.vim
# ==============================
export XDG_CONFIG_HOME="$HOME/.config"

