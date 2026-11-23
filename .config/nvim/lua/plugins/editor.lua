-- lua/plugins/editor.lua
local utils = require('user.utils')

-- 定数
local DISABLED_FILETYPES = {
  "help","fyler","lazy","mason","Trouble","alpha","starter","dashboard",
  "gitcommit","gitrebase","checkhealth","notify","qf","toggleterm"
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
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "simeji/winresizer", event = "VeryLazy" },
  { "cespare/vim-toml",  ft = { "toml" } },
  { "google/vim-jsonnet", ft = { "jsonnet", "libsonnet" } },
  { "tpope/vim-surround", keys = { "cs","ds","ys" } },
  { "markonm/traces.vim", event = "VeryLazy" },
  { "vim-jp/vimdoc-ja",   lazy = true },

  -- Kanagawa テーマ
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        theme = "dragon", -- wave / dragon / lotus
        transparent = true,
        background = { dark = "dragon", light = "lotus" },
      })
    end,
  },

  -- Easymotion
  {
    "easymotion/vim-easymotion",
    keys = { "<Leader>m" },
    config = function()
      vim.api.nvim_set_keymap("n","<Leader>m","<Plug>(easymotion-overwin-f2)",{})
    end
  },

  -- mini.nvim（カーソル単語・末尾空白・括弧/クォート自動補完）
  {
    "echasnovski/mini.nvim",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.cursorword").setup({ delay = 500 })
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

  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
        tab_char = "╎",
      },
    },
  },

  -- bufferline.nvim
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    config = function()
      local colors = require("kanagawa.colors").setup({ theme = "dragon" })
      local palette = {
        bg = colors.palette.dragonBlack3,
        alt = colors.palette.dragonBlack4,
        fg = colors.palette.dragonWhite,
        muted = colors.palette.dragonGray3,
      }
      local separator_hl = { fg = palette.bg, bg = palette.bg }
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          offsets = {
            { filetype = "fyler", text = "Fyler File Explorer", highlight = "Directory", separator = true },
          },
          indicator = {
            icon = '▌',
          },
          modified_icon = '● ',
          left_trunc_marker = ' ',
          right_trunc_marker = ' ',
        },
        highlights = {
          fill = {
            bg = palette.bg,
          },
          background = {
            bg = palette.alt,
            fg = palette.muted,
          },
          buffer_visible = {
            bg = palette.alt,
            fg = palette.fg,
          },
          buffer_selected = {
            bg = palette.bg,
            fg = palette.fg,
            bold = true,
            italic = false,
          },
          separator = separator_hl,
          separator_visible = separator_hl,
          separator_selected = separator_hl,
          tab_separator = separator_hl,
          tab_separator_selected = separator_hl,
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
        current_line_blame = false,  -- デフォルトでオフ（<leader>tbでトグル可能）
        attach_to_untracked = true,
        watch_gitdir = { follow_files = true },
        update_debounce = 500,  -- CPU負荷軽減のため500msに設定
        on_attach = function(bufnr)
          vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { fg = "#ff6b6b" })
          vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#ff6b6b" })
          local gs = require("gitsigns")
          local function m(mode, l, r, o) (o or {}).buffer = bufnr; vim.keymap.set(mode,l,r,o or {}) end
          m("n","]c", function()
            if vim.wo.diff then
              vim.cmd("normal ]c")
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              gs.nav_hunk('next')
            end
          end)
          m("n","[c", function()
            if vim.wo.diff then
              vim.cmd("normal [c")
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              gs.nav_hunk('prev')
            end
          end)
          m("n","<leader>hs", gs.stage_hunk);      m("n","<leader>hr", gs.reset_hunk)
          m("v","<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
          m("v","<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
          m("n","<leader>hS", gs.stage_buffer);    m("n","<leader>hR", gs.reset_buffer)
          m("n","<leader>hp", gs.preview_hunk)
          m("n","<leader>hd", gs.diffthis);        m("n","<leader>hD", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            gs.diffthis("~")
          end)
          m("n","<leader>hq", gs.setqflist);       m("n","<leader>hQ", function()
            ---@diagnostic disable-next-line: param-type-mismatch
            gs.setqflist("all")
          end)
          m("n","<leader>tb", gs.toggle_current_line_blame)
          m("n","<leader>tw", gs.toggle_word_diff)
          m({"o","x"}, "ih", gs.select_hunk)
        end,
      })
    end
  },

  -- nvim-treesitter（シンタックスハイライトの安定化）
  -- main ブランチは Neovim 0.12+ と tree-sitter CLI が必要（どちらも aqua で管理）。
  -- ハイライト・インデントは自動では有効にならないため、FileType で有効化する。
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main は遅延読み込み非対応
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      local ts = require("nvim-treesitter")

      -- main で廃止された jsonc (json で代替) と tmux は除外
      ts.install({
        "bash", "c", "diff", "html", "javascript", "jsdoc", "json",
        "lua", "luadoc", "luap", "markdown", "markdown_inline", "python",
        "query", "regex", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
        "go", "gomod", "gosum", "hcl", "terraform",
      })

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      }
      local move_maps = {
        goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
        goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
        goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
      }

      -- 大規模ファイルではハイライトを無効化（パフォーマンス向上）
      local max_filesize = 100 * 1024 -- 100KB
      local function is_large(buf)
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        return ok and stats and stats.size > max_filesize
      end

      local function attach(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
          return
        end
        if not is_large(buf) then
          vim.treesitter.start(buf, lang)
        end
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- master 版と同様にバッファローカルで割り当て、ftplugin の ]] などより優先させる
        local sel = require("nvim-treesitter-textobjects.select")
        for key, query in pairs(select_maps) do
          vim.keymap.set({ "x", "o" }, key, function()
            sel.select_textobject(query, "textobjects")
          end, { buffer = buf, desc = "TS select " .. query })
        end
        local move = require("nvim-treesitter-textobjects.move")
        for fn, maps in pairs(move_maps) do
          for key, query in pairs(maps) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
              move[fn](query, "textobjects")
            end, { buffer = buf, desc = "TS " .. fn .. " " .. query })
          end
        end
      end

      -- master 版の auto_install 相当: 未導入のパーサーは開いた時にインストールする
      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not available[lang] then
            return
          end
          if vim.list_contains(ts.get_installed(), lang) then
            attach(args.buf, lang)
          else
            ts.install(lang):await(function(err)
              if not err then
                vim.schedule(function() attach(args.buf, lang) end)
              end
            end)
          end
        end,
      })
    end,
  },
}
