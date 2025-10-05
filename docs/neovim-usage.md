# Neovim 使用方法

このドキュメントでは、dotfilesのNeovim設定でのキーバインドと主要機能について説明します。

## LSP機能

**プラグイン**: [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim)

### 定義ジャンプ・コード操作

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `gd` | 定義にジャンプ | カーソル下のシンボルの定義場所にジャンプ |
| `gr` | 参照を表示 | シンボルが使用されている場所を一覧表示 |
| `rn` | 名前変更 | シンボルの名前を一括変更 |
| `K` | 診断情報表示 | エラーや警告の詳細をフロート表示 |
| `<leader>q` | 診断リスト | 診断情報をロケーションリストに表示 |

### Diagnostics/Warningナビゲーション

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `]d` | 次の診断へ | 次のエラー/警告箇所に移動 (標準機能) |
| `[d` | 前の診断へ | 前のエラー/警告箇所に移動 (標準機能) |
| `]e` | 次のエラーへ | エラー（ERROR）のみに移動 |
| `[e` | 前のエラーへ | エラー（ERROR）のみに移動 |
| `]w` | 次の警告へ | 警告（WARN）のみに移動 |
| `[w` | 前の警告へ | 警告（WARN）のみに移動 |

### 補完機能

**プラグイン**: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip)

| キーバインド | 機能 | モード |
|-------------|------|-------|
| `<C-Space>` | 補完を開始 | Insert |
| `<CR>` | 補完を確定 | Insert |
| `<C-n>` / `<C-p>` | 補完候補選択 | Insert |
| `<Tab>` / `<S-Tab>` | スニペット展開・移動 | Insert |

## エディタ操作

### 基本操作

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<Leader>k` | バッファを閉じる | 現在のバッファを削除 |
| `<Leader>w` | ファイル保存 | 現在のファイルを保存 |
| `<Leader>r` | 置換モード | カーソル下の単語を置換 |
| `<Esc><Esc>` | 検索ハイライト解除 | 検索結果のハイライトを消す |

### ウィンドウ操作

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<C-h/j/k/l>` | ウィンドウ移動 | 各方向のウィンドウに移動 |
| `vs` | 垂直分割 | ウィンドウを垂直に分割 |
| `ss` | 水平分割 | ウィンドウを水平に分割 |

### ターミナル

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `;lg` | Lazygit起動 | 新しいタブでLazygitを開く |
| `;ld` | Lazydocker起動 | 新しいタブでLazydockerを開く |
| `<Leader>;f` | ターミナルから戻る | ターミナルモードから前のウィンドウに戻る |

## ファイラー・ナビゲーション

### Neo-tree（ファイルツリー）

**プラグイン**: [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<leader>e` | ツリー表示切り替え | ファイルツリーの表示/非表示 |
| `<leader>o` | ツリーにフォーカス | ファイルツリーにカーソル移動 |
| `l` | ファイル・フォルダを開く | Neo-tree内でのファイル開く |

### FZF（ファジーファインダー）

**プラグイン**: [fzf.vim](https://github.com/junegunn/fzf.vim)

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<Leader>f` | ファイル検索 | プロジェクト内ファイル検索 |
| `<Leader>g` | Git管理ファイル検索 | Gitで管理されているファイルを検索 |
| `<Leader>s` | Git変更ファイル検索 | Git変更があるファイルを検索 |
| `<Leader>b` | バッファ一覧 | 開いているバッファ一覧 |
| `<Leader>a` | 文字列検索 | Ripgrepによる文字列検索 |
| `<Leader>c` | コミット履歴 | Gitコミット履歴表示 |
| `<Leader>h` | ファイル履歴 | 最近開いたファイル履歴 |
| `<Leader>H` | コマンド履歴 | 実行コマンド履歴 |
| `<Leader>l` | 行内検索 | 開いているファイル内の行検索 |
| `<Leader>C` | コマンド一覧 | 利用可能なコマンド一覧 |

## バッファライン

**プラグイン**: [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

### バッファ操作

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<Leader>1-9` | バッファ移動 | 指定番号のバッファに移動 |
| `<C-n>` / `<C-p>` | 次/前のバッファ | バッファを順次切り替え |

## Git操作

### Gitsigns

**プラグイン**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `]c` / `[c` | 次/前の変更箇所 | Git差分の変更箇所間を移動 |
| `<leader>hs` | 変更をステージ | カーソル行またはビジュアル選択範囲をステージ |
| `<leader>hr` | 変更を戻す | カーソル行またはビジュアル選択範囲の変更を破棄 |
| `<leader>hS` | ファイル全体をステージ | 現在のファイル全体をステージ |
| `<leader>hR` | ファイル全体を戻す | 現在のファイル全体の変更を破棄 |
| `<leader>hp` | 変更をプレビュー | 変更内容をフロート表示 |
| `<leader>hb` | ブレーム表示 | Git blameを表示 |
| `<leader>hd` | 差分表示 | 変更差分を表示 |
| `<leader>hq` | 変更リスト | 変更箇所をQuickfixリストに表示 |
| `<leader>tb` | ブレーム切り替え | 行ごとのGit blameの表示切り替え |
| `<leader>tw` | 単語差分切り替え | 単語レベルの差分表示切り替え |
| `ih` | 変更ハンクを選択 | テキストオブジェクトとして変更ハンクを選択 |

### Git記号の意味

#### ファイルツリー（Neo-tree）
- `` - 追加されたファイル
- `` - 変更されたファイル
- `` - 削除されたファイル
- `󰁕` - 名前変更されたファイル
- `` - 未追跡ファイル
- `` - 無視されたファイル
- `󰄱` - ステージされていない変更
- `` - ステージされた変更
- `` - コンフリクトファイル

#### Gutter（行番号横）
- `▌` - 行の追加・変更・未追跡
- `▁` - 行の削除
- `▔` - ファイル先頭行の削除
- `~` - 変更と削除が同時に発生

## EasyMotion

**プラグイン**: [vim-easymotion](https://github.com/easymotion/vim-easymotion)

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<Leader>m` | 2文字ジャンプ | 画面内の任意の場所に素早くジャンプ |

## その他の機能

### mini.nvim

**プラグイン**: [mini.nvim](https://github.com/echasnovski/mini.nvim)

- **カーソル単語ハイライト**: 同じ単語を自動ハイライト
- **インデント可視化**: インデントレベルを縦線で表示
- **末尾空白表示**: 行末の不要な空白を可視化
- **自動括弧補完**: 括弧やクォートの自動補完

### 設定されたLSPサーバー

- **lua_ls** - Lua
- **jsonls** - JSON
- **yamlls** - YAML
- **dockerls** - Docker
- **docker_compose_language_service** - Docker Compose
- **terraformls** - Terraform
- **pyright** - Python
- **ts_ls** - TypeScript/JavaScript
- **gopls** - Go
- **gh_actions_ls** - GitHub Actions
- **nginx_language_server** - Nginx
- **ansiblels** - Ansible

## カスタムコマンド

**プラグイン**: [mini.nvim](https://github.com/echasnovski/mini.nvim) (mini.trailspace)

| コマンド | 機能 | 説明 |
|---------|------|------|
| `:Trim` | 末尾空白削除 | ファイル内の行末空白を一括削除 |

## GitHub Copilot

**プラグイン**: [copilot.vim](https://github.com/github/copilot.vim)

### キーバインド

| キーバインド | 機能 | モード | 説明 |
|-------------|------|--------|------|
| `<C-g>` | 候補を受け入れ | Insert | Copilotの提案を受け入れる |
| `<C-j>` | 次の候補 | Insert | 次の提案候補を表示 |
| `<C-k>` | 前の候補 | Insert | 前の提案候補を表示 |
| `<C-x>` | 候補を消去 | Insert | 表示されている提案を消去 |
| `<leader>ps` | 手動呼び出し | Normal | Copilotの提案を手動で呼び出す |
| `<leader>pp` | パネルを開く | Normal | Copilotパネルを開く |

### 無効化されているファイルタイプ

- XML
- Markdown

## ClaudeCode連携

**プラグイン**: [claudecode.nvim](https://github.com/coder/claudecode.nvim)

### キーバインド

| キーバインド | 機能 | 説明 |
|-------------|------|------|
| `<Leader>;c` | ClaudeCode起動 | ClaudeCodeを開く |
| `<Leader>;t` | ClaudeCodeトグル | ClaudeCodeの表示/非表示を切り替え |
| `<Leader>;a` | 変更を受け入れ | ClaudeCodeの変更を受け入れる |
| `<Leader>;d` | 変更を拒否 | ClaudeCodeの変更を拒否する |
| `<Leader>;l` | 選択範囲送信 | ビジュアル選択範囲をClaudeCodeに送信してフォーカス |

### ユーティリティ関数

設定ファイル内でClaudeCode用のユーティリティ関数も定義されています：

- **ウィンドウ検出**: ClaudeCodeターミナルの自動検出
- **トグル機能**: ClaudeCodeの表示/非表示切り替え
- **フォーカス制御**: 送信後の自動フォーカス移動（150ms遅延）
- **自動クローズ**: 差分受け入れ時の自動クローズ機能
