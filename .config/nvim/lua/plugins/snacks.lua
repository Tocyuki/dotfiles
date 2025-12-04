-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- アニメーション機能の設定
    animate = {
      enabled = true,
      duration = 20, -- 20ms（高速でスムーズ）
      easing = "linear",
      fps = 60,
    },
    -- 通知システムの設定
    notifier = {
      enabled = true,
      timeout = 3000, -- 通知を表示する時間（ミリ秒）
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      style = "compact", -- "compact", "fancy", "minimal"
      top_down = true, -- 通知を上から下に表示
      icons = {
        error = "🚨",
        warn = "⚠️",
        info = "💡",
        debug = "🐛",
        trace = "🔍",
      },
    },

    -- ピッカーの設定（ファイル検索、grep、バッファ切り替えなど）
    picker = {
      enabled = true,
      sources = {
        -- ドットファイル・無視ファイルも対象にする
        files = { hidden = true, ignored = false },
        grep  = { hidden = true, ignored = false },
        explorer = { hidden = true, ignored = false },
      },
      layout = {
        preset = "default",
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
  },

  config = function(_, opts)
    local palette = {
      bg = "#1f1f28",
      bg_alt = "#2a2a37",
      border = "#2a2a37",
      select = "#223249",
      fg = "#dcd7ba",
    }

    -- 共通のハイライトグループを定義（nvim-cmp、snacks で共有）
    -- これにより、プラグインの読み込み順序に依存しない安定した色設定が可能になる
    vim.api.nvim_set_hl(0, "CmpNormal", { bg = palette.bg })
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = palette.border, bg = palette.bg })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = palette.select, fg = palette.fg, bold = true })
    vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = palette.bg })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = palette.border, bg = palette.bg })

    local snacks = require("snacks")
    snacks.setup(opts)
  end,

  keys = {
    -- ファイル検索
    { "<leader>f", function() require("snacks").picker.files() end, desc = "Find Files" },
    { "<leader>g", function() require("snacks").picker.git_files() end, desc = "Git Files" },
    { "<leader>s", function() require("snacks").picker.git_status() end, desc = "Git Status" },
    { "<leader>a", function() require("snacks").picker.grep() end, desc = "Grep" },

    -- バッファ・履歴
    { "<leader>b", function() require("snacks").picker.buffers() end, desc = "Buffers" },
    { "<leader>h", function() require("snacks").picker.recent() end, desc = "Recent Files" },
    { "<leader>l", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
    { "<leader>j", function() require("snacks").picker.jumps() end, desc = "Jump List" },

    -- Git
    { "<leader>c", function() require("snacks").picker.git_log() end, desc = "Git Commits" },

    -- Vim コマンド
    { "<leader>C", function() require("snacks").picker.commands() end, desc = "Commands" },
    { "<leader>H", function() require("snacks").picker.command_history() end, desc = "Command History" },

    -- 診断ピッカー
    { "<leader>d", function() require("snacks").picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>D", function() require("snacks").picker.diagnostics() end, desc = "Project Diagnostics" },

    -- 診断トグル
    { "<leader>td", function() require("snacks").toggle.diagnostics() end, desc = "Toggle Diagnostics" },

    -- 通知履歴
    { "<leader>nh", function() require("snacks").notifier.show_history() end, desc = "Notification History" },
    { "<leader>nd", function() require("snacks").notifier.hide() end, desc = "Dismiss Notifications" },
  },
}
