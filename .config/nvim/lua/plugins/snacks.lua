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

    -- 診断ピッカーの設定
    picker = {
      enabled = true,
    },

    -- トグル機能の設定
    toggle = {
      enabled = true,
    },
  },

  config = function(_, opts)
    -- 共通のハイライトグループを定義（fzf、nvim-cmp、snacks で共有）
    -- これにより、プラグインの読み込み順序に依存しない安定した色設定が可能になる
    vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1a1b26" })
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#565f89", bg = "#1a1b26" })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = "#3d59a1", fg = "#c0caf5", bold = true })
    vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#1a1b26" })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#565f89", bg = "#1a1b26" })

    local snacks = require("snacks")
    snacks.setup(opts)

    -- 診断の自動通知機能
    -- エラーや警告が発生したときに通知を表示
    local notified_diagnostics = {}

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      group = vim.api.nvim_create_augroup("SnacksDiagnosticNotify", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local diagnostics = vim.diagnostic.get(bufnr, { severity = { min = vim.diagnostic.severity.WARN } })

        -- 新しい診断のみ通知（重複を避ける）
        for _, diagnostic in ipairs(diagnostics) do
          local key = string.format("%d:%d:%d:%s", bufnr, diagnostic.lnum, diagnostic.col, diagnostic.message)

          if not notified_diagnostics[key] then
            notified_diagnostics[key] = true

            -- 重大度に応じたレベルを設定
            local level = "info"
            local title = "INFO"
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              level = "error"
              title = "ERROR"
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
              level = "warn"
              title = "WARN"
            end

            -- ファイル名と行番号を含むメッセージ
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
            local line = diagnostic.lnum + 1
            local msg = string.format("%s:%d\n%s", filename, line, diagnostic.message)

            -- 通知を表示（同じバッファの診断は1つのグループにまとめる）
            vim.notify(msg, level, {
              id = "diagnostic_" .. bufnr,
              title = title,
              timeout = 5000,
            })

            -- 一定時間後にキャッシュをクリア（再通知を可能にする）
            vim.defer_fn(function()
              notified_diagnostics[key] = nil
            end, 30000) -- 30秒後

            -- 最初の診断のみ通知して、連続通知を防ぐ
            break
          end
        end
      end,
    })
  end,

  keys = {
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
