# tmux wConfiguration Documentation

このドキュメントは `.tmux.conf` ファイルの設定内容について詳細に説明します。

## 1. プラグイン管理 (tpm)

```bash
# ==============================
# Configuration: tpm
# ==============================
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-pain-control'
run-shell '~/.tmux/plugins/tpm/tpm'
```

### 説明

- **tpm**: Tmux Plugin Manager - プラグイン管理システム
- **tmux-yank**: コピー機能の拡張
- **tmux-open**: ファイルやURLを開く機能
- **tmux-sensible**: 基本的な設定を自動化
- **tmux-resurrect**: セッション復元機能
- **tmux-continuum**: 自動セッション保存・復元
- **tmux-pain-control**: ペイン操作の改善

## 2. グローバル設定

```bash
# 設定ファイルをリロードする
bind r source-file ~/.tmux.conf \; display "Reloaded!"
# 256色端末を使用する
set -g default-terminal "xterm-256color"
# キーストロークのディレイを減らす
set -sg escape-time 1
# ウィンドウのインデックスを1から始める
set -g base-index 1
# ペインのインデックスを1から始める
setw -g pane-base-index 1
# 後方スクロール行数
set-option -g history-limit 40960
# Vimのキーバインドを使う
setw -g mode-keys vi
# リフレッシュの間隔を設定する(デフォルト 15秒)
set -g status-interval 60
# truecolor (24bit) 対応
set -as terminal-overrides ",*:Tc"
```

### 詳細解説

- `bind r source-file ~/.tmux.conf`: Prefix + r で設定ファイル再読み込み
- `set -g default-terminal "xterm-256color"`: 256色サポート
- `set -sg escape-time 1`: ESCキーの遅延を1msに短縮（vim使用時の応答性向上）
- `set -g base-index 1`: ウィンドウ番号を1から開始（デフォルトは0）
- `setw -g pane-base-index 1`: ペイン番号を1から開始
- `set-option -g history-limit 40960`: スクロールバックバッファを40960行に設定
- `setw -g mode-keys vi`: コピーモードでviキーバインドを使用
- `set -as terminal-overrides ",*:Tc"`: True Color（1600万色）サポート

## 3. ステータスバー設定

```bash
# ステータスバーの色を設定する
set -g status-fg white
set -g status-bg black
# 左パネルを設定する
set -g status-left-length 70
set -g status-left "#[fg=green]Session:#S  #[fg=yellow]Window:#I  #[fg=cyan]Pane:#P"
# 右パネルを設定する
set -g status-right "#[fg=white][%Y-%m-%d (%a) %H:%M]"
# リフレッシュの間隔を設定する(デフォルト 15秒)
set -g status-interval 1
# ウィンドウリストの位置を中心寄せにする
set -g status-justify centre
# ヴィジュアルノーティフィケーションを有効にする
setw -g monitor-activity on
set -g visual-activity on
# ステータスバーを上部に表示する
set -g status-position top
```

### 詳細解説

- `status-fg/bg`: ステータスバーの文字色（白）・背景色（黒）
- `status-left`: 左側にセッション名、ウィンドウ番号、ペイン番号を色分けして表示
- `status-right`: 右側に日時を表示（年-月-日 (曜日) 時:分）
- `status-interval 1`: 1秒ごとにステータスバーを更新
- `status-justify centre`: ウィンドウリストを中央揃え
- `monitor-activity on`: ウィンドウでアクティビティがあった時に通知
- `status-position top`: ステータスバーを画面上部に配置

## 4. ペイン操作設定

```bash
# Vimのキーバインドでペインを移動する
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
# Vimのキーバインドでペインをリサイズする
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
# | でペインを縦に分割する
bind | split-window -h
# - でペインを横に分割する
bind - split-window -v
# sync設定のON/OFF切替
bind-key e setw synchronize-panes on
bind-key E setw synchronize-panes off
```

### 詳細解説

- `bind h/j/k/l select-pane`: Prefix + h/j/k/l でペイン移動（vim風）
- `bind -r H/J/K/L resize-pane`: Prefix + H/J/K/L でペインリサイズ（`-r`で連続実行可能）
- `bind | split-window -h`: Prefix + | で縦分割
- `bind - split-window -v`: Prefix + - で横分割
- `bind-key e/E setw synchronize-panes`: Prefix + e/E で全ペイン同期入力のON/OFF

## 5. ウィンドウ操作設定

```bash
## Vimのキーバインドでウィンドウを移動する
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+
## Vimのキーバインドを使用する
set-window-option -g mode-keys vi
```

### 詳細解説

- `bind -r C-h select-window -t :-`: Prefix + Ctrl+h で前のウィンドウに移動
- `bind -r C-l select-window -t :+`: Prefix + Ctrl+l で次のウィンドウに移動
- `set-window-option -g mode-keys vi`: ウィンドウモードでviキーバインドを使用

## 6. コピーモード設定

```bash
# 選択開始: v
bind -T copy-mode-vi v send -X begin-selection
# 行選択: V
bind -T copy-mode-vi V send -X select-line
# 矩形選択: C-v
bind -T copy-mode-vi C-v send -X rectangle-toggle
# ヤンク: y
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
# ペースト: C-p
bind-key -r P paste-buffer
```

### 詳細解説

#### 選択操作

- `bind -T copy-mode-vi v send -X begin-selection`
  - コピーモード（vi）で `v` キーを押すと選択開始
  - `-T copy-mode-vi`: copy-mode-viテーブルでのキーバインド
  - `send -X begin-selection`: 選択モード開始コマンドを送信

- `bind -T copy-mode-vi V send -X select-line`
  - `V` キーで行全体を選択
  - vimの行選択（Shift+v）と同じ動作

- `bind -T copy-mode-vi C-v send -X rectangle-toggle`
  - `Ctrl+v` で矩形選択モードの切り替え
  - ブロック選択が可能

#### コピー操作

- `bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"`
  - Enterキーでコピー実行
  - `copy-pipe-and-cancel`: 選択範囲をパイプしてコピーモード終了
  - `pbcopy`: macOSのクリップボードにコピー

- `bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"`
  - `y` キーでコピー実行（vim風のyank）
  - 同様にpbcopyでmacOSクリップボードに保存

- `bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"`
  - マウスドラッグ終了時に自動的にコピー
  - `MouseDragEnd1Pane`: 左マウスボタンのドラッグ終了イベント

#### ペースト操作

- `bind-key -r P paste-buffer`
  - Prefix + P でペースト
  - `-r`: リピート可能（Prefixを再入力せずに連続実行可能）
  - `paste-buffer`: tmuxの内部バッファからペースト

### macOS統合の特徴

すべてのコピー操作で `pbcopy` を使用することで、tmux内でコピーしたテキストがmacOSのシステムクリップボードに保存され、他のアプリケーション（Safari、Finder、テキストエディタなど）でも利用可能になります。

## キーバインド一覧

### 基本操作

- `Prefix + r`: 設定ファイル再読み込み
- `Prefix + |`: ペイン縦分割
- `Prefix + -`: ペイン横分割

### ペイン操作

- `Prefix + h/j/k/l`: ペイン移動（vim風）
- `Prefix + H/J/K/L`: ペインリサイズ
- `Prefix + e`: 全ペイン同期入力 ON
- `Prefix + E`: 全ペイン同期入力 OFF

### ウィンドウ操作

- `Prefix + Ctrl+h`: 前のウィンドウ
- `Prefix + Ctrl+l`: 次のウィンドウ

### コピーモード（Prefix + [ でコピーモード開始）

- `v`: 選択開始
- `V`: 行選択
- `Ctrl+v`: 矩形選択
- `y` または `Enter`: コピー
- `Prefix + P`: ペースト

このように設定されたtmuxは、vimユーザーにとって直感的で効率的な操作環境を提供します。
