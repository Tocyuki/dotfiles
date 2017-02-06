export PATH="/usr/local/bin:$PATH"
export TERM=xterm-256color

# rbenv global setting
if [ -d "$HOME/.rbenv" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH;
  export RBENV_ROOT=$HOME/.rbenv;
  eval "$(rbenv init -)";
fi
