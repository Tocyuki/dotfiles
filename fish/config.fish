# env
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -x PATH $PATH $GOBIN
set -x XDG_CONFIG_HOME $HOME/.config
set -x LANG "en_US.UTF-8"
set -x HOMEBREW_INSTALL_CLEANUP 1
set -x FZF_DEFAULT_OPTS "--layout=reverse --inline-info --exit-0 -m"
set -x FZF_DEFAULT_COMMAND "ag -g ."
set -x FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -x TERM xterm-256color
set -x LSCOLORS gxfxcxdxbxegedabagacad
set -x EDITOR vim
set -x LC_CTYPE "en_US.UTF-8"
set -x GO111MODULE auto
set -x DOCKER_CONTENT_TRUST 1
set -g theme_display_git_ahead_verbose yes
set -g theme_nerd_fonts yes

# alias
alias lg="lazygit"
alias ll='ls -lahG'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias glog='git log --oneline'
alias gc='git checkout .'
alias gdc='git diff (git log --oneline | fzf | awk "{print \$1}")'

