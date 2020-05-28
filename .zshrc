source ~/.zplug/init.zsh

# ==============================
# Plugin: zplug
# ==============================
# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
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
# zshでpeco/pecol/fzfと連携するためのプラグイン
zplug "mollifier/anyframe"
# プロンプトテーマ
zplug "dracula/zsh", as:theme
# fzf
zplug "junegunn/fzf-bin", as:command, rename-to:"fzf", from:gh-r
# fzfによるtmux拡張
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
# peco
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"
# ウィンドウを大量に分割してコマンドの同時実行
zplug "greymd/tmux-xpanes"
# Gitリポジトリ管理
zplug "motemen/ghq", from:gh-r, as:command, rename-to:ghq, lazy:true

# ==============================
# Configuration: Global
# ==============================
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
# Functions
# ==============================
function fzf-ec2(){
  if [ $1 -lt "-h" ]; then
    echo "Usage: fzf-ec2 <aws-profile>"
    exit 0
  elif [ $# -eq 0 ]; then
    profile="default"
  fi
  aws --profile="$1" ec2 describe-instances --query \
                          'sort_by(Reservations[].Instances[].{
                            Z_LaunchTime:LaunchTime,B_InstanceId:InstanceId,
                            A_NameTags:Tags[?Key==`Name`].Value|[0],
                            C_InstanceType:InstanceType,
                            D_State:State.Name,
                            E_ExternalIP:PublicIpAddress,
                            F_InternalIP:PrivateIpAddress,
                            G_AZ:Placement.AvailabilityZone,
                            H_Environment:Tags[?Key==`Environment`].Value|[0]},
                            &Z_LaunchTime)' --output text | fzf
}

# ==============================
# Alias
# ==============================
alias lst='ls -ltr'
alias l='ls -ltr'
alias la='ls -la'
alias ll='ls -l'
alias ssh='TERM=xterm ssh'
alias tmux='tmux -2'
if [[ -e /usr/local/bin/nvim ]]; then
  alias vim='nvim'
fi
if [[ -e /usr/local/bin/lazygit ]]; then
  alias lg='lazygit'
fi

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
