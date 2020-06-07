### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ==============================
# Plugins
# ==============================
# 入力中のコマンドを履歴から推測し表示する
zinit light zsh-users/zsh-autosuggestions
# 補完ファイルの提供
zinit light zsh-users/zsh-completions
# zshのシンタックスハイライトプラグイン
zinit light zsh-users/zsh-syntax-highlighting
# zshのヒストリーサーチを便利にする
zinit light zsh-users/zsh-history-substring-search
# zshでpeco/pecol/fzfと連携するためのプラグイン
zinit light mollifier/anyframe
# プロンプトテーマ
zinit light dracula/zsh
# ウィンドウを大量に分割してコマンドの同時実行
zinit light greymd/tmux-xpanes
# oh-my-zshのgitコマンドエイリアスプラグイン
zinit snippet OMZ::plugins/git/git.plugin.zsh

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
# Configuration: Global
# ==============================
# 補完の有効化
autoload -U compinit && compinit
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
# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# cdrコマンドを使えるようにする
autoload -Uz add-zsh-hock
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
# 文字コード
export LANG=ja_JP.UTF-8
export LC_CTYPE=en_US.UTF-8
# ヒストリー設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# Golangパス設定
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# dein.vimパス設定
export XDG_CONFIG_HOME="$HOME/.config"

# ==============================
# Alias
# ==============================
alias lst='ls -ltr'
alias l='ls -ltr'
alias la='ls -la'
alias ll='ls -l'
alias ssh='TERM=xterm ssh'
alias tmux='tmux -2'
if [[ -e $(which lazygit) ]]; then
  alias lg='lazygit'
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

