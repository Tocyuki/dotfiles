-- ~/.config/nvim/lua/plugins/claudecode.lua
local utils = require("user.utils")

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- Server Configuration
    port_range = { min = 10000, max = 65535 },
    auto_start = true,

    -- Logging Configuration
    -- "trace": 詳細なデバッグ情報（WebSocketエラーの詳細を含む）- DEBUGメッセージが表示される
    -- "debug": 開発時のデバッグ情報
    -- "info": 通常の情報レベル（推奨）- エラーと重要な情報のみ表示
    -- "warn": 警告のみ
    -- "error": エラーのみ
    -- トラブルシューティング時のみ "trace" に変更してください
    log_level = "info", -- 通常運用時は "info" を推奨（DEBUGメッセージを非表示）

    terminal_cmd = nil, -- Custom terminal command (default: "claude")
                        -- For local installations: "~/.claude/local/claude"
                        -- For native binary: use output from 'which claude'

    -- Selection Tracking
    -- ビジュアルモードでの選択を自動追跡
    track_selection = true,
    visual_demotion_delay_ms = utils.DELAYS.VISUAL_DELAY,

    -- Terminal Configuration
    terminal = {
      split_side = "right", -- "left" or "right"
      split_width_percentage = 0.30,
      provider = "auto", -- "auto", "snacks", "native", "external", or custom provider table

      -- auto_close: ターミナルプロセス終了時に自動でウィンドウを閉じる
      -- WebSocketエラー時の自動クリーンアップに重要
      auto_close = true,

      snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()`

      -- Provider-specific options
      provider_opts = {
        external_terminal_cmd = nil, -- Command template for external terminal provider
      },
    },

    -- Diff Integration
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
      keep_terminal_focus = false,
    },
  },

  keys = {
    -- 基本操作
    { "<Leader>;c", "<cmd>ClaudeCode<cr>", desc = "Open ClaudeCode" },
    { "<Leader>;t", utils.toggle_claudecode, desc = "Toggle ClaudeCode" },

    -- Diff操作（差分の承認・拒否）
    { "<Leader>;a", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept ClaudeCode Diff" },
    { "<Leader>;d", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny ClaudeCode Diff" },

    -- コンテキスト送信
    { "<Leader>;l", utils.send_and_focus_claudecode, mode = "v", desc = "Send Selection to Claude" },
  },
}
