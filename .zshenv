export PATH="/usr/local/bin:$PATH"
export TERM=xterm-256color

# rbenv
if [ -d "$HOME/.rbenv" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH;
  export RBENV_ROOT=$HOME/.rbenv;
  eval "$(rbenv init -)";
fi

## golang
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# enhancd
export ENHANCD_COMMAND=ecd
export ENHANCD_FILTER=fzy:fzf:peco
