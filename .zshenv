export PATH="/usr/local/bin:$PATH"
export TERM=xterm-256color

# rbenv
if [ -d "$HOME/.rbenv" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH;
  export RBENV_ROOT=$HOME/.rbenv;
  eval "$(rbenv init -)";
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PATH=$HOME/.pyenv/bin:$PATH;
  export PYENV_ROOT=$HOME/.pyenv;
  eval "$(pyenv init -)";
fi

## golang
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# enhancd
export ENHANCD_COMMAND=ecd
export ENHANCD_FILTER=fzy:fzf:peco
export PATH=/root/anaconda3/bin:$PATH
