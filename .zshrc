source ~/.zplug/init.zsh

# 補完ファイルの提供
zplug "zsh-users/zsh-completions"
# zshのシンタックスハイライトプラグイン
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# zshのヒストリーサーチを便利にする
zplug "zsh-users/zsh-history-substring-search"
# dockerコマンドエイリアス
zplug "tcnksm/docker-alias", use:zshrc, as:plugin
# oh-my-zshのgitコマンドエイリアスプラグイン
zplug "plugins/git", from:oh-my-zsh
# cdの強化版
zplug "b4b4r07/enhancd", use:enhancd.sh
# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
# tmux用インタラクティブフィルタ
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
# プロンプトテーマ
zplug "Tocyuki/zsh_prompt_theme", as:theme
# zplug
zplug "zplug/zplug"


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
# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd
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


# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose
