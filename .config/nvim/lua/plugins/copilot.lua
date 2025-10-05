-- lua/plugins/copilot.lua
return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Copilot設定
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      -- キーマッピング設定
      local keymap = vim.keymap.set

      -- Copilot候補の受け入れ
      keymap("i", "<C-g>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })

      -- 次の候補（Ctrl + j）
      keymap("i", "<C-j>", "<Plug>(copilot-next)")

      -- 前の候補（Ctrl + k）
      keymap("i", "<C-k>", "<Plug>(copilot-previous)")

      -- Copilotの候補を消去（Ctrl + x）
      keymap("i", "<C-x>", "<Plug>(copilot-dismiss)")

      -- Copilotを手動で呼び出す（Leader + cs）
      keymap("n", "<leader>ps", ":Copilot suggestion<CR>", { desc = "Copilot suggest" })

      -- パネルを開く
      keymap("n", "<leader>pp", ":Copilot panel<CR>", { desc = "Copilot panel" })

      -- 特定のファイルタイプでCopilotを無効化
      vim.g.copilot_filetypes = {
        ["*"] = true,
        xml = false,
        markdown = false,
      }

      -- Copilotの状態表示設定
      vim.b.copilot_enabled = true
    end,
  },
}
