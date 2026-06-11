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
autoload -Uz add-zsh-hook
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
# tfenv (aqua 管理の tfenv を terraform のバージョンマネージャとして使用)
# TFENV_ROOT は未設定。tfenv が自身の install dir(aqua pkg)を自動解決し、
# terraform 版もそこの versions/ に格納される。
if command -v aqua >/dev/null 2>&1; then
  # tfenv pkg の bin(terraform シム入り)を PATH 先頭へ。aqua which で固定パスを避ける
  export PATH="$(dirname "$(aqua which tfenv)"):$PATH"
fi
# sheldon editor path
export EDITOR=nvim sheldon edit
export ZSH="$HOME/.local/share/sheldon/repos/github.com/ohmyzsh/ohmyzsh"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(sheldon source)"

# ==============================
# Project navigation
# ==============================
export GHQ_SELECTOR=fzf
export GHQ_SELECTOR_OPTS="${GHQ_SELECTOR_OPTS:-}"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

function ghq-roots() {
  local selected
  selected=$(ghq list --full-path | roots | fzf --height 40% --reverse)
  if [ -n "$selected" ]; then
    cd "$selected" || return
  fi
}

function __ghq_roots_widget() {
  ghq-roots
  zle reset-prompt
}

function git-wt-cd() {
  local selected
  selected=$(git-wt | fzf --header-lines=1 --height 40% --reverse | awk '{if ($1 == "*") print $2; else print $1}')
  if [ -n "$selected" ]; then
    cd "$selected" || return
  fi
}

function __git_wt_cd_widget() {
  git-wt-cd
  zle reset-prompt
}

# ==============================
# Key Bind
# ==============================
# Ctrl-a/e を zsh 標準の行頭/行末へ
bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# ghqで管理しているリポジトリとmonorepo内のrootを選んで移動する
zle -N __ghq_roots_widget
bindkey '^g'   __ghq_roots_widget
# git-wtで管理しているworktreeを選んで移動する
zle -N __git_wt_cd_widget
bindkey '^xw'   __git_wt_cd_widget
bindkey '^x^w'  __git_wt_cd_widget

# Plugin: Anyframe key bind
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
alias cc='CLAUDE_CODE_NO_FLICKER=1 claude --permission-mode plan --allow-dangerously-skip-permissions'
alias cx='codex'
alias gg='ghq get'
alias gwt='git wt'
alias gwtd='git wt -D'

# ==============================
# tmux: ディレクトリ変更時にウィンドウ名を更新
# ==============================
if [ -n "$TMUX" ]; then
  function tmux_rename_window() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$git_root" ]; then
      tmux rename-window "$(basename "$git_root")"
    else
      tmux rename-window "$(basename "$PWD")"
    fi
  }

  add-zsh-hook chpwd tmux_rename_window
  add-zsh-hook precmd tmux_rename_window
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
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/tocyuki/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
