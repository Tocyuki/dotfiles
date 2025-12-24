# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================
# Locale settings
# ==============================
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

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
# ヒストリー設定
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# ==============================
# Configuration: EnvVars
# ==============================
# Golangパス設定
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# ClaudeCodeパス設定
export PATH=$PATH:$HOME/.local/bin
# dein.vimパス設定
export XDG_CONFIG_HOME="$HOME/.config"
# aqua path
export PATH="$PATH:$(aqua root-dir)/bin"
export AQUA_GLOBAL_CONFIG="$HOME/.config/aqua/aqua.yaml"
# sheldon editor path
export EDITOR=nvim sheldon edit
export ZSH="$HOME/.local/share/sheldon/repos/github.com/ohmyzsh/ohmyzsh"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(sheldon source)"

# ==============================
# Key Bind
# ==============================
# Ctrl-a/e を zsh 標準の行頭/行末へ
bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Plugin: Anyframe key bind
# ghqコマンドで管理しているリポジトリに移動する
bindkey '^g'   anyframe-widget-cd-ghq-repository
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
alias vim='nvim'
alias lst='ls -ltr'
alias l='ls -ltr'
alias la='ls -la'
alias ll='ls -l'
alias ssh='TERM=xterm ssh'
alias t='terraform'
alias k='kubernetes'
alias lg='lazygit'
alias ld='lazydocker'
alias proot='cd $(git rev-parse --show-toplevel)'

# ==============================
# tmux: ディレクトリ変更時にウィンドウ名を更新
# ==============================
if [ -n "$TMUX" ]; then
  function tmux_rename_window() {
    # Gitリポジトリのルートディレクトリを取得
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$git_root" ]; then
      # リポジトリ名を取得
      local repo_name=$(basename "$git_root")
      tmux rename-window "$repo_name"
    else
      # Gitリポジトリでない場合はカレントディレクトリ名
      tmux rename-window "$(basename "$PWD")"
    fi
  }

  # ディレクトリ変更時に自動実行
  add-zsh-hook chpwd tmux_rename_window

  # 初回起動時にも実行
  tmux_rename_window
fi

# ==============================
# Other settings
# ==============================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/Users/tocyuki/.bun/_bun" ] && source "/Users/tocyuki/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/tocyuki/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Added by Antigravity
export PATH="/Users/tocyuki/.antigravity/antigravity/bin:$PATH"

# Local settings (not tracked by git)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
