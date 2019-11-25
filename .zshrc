source ~/.zplug/init.zsh

# ==============================
# Plugin: zplug
# ==============================
# 入力中のコマンドを履歴から推測し表示する
zplug "zsh-users/zsh-autosuggestions"
# 補完ファイルの提供
zplug "zsh-users/zsh-completions"
# zshのシンタックスハイライトプラグイン
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# zshのヒストリーサーチを便利にする
zplug "zsh-users/zsh-history-substring-search"
# oh-my-zshのgitコマンドエイリアスプラグイン
zplug "plugins/git", from:oh-my-zsh
# zshでpecoと連携するためのプラグイン
zplug "mollifier/anyframe"
# プロンプトテーマ
zplug "dracula/zsh", as:theme
# zplug
zplug "zplug/zplug"
# fzf
zplug "junegunn/fzf-bin", as:command, rename-to:"fzf", from:gh-r
# fzfによるtmux拡張
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
# peco
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"
# 強化版cd
# zplug "b4b4r07/enhancd", use:init.sh
# ウィンドウを大量に分割してコマンドの同時実行
zplug "greymd/tmux-xpanes"

# ==============================
# Configuration: Global
# ==============================
# 文字コードの指定
# export LANG=ja_JP.UTF-8
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# cdなしでディレクトリ移動
setopt auto_cd
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep
# .zsh_historyに実行時刻を記録
setopt extended_history
# ヒストリ(履歴)を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
## cdrコマンドを使えるようにする
autoload -Uz add-zsh-hock
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook

# ==============================
# Plugin: Anyframe key bind
# ==============================
# 過去に移動したことのあるディレクトリに移動する
bindkey '^xc'   anyframe-widget-cdr
bindkey '^x^c'  anyframe-widget-cdr
# historyのコマンドライン履歴から選んで実行する
bindkey '^xr'   anyframe-widget-execute-history
bindkey '^x^r'  anyframe-widget-execute-history
# historyのコマンドライン履歴から選んでコマンドラインに挿入する
bindkey '^xp'   anyframe-widget-put-history
bindkey '^x^p'  anyframe-widget-put-history
# ghqコマンドで管理しているリポジトリに移動する
bindkey '^xg'   anyframe-widget-cd-ghq-repository
bindkey '^x^g'  anyframe-widget-cd-ghq-repository
# プロセスをkillする
bindkey '^xk'   anyframe-widget-kill
bindkey '^x^k'  anyframe-widget-kill
# Gitブランチを切り替える
bindkey '^xb'   anyframe-widget-checkout-git-branch
bindkey '^x^b'  anyframe-widget-checkout-git-branch
# Gitブランチ名をコマンドラインに挿入する
bindkey '^xi'   anyframe-widget-insert-git-branch
bindkey '^x^i'  anyframe-widget-insert-git-branch
# ファイル名をコマンドラインに挿入する
bindkey '^xf'   anyframe-widget-insert-filename
bindkey '^x^f'  anyframe-widget-insert-filename
# tmuxセッションを選んでアタッチする
bindkey '^xt'   anyframe-widget-tmux-attach
bindkey '^x^t'  anyframe-widget-tmux-attach
# anyframe-widgetから選んでそれを実行する
bindkey '^xa'   anyframe-widget-select-widget
bindkey '^x^a'  anyframe-widget-select-widget

# ==============================
# Alias
# ==============================
alias lst='ls -ltr'
alias l='ls -ltr'
alias la='ls -la'
alias ll='ls -l'
alias ssh='TERM=xterm ssh'
alias tmux='tmux -2'

# ==============================
# Custom Functions
# ==============================
stop-ec2-instance() {
  InstanceId=$(aws ec2 describe-instances --profile $1 --filter "Name=tag:Name,Values=$2"| jq ".Reservations[].Instances[].InstanceId")
  aws ec2 stop-instances --instance-ids $InstanceId
}

# ==============================
# Environment variable
# ==============================
# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# Ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# dein.vim
export XDG_CONFIG_HOME="$HOME/.config"

# 未インストール項目をインストールする
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose
