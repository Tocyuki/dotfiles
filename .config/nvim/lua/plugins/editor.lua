-- lua/plugins/editor.lua
local utils = require('user.utils')

-- 定数
local DISABLED_FILETYPES = {
  "help","neo-tree","lazy","mason","Trouble","alpha","starter","dashboard",
  "fzf","gitcommit","gitrebase","checkhealth","notify","qf","toggleterm"
}

local GIT_SYMBOLS = {
  added     = "",
  modified  = "",
  deleted   = "",
  renamed   = "󰁕",
  untracked = "",
  ignored   = "",
  unstaged  = "󰄱",
  staged    = "",
  conflict  = "",
}

local GITSIGNS_SYMBOLS = {
  add          = { text = "▌" },
  change       = { text = "▌" },
  delete       = { text = "▁" },
  topdelete    = { text = "▔" },
  changedelete = { text = "~" },
  untracked    = { text = "▌" },
}

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim",  lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "simeji/winresizer", event = "VeryLazy" },
  { "cespare/vim-toml",  ft = { "toml" } },
  { "tpope/vim-surround", keys = { "cs","ds","ys" } },
  { "markonm/traces.vim", event = "VeryLazy" },
  { "vim-jp/vimdoc-ja",   lazy = true },

  -- Easymotion
  {
    "easymotion/vim-easymotion",
    keys = { "<Leader>m" },
    config = function()
      vim.api.nvim_set_keymap("n","<Leader>m","<Plug>(easymotion-overwin-f2)",{})
    end
  },

  -- mini.nvim（カーソル単語・インデント可視化・末尾空白・括弧/クォート自動補完）
  {
    "echasnovski/mini.nvim",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.cursorword").setup({ delay = 200 })
      require("mini.indentscope").setup({
        symbol = "│",
        draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() },
        options = { try_as_border = true },
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = DISABLED_FILETYPES,
        callback = function() vim.b.miniindentscope_disable = true end,
      })
      require("mini.trailspace").setup()
      vim.api.nvim_create_user_command("Trim", function()
        require("mini.trailspace").trim()
      end, { desc = "Trim trailing whitespace" })
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
      })
    end,
  },

  -- fzf
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    cmd = { "Files","GFiles","Buffers","Rg","History","Commits","Commands","Lines" },
    keys = {
      { "<Leader>b", ":Buffers<CR>",  mode="n" },
      { "<Leader>C", ":Commands<CR>", mode="n" },
      { "<Leader>c", ":Commits<CR>",  mode="n" },
      { "<Leader>h", ":History<CR>",  mode="n" },
      { "<Leader>H", ":History:<CR>", mode="n" },
      { "<Leader>f", ":Files<CR>",    mode="n" },
      { "<Leader>g", ":GFiles<CR>",   mode="n" },
      { "<Leader>s", ":GFiles?<CR>",  mode="n" },
      { "<Leader>l", ":Lines<CR>",    mode="n" },
      { "<Leader>a", "<cmd>Rg<CR>",   mode="n", desc="Ripgrep" },
    },
  },

  -- bufferline.nvim
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
          always_show_bufferline = true,
          offsets = {
            { filetype = "neo-tree", text = "File Explorer", highlight = "Directory", separator = true },
          },
        },
      })
      utils.setup_buffer_keymaps(function(i)
        return "<Cmd>BufferLineGoToBuffer "..i.."<CR>"
      end)
      vim.keymap.set("n","<C-n>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
      vim.keymap.set("n","<C-p>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
    end,
  },

  -- lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          disabled_filetypes   = { statusline = {}, winbar = {} },
          globalstatus = false,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { utils.hybrid_relative_path },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { utils.hybrid_relative_path },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  -- neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    keys = {
      { "<leader>e", ":Neotree toggle<CR>", mode="n" },
      { "<leader>o", ":Neotree focus<CR>",  mode="n" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local ok, neotree = pcall(require, "neo-tree")
      if not ok then return end
      neotree.setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
          mappings = {
            ["l"] = "open",
          }
        },
        filesystem = {
          mappings = {
            ["l"] = "open",
          },
          filtered_items = { hide_dotfiles = false },
          follow_current_file = { enabled = true }, -- v3 仕様
          group_empty_dirs = true,
        },
        default_component_configs = {
          git_status = { GIT_SYMBOLS }
        }
      })
    end
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        sign_priority = 6,
        signs = GITSIGNS_SYMBOLS,
        signcolumn = true,
        numhl = true,
        linehl = false,
        word_diff = false,
        current_line_blame = true,
        attach_to_untracked = true,
        watch_gitdir = { follow_files = true },
        on_attach = function(bufnr)
          vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { fg = "#ff6b6b" })
          vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#ff6b6b" })
          local gs = require("gitsigns")
          local function m(mode, l, r, o) (o or {}).buffer = bufnr; vim.keymap.set(mode,l,r,o or {}) end
          m("n","]c", function() if vim.wo.diff then vim.cmd("normal ]c") else gs.next_hunk() end end)
          m("n","[c", function() if vim.wo.diff then vim.cmd("normal [c") else gs.prev_hunk() end end)
          m("n","<leader>hs", gs.stage_hunk);      m("n","<leader>hr", gs.reset_hunk)
          m("v","<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
          m("v","<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
          m("n","<leader>hS", gs.stage_buffer);    m("n","<leader>hR", gs.reset_buffer)
          m("n","<leader>hp", gs.preview_hunk);    m("n","<leader>hb", function() gs.blame_line({full=true}) end)
          m("n","<leader>hd", gs.diffthis);        m("n","<leader>hD", function() gs.diffthis("~") end)
          m("n","<leader>hq", gs.setqflist);       m("n","<leader>hQ", function() gs.setqflist("all") end)
          m("n","<leader>tb", gs.toggle_current_line_blame)
          m("n","<leader>tw", gs.toggle_word_diff)
          m({"o","x"}, "ih", gs.select_hunk)
        end,
      })
    end
  },
}

