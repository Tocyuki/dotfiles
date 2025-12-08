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
    local colors = require("kanagawa.colors").setup({ theme = "dragon" })
    local palette = colors.palette

    -- 共通のハイライトグループを定義（nvim-cmp、snacks で共有）
    -- これにより、プラグインの読み込み順序に依存しない安定した色設定が可能になる
    vim.api.nvim_set_hl(0, "CmpNormal", { bg = palette.dragonBlack3 })
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = palette.dragonBlack4, bg = palette.dragonBlack3 })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = palette.dragonBlack4, fg = palette.dragonYellow, bold = true })
    vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = palette.dragonBlack3 })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = palette.dragonBlack4, bg = palette.dragonBlack3 })

    local snacks = require("snacks")
    snacks.setup(opts)
  end,

  keys = {
    -- ファイル検索
    { "<C-f>", function() require("snacks").picker.files() end, desc = "Find Files" },
    { "gf",    function() require("snacks").picker.git_files() end, desc = "Git Files" },
    { "gs",    function() require("snacks").picker.git_status() end, desc = "Git Status" },
    { "gb",    function() require("snacks").git.blame_line() end, desc = "Git Blame Line" },
    { "go",    function() require("snacks").gitbrowse.open() end, desc = "Git Open in Browser" },
    { "ga",    function() require("snacks").picker.grep() end, desc = "Grep" },
    { "gl",    function() require("snacks").terminal.open({ "lazygit" }) end, desc = "LazyGit (Snacks Terminal)" },

    -- バッファ・履歴
    { "<leader>b", function() require("snacks").picker.buffers() end, desc = "Buffers" },
    { "<leader>l", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
    { "<leader>j", function() require("snacks").picker.jumps() end, desc = "Jump List" },

    -- Git
    { "<leader>c", function() require("snacks").picker.git_log() end, desc = "Git Commits" },

    -- 診断ピッカー
    { "<leader>d", function() require("snacks").picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
  },
}
