source ~/.zplug/init.zsh

# Plugin -------------------------------------------
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
# cdの強化版
zplug "b4b4r07/enhancd", use:init.sh
# zshでpecoと連携するためのプラグイン
zplug "mollifier/anyframe"
# プロンプトテーマ
zplug "Tocyuki/zsh_prompt_theme", as:theme
# zplug
zplug "zplug/zplug"
# --------------------------------------------------

# Anyframe key bind --------------------------------
bindkey '^xb'   anyframe-widget-cdr
bindkey '^x^b'  anyframe-widget-checkout-git-branch
bindkey '^xr'   anyframe-widget-execute-history
bindkey '^x^r'  anyframe-widget-execute-history
bindkey '^xp'   anyframe-widget-put-history
bindkey '^x^p'  anyframe-widget-put-history
bindkey '^xg'   anyframe-widget-cd-ghq-repository
bindkey '^x^g'  anyframe-widget-cd-ghq-repository
bindkey '^xk'   anyframe-widget-kill
bindkey '^x^k'  anyframe-widget-kill
bindkey '^xi'   anyframe-widget-insert-git-branch
bindkey '^x^i'  anyframe-widget-insert-git-branch
bindkey '^xf'   anyframe-widget-insert-filename
bindkey '^x^f'  anyframe-widget-insert-filename
# --------------------------------------------------


# 文字コードの指定
export LANG=ja_JP.UTF-8
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# cdなしでディレクトリ移動
setopt auto_cd
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep
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


# グローバルエイリアス
alias lst='ls -ltr'
alias l='ls -ltr'
alias la='ls -la'
alias ll='ls -l'


# rbenv関連設定
export RBENV_ROOT="~/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
ieval "$(rbenv init -)"

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose
