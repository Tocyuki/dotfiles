-- ~/.config/nvim/lua/plugins/claudecode.lua
local utils = require("user.utils")

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- Server Configuration
    port_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = "info", -- "trace" for debugging, "info" for normal use
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
