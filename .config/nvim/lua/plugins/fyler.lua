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
  -- stable ブランチの設定形式 (views.finder.* は廃止され、トップレベルに移動した)
  opts = {
    use_as_default_explorer = true,
    follow_current_file = true,
    kind = "split_left_most",
    kind_presets = {
      split_left_most = { width = "15%" },
    },
    -- アイコンは既定で無効になったため、明示的に nvim-web-devicons を指定する
    integrations = {
      icon = "nvim_web_devicons",
    },
    -- git の状態表示
    extensions = {
      git = { enabled = true },
    },
    -- ドットファイルも表示する（g. で切り替え）
    ui = {
      hidden_items = {
        switches = {},
      },
    },
  },
}
