[![Test](https://github.com/Tocyuki/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/Tocyuki/dotfiles/actions/workflows/test.yml)
[![Actionlint](https://github.com/Tocyuki/dotfiles/actions/workflows/actionlint.yml/badge.svg)](https://github.com/Tocyuki/dotfiles/actions/workflows/actionlint.yml)

# dotfiles

My dotfiles

## Supported OS

- Mac

## Installation

```bash
git clone https://github.com/Tocyuki/dotfiles.git
cd dotfiles
make init
make deploy
```

## Usage

```bash
make help
```

### Android setup

`make deploy` または `make install-brew` で Android Studio をインストールします。
初回起動後、セットアップウィザードまたは SDK Manager で以下をインストールしてください。

- Android SDK Platform 35
- Android SDK Build-Tools 35.x
- Android SDK Platform-Tools
- Android Emulator
- Android SDK Command-line Tools

`targetSdkVersion=35` の Android プロジェクトでは Android SDK Platform 35 が必要です。

### Project navigation

`make deploy` または `make install-tools` で `ghq`, `roots`, `git-wt`, `fzf`, `zoxide` が利用できるようになります。

| Key / command | Description |
| --- | --- |
| `Ctrl-G` / `ghq-roots` | `ghq list --full-path \| roots \| fzf` で ghq 管理リポジトリと monorepo 内の root を選択して移動 |
| `Ctrl-X W` / `git-wt-cd` | `git-wt` の worktree 一覧から fzf で選択して移動 |
| `z` / `zi` | zoxide で履歴ベースにディレクトリ移動 |
| `gg` | `ghq get` |
| `gwt` / `gwtd` | `git wt` / `git wt -D` |

## Documentation

- [Neovim Plugin List](docs/neovim-plugin.md) - 使用しているプラグイン一覧と役割の説明
- [Neovim Usage Guide](docs/neovim-usage.md) - Neovimの設定とキーバインド完全ガイド
- [Neovim Git Operations](docs/neovim-git-operations.md) - Git操作のキーマッピングとコマンドガイド
- [Tmux Configuration](docs/tmux-configuration.md) - tmux設定の詳細解説とキーバインド一覧
