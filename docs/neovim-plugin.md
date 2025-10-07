# Neovim プラグイン一覧

このドキュメントでは、dotfilesで使用している全Neovimプラグインとその役割を説明します。

## 目次

- [プラグイン管理](#プラグイン管理)
- [LSP・補完](#lsp補完)
- [AI支援](#ai支援)
- [ファイラー・ナビゲーション](#ファイラーナビゲーション)
- [Git連携](#git連携)
- [UI・見た目](#ui見た目)
- [エディタ機能強化](#エディタ機能強化)
- [シンタックス・言語サポート](#シンタックス言語サポート)

---

## プラグイン管理

### lazy.nvim
- **リポジトリ**: [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- **役割**: プラグインマネージャー
- **説明**: 高速なプラグインマネージャー。遅延ロード機能により起動速度を最適化

---

## LSP・補完

### nvim-lspconfig
- **リポジトリ**: [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- **役割**: LSPクライアント設定
- **説明**: Language Server Protocolの設定を簡単に行うための公式プラグイン
- **対応言語**: Lua, JSON, YAML, Docker, Terraform, Python, TypeScript, Go, Bash, Markdown, HTML, CSS, SQL, Vim, Nginx, Ansible, Jsonnet

### mason.nvim
- **リポジトリ**: [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- **役割**: LSPサーバー・ツールインストーラー
- **説明**: LSPサーバー、DAP、リンター、フォーマッターを簡単にインストール・管理

### mason-lspconfig.nvim
- **リポジトリ**: [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- **役割**: masonとlspconfigの連携
- **説明**: masonでインストールしたLSPサーバーを自動的にlspconfigに設定

### mason-tool-installer.nvim
- **リポジトリ**: [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)
- **役割**: リンター・フォーマッター自動インストール
- **説明**: 必要なツールを自動的にインストール・更新
- **対応ツール**: prettier, black, isort, gofumpt, goimports, terraform_fmt, eslint_d, ruff, golangci-lint, tflint

### nvim-cmp
- **リポジトリ**: [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- **役割**: 補完エンジン
- **説明**: 高機能な補完プラグイン。LSP、スニペット、バッファなど複数のソースに対応

### cmp-nvim-lsp
- **リポジトリ**: [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- **役割**: LSP補完ソース
- **説明**: nvim-cmp用のLSP補完ソース

### cmp-buffer
- **リポジトリ**: [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- **役割**: バッファ補完ソース
- **説明**: 現在のバッファからの補完候補を提供

### cmp-path
- **リポジトリ**: [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)
- **役割**: パス補完ソース
- **説明**: ファイルパスの補完候補を提供

### LuaSnip
- **リポジトリ**: [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **役割**: スニペットエンジン
- **説明**: Lua製の高速なスニペットエンジン

### cmp_luasnip
- **リポジトリ**: [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- **役割**: スニペット補完ソース
- **説明**: nvim-cmp用のLuaSnipスニペット補完ソース

### friendly-snippets
- **リポジトリ**: [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- **役割**: スニペット集
- **説明**: 様々な言語用のスニペットコレクション

---

## AI支援

### copilot.vim
- **リポジトリ**: [github/copilot.vim](https://github.com/github/copilot.vim)
- **役割**: GitHub Copilot連携
- **説明**: AIによるコード補完。リアルタイムでコード提案
- **無効化**: XML, Markdown

### cmp-copilot
- **リポジトリ**: [hrsh7th/cmp-copilot](https://github.com/hrsh7th/cmp-copilot)
- **役割**: Copilot補完ソース
- **説明**: nvim-cmp用のGitHub Copilot補完ソース

### claudecode.nvim
- **リポジトリ**: [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim)
- **役割**: Claude Code連携
- **説明**: Neovim内でClaude Codeを使用。コードレビュー、リファクタリング、質問対応
- **機能**: 差分表示、変更受け入れ/拒否、選択範囲送信

---

## ファイラー・ナビゲーション

### neo-tree.nvim
- **リポジトリ**: [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- **役割**: ファイルエクスプローラー
- **説明**: モダンなファイルツリー。Git連携、LSP診断表示、ライブ更新機能

### fzf
- **リポジトリ**: [junegunn/fzf](https://github.com/junegunn/fzf)
- **役割**: ファジーファインダー（コア）
- **説明**: 高速なファジー検索ツール

### fzf.vim
- **リポジトリ**: [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
- **役割**: fzf Vim連携
- **説明**: ファイル検索、バッファ検索、Git検索、文字列検索など多機能

### vim-easymotion
- **リポジトリ**: [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)
- **役割**: 高速移動
- **説明**: 画面内の任意の場所に2文字入力で素早くジャンプ

---

## Git連携

### gitsigns.nvim
- **リポジトリ**: [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- **役割**: Git差分表示・操作
- **説明**: 行番号横にGit差分を表示。変更のステージ・リセット、hunk操作、blame表示

### gx.nvim
- **リポジトリ**: [chrishrb/gx.nvim](https://github.com/chrishrb/gx.nvim)
- **役割**: URL/リンクオープン
- **説明**: カーソル下のURLをブラウザで開く。マウスダブルクリック対応

---

## UI・見た目

### tokyonight.nvim
- **リポジトリ**: [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- **役割**: カラースキーム
- **説明**: 高品質なダークテーマ（night style）。透過背景対応

### bufferline.nvim
- **リポジトリ**: [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- **役割**: バッファライン表示
- **説明**: タブ風のバッファ一覧表示。LSP診断、Git連携対応

### lualine.nvim
- **リポジトリ**: [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **役割**: ステータスライン
- **説明**: カスタマイズ可能なステータスライン。モード、ブランチ、差分、診断情報を表示

### indent-blankline.nvim
- **リポジトリ**: [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- **役割**: インデント可視化
- **説明**: インデントレベルを縦線で表示

### nvim-web-devicons
- **リポジトリ**: [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- **役割**: アイコン表示
- **説明**: ファイルタイプ別のアイコン表示（Nerd Font必須）

---

## エディタ機能強化

### mini.nvim
- **リポジトリ**: [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim)
- **役割**: 多機能ユーティリティ集
- **説明**: 複数のミニプラグインを統合
- **使用モジュール**:
  - `mini.cursorword`: カーソル下の単語を自動ハイライト
  - `mini.trailspace`: 行末の空白を可視化・削除
  - `mini.pairs`: 括弧・クォートの自動補完

### vim-surround
- **リポジトリ**: [tpope/vim-surround](https://github.com/tpope/vim-surround)
- **役割**: 囲み文字操作
- **説明**: 括弧、クォート、タグなどの囲み文字を簡単に変更・削除・追加

### traces.vim
- **リポジトリ**: [markonm/traces.vim](https://github.com/markonm/traces.vim)
- **役割**: コマンドプレビュー
- **説明**: 置換コマンド（`:s`）などをリアルタイムプレビュー

### winresizer
- **リポジトリ**: [simeji/winresizer](https://github.com/simeji/winresizer)
- **役割**: ウィンドウサイズ変更
- **説明**: ウィンドウサイズを簡単に調整

---

## シンタックス・言語サポート

### vim-toml
- **リポジトリ**: [cespare/vim-toml](https://github.com/cespare/vim-toml)
- **役割**: TOML構文サポート
- **説明**: TOMLファイルのシンタックスハイライト

### vim-jsonnet
- **リポジトリ**: [google/vim-jsonnet](https://github.com/google/vim-jsonnet)
- **役割**: Jsonnet構文サポート
- **説明**: Jsonnet/Libsonnetファイルのシンタックスハイライト

### vimdoc-ja
- **リポジトリ**: [vim-jp/vimdoc-ja](https://github.com/vim-jp/vimdoc-ja)
- **役割**: 日本語ヘルプ
- **説明**: Vimのヘルプドキュメントの日本語翻訳

---

## 依存ライブラリ

### plenary.nvim
- **リポジトリ**: [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- **役割**: Luaユーティリティライブラリ
- **説明**: 多くのプラグインが依存する基本的なLua関数を提供

### nui.nvim
- **リポジトリ**: [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- **役割**: UI コンポーネントライブラリ
- **説明**: ポップアップ、入力ボックスなどのUIコンポーネントを提供

### snacks.nvim
- **リポジトリ**: [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- **役割**: ターミナル・通知ライブラリ
- **説明**: ClaudeCodeで使用するターミナル機能を提供

---

## プラグイン設定ファイル

プラグイン設定は以下のファイルに分割して管理されています：

- [`.config/nvim/lua/plugins/lsp.lua`](../.config/nvim/lua/plugins/lsp.lua) - LSP、補完関連
- [`.config/nvim/lua/plugins/editor.lua`](../.config/nvim/lua/plugins/editor.lua) - エディタ、UI、Git関連
- [`.config/nvim/lua/plugins/copilot.lua`](../.config/nvim/lua/plugins/copilot.lua) - GitHub Copilot設定
- [`.config/nvim/lua/plugins/claudecode.lua`](../.config/nvim/lua/plugins/claudecode.lua) - Claude Code設定

---

## プラグイン数

**合計**: 約35プラグイン

カテゴリ別:
- LSP・補完: 13プラグイン
- AI支援: 3プラグイン
- ファイラー・ナビゲーション: 4プラグイン
- Git連携: 2プラグイン
- UI・見た目: 5プラグイン
- エディタ機能強化: 4プラグイン
- シンタックス: 3プラグイン
- 依存ライブラリ: 3プラグイン