-- ~/.config/nvim/lua/plugins/claudecode.lua
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- Server Configuration
    port_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = "info", -- "trace", "debug", "info", "warn", "error"
    terminal_cmd = nil, -- Custom terminal command (default: "claude")
                        -- For local installations: "~/.claude/local/claude"
                        -- For native binary: use output from 'which claude'

    -- Selection Tracking
    track_selection = true,
    visual_demotion_delay_ms = 50,

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
      keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
    },
  },
  keys = {
    { "<Leader>;c", "<cmd>ClaudeCode<cr>", desc = "Open ClaudeCode" },
    {
      "<Leader>;t",
      function()
        -- 既存のClaudeCodeウィンドウをチェック
        local current_tab = vim.api.nvim_get_current_tabpage()
        local wins = vim.api.nvim_tabpage_list_wins(current_tab)
        local claude_win = nil

        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          local success, buf_type = pcall(vim.api.nvim_buf_get_option, buf, 'buftype')

          if success and buf_type == 'terminal' then
            local buf_name = vim.api.nvim_buf_get_name(buf)
            -- ClaudeCodeのターミナルかどうかをチェック
            if string.match(buf_name:lower(), "claude") then
              claude_win = win
              break
            end
          end
        end

        if claude_win then
          -- ClaudeCodeウィンドウが見つかった場合は閉じる
          vim.api.nvim_win_close(claude_win, false)
        else
          -- ClaudeCodeウィンドウが見つからない場合は開く
          vim.cmd("ClaudeCode")
        end
      end,
      desc = "Toggle ClaudeCode"
    },
    { "<Leader>;a", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept ClaudeCode Changing" },
    { "<Leader>;d", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny ClaudeCode Changing" },
    {
      "<Leader>;l",
      function()
        vim.cmd("ClaudeCodeSend")
        vim.defer_fn(function()
          vim.cmd("ClaudeCodeFocus")
        end, 150)
      end,
      mode = "v",
      desc = "Send Selection to ClaudeCode then focus",
    },
  },
}
