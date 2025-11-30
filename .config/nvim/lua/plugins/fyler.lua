-- fyler.nvim: ファイルシステムをバッファのように編集できるモダンなファイルマネージャー
-- https://github.com/A7Lavinraj/fyler.nvim
return {
  "A7Lavinraj/fyler.nvim",
  branch = "stable",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", function() require("fyler").toggle() end, mode = "n", desc = "Toggle Fyler" },
  },
  opts = {
    views = {
      finder = {
        default_explorer = true,
        follow_current_file = true,
        win = {
          kind = "split_left_most",
          kinds = {
            split_left_most = { width = "20%" },
          },
        },
      },
    },
  },
}
