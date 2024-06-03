# config
set --universal theme_nerd_fonts yes
set -g theme_display_git_ahead_verbose yes
set -g theme_show_exit_status yes
set -g theme_date_timezone Asia/Tokyo
set -g theme_display_k8s_context yes
set -g theme_display_k8s_namespace yes

# env
set -x AWS_DEFAULT_REGION ap-northeast-1
set -x EDITOR vim
set -x XDG_CONFIG_HOME $HOME/.config
set -x LANG "en_US.UTF-8"
set -x HOMEBREW_INSTALL_CLEANUP 1
set -x FZF_DEFAULT_OPTS "--layout=reverse --inline-info --exit-0 -m"
set -x FZF_DEFAULT_COMMAND "ag -g ."
set -x FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -x TERM xterm-256color
set -x LSCOLORS gxfxcxdxbxegedabagacad
set -x LC_CTYPE "en_US.UTF-8"
set -x GO111MODULE auto
set -x DOCKER_CONTENT_TRUST 1
set -U FZF_LEGACY_KEYBINDINGS 0

# path
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -x PATH $PATH $GOBIN
set -x PATH $PATH $HOME/.poetry/bin
set -x PATH $PATH $HOME/.bin
set -x PATH $PATH /usr/local/opt/ansible@2.8/bin
set -x PATH $PATH /usr/local/opt/mysql-client/bin
set -gx LDFLAGS "-L/usr/local/opt/mysql-client/lib"
set -gx CPPFLAGS "-I/usr/local/opt/mysql-client/include"
set -gx PATH $PATH $HOME/.krew/bin

# alias
alias lg="lazygit"
alias ld="lazydocker"
alias ll='ls -lahG'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias glog='git log --oneline'
alias gc='git checkout .'
alias gdo='git diff (git log --oneline | fzf | awk "{print \$1}")'
alias k="kubectl"
alias t="terraform"
alias ghw='gh repo view -w (ghq list | fzf)'

# add homebrew path
eval (/opt/homebrew/bin/brew shellenv)

# github cli auto complete
eval (gh completion -s fish| source)

# github cli function
function ghcr
  gh repo create $argv
  ghq get $argv[1]
  $EDITOR (ghq list --full-path -e $argv[1])
end

