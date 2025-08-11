-- =========================================
-- 基本設定 / キーマップ
-- =========================================
vim.g.mapleader = " "
vim.o.helplang = "ja"
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("desert")

-- desert 背景に合わせて主要BGを統一（透明化対策）
local function apply_bg_from_normal()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local bg = hl.bg or 0x000000
  vim.o.winblend, vim.o.pumblend = 0, 0
  for _, name in ipairs({
    "Normal","NormalNC","SignColumn","FoldColumn","LineNr",
    "EndOfBuffer","StatusLineNC","TabLineFill","NormalFloat","FloatBorder","Pmenu",
  }) do vim.api.nvim_set_hl(0, name, { bg = bg }) end
end
vim.api.nvim_create_autocmd({ "VimEnter","ColorScheme" }, { callback = apply_bg_from_normal })
apply_bg_from_normal()

-- 文字コード/見た目/基本挙動
vim.scriptencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.fileencodings = "ucs-boms,utf-8,euc-jp,cp932"
vim.o.fileformats = "unix,dos,mac"
vim.o.ambiwidth = "single"
vim.opt.clipboard:append("unnamed")
vim.opt.signcolumn = "yes"
vim.o.updatetime = 300
vim.o.mouse = "a"
vim.o.scrolloff = 5
vim.o.autoread = true
vim.o.hidden = true
vim.o.formatoptions = "lmoq"
vim.o.number = true
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.laststatus = 2
vim.o.showtabline = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.shell = "/bin/zsh"
vim.o.shellcmdflag = "-lc"

-- 便利オートコマンド
vim.api.nvim_create_autocmd("BufWritePre", { pattern="*", command=[[%s/\s\+$//e]] })
vim.api.nvim_create_autocmd("TermOpen", { callback=function() vim.cmd("startinsert") end })

-- キーマップ
local map = vim.keymap.set
map("n","<Leader>k", ":bd<CR>")
map("n","<Leader>w", ":w<CR>")
map("n","<Leader>r", ":%s;\\<<C-r><C-w>\\>;g<Left><Left>;")
map("n","<Esc><Esc>", ":set nohlsearch!<CR>")
map("n",";lg", ":tab terminal lazygit<CR>")
map("n",";ld", ":tab terminal lazydocker<CR>")
map("n","<C-h>", "<C-w>h"); map("n","<C-j>", "<C-w>j")
map("n","<C-k>", "<C-w>k"); map("n","<C-l>", "<C-w>l")
map("n","vs", ":vsplit<CR>"); map("n","ss", ":split<CR>")

-- =========================================
-- bootstrap: lazy.nvim
-- =========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================================
-- Plugins by lazy.nvim
-- =========================================
require("lazy").setup({
  -- Lua基盤
  { "nvim-lua/plenary.nvim", lazy=true },
  { "MunifTanjim/nui.nvim", lazy=true },
  { "nvim-tree/nvim-web-devicons", lazy=true },
  { "simeji/winresizer", event="VeryLazy" },
  { "cespare/vim-toml", ft={ "toml" } },
  { "tpope/vim-surround", keys={"cs","ds","ys"} },
  { "markonm/traces.vim", event="VeryLazy" }, -- リアルタイムで置換結果をプレビュー
  { "vim-jp/vimdoc-ja", lazy=true },
  { "easymotion/vim-easymotion", keys = { "<Leader>m" }, config=function()
      vim.api.nvim_set_keymap("n","<Leader>m","<Plug>(easymotion-overwin-f2)",{})
    end
  },

  -- mini.nvim
  {
    "echasnovski/mini.nvim",
    version = false,                         -- 常に最新（安定版が良ければ tag を指定）
    event = { "BufReadPost", "BufNewFile" }, -- 普段使いの遅延読み込み
    config = function()
      -- 1) カーソル下の単語を薄くハイライト
      require("mini.cursorword").setup({
        delay = 200, -- 反応速度（ms）
      })

      -- 2) インデントの可視化（現在ブロックをガイド）
      require("mini.indentscope").setup({
        symbol = "│",
        draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() },
        options = { try_as_border = true },
      })
      -- 不要なバッファでは無効化（ツリー/ダッシュボード/ヘルプなど）
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help","neo-tree","lazy","mason","Trouble","alpha","starter","dashboard",
          "fzf","gitcommit","gitrebase","checkhealth","notify","qf","toggleterm"
        },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
      -- インデントガイドの色を薄いグレーに
      local function set_indent_color()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#666666", nocombine = true })
      end
      set_indent_color()
      -- colorscheme を変えた時も色が戻らないように再適用
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_indent_color,
      })

      -- 3) 行末スペースの可視化＆トリム
      require("mini.trailspace").setup()
      -- 保存時に自動トリム
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function() require("mini.trailspace").trim() end,
      })
      -- 手動でトリムするコマンドも用意
      vim.api.nvim_create_user_command("Trim", function()
        require("mini.trailspace").trim()
      end, { desc = "Trim trailing whitespace" })

      -- 4) mini.pairs: 括弧/クォートの自動補完
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
      })
    end,
  },

  -- fzf
  {
    "junegunn/fzf",
    build = function() vim.fn["fzf#install"]() end
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    cmd = { "Files","GFiles","Buffers","Rg","History","Commits","Commands","Lines" },
    keys = {
      { "<Leader>b", ":Buffers<CR>", mode="n" },
      { "<Leader>C", ":Commands<CR>", mode="n" },
      { "<Leader>c", ":Commits<CR>", mode="n" },
      { "<Leader>h", ":History<CR>", mode="n" },
      { "<Leader>H", ":History:<CR>", mode="n" },
      { "<Leader>f", ":Files<CR>", mode="n" },
      { "<Leader>g", ":GFiles<CR>", mode="n" },
      { "<Leader>s", ":GFiles?<CR>", mode="n" },
      { "<Leader>l", ":Lines<CR>", mode="n" },
      { "<Leader>a", "<cmd>Rg<CR>", mode="n", desc="Ripgrep" },
    },
  },

  -- bufferline.nvim
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- タブではなくバッファ表示
          numbers = "none", -- バッファ番号非表示（番号ジャンプしたい場合は "ordinal"）
          diagnostics = "nvim_lsp", -- LSP 診断結果を表示
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant", -- "slant" | "padded_slant" | "thick" | "thin"
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "neo-tree", -- Neo-tree を開いたときにずらす
              text = "File Explorer",
              highlight = "Directory",
              separator = true
            }
          },
        },
      })

      for i = 1, 10 do
        vim.keymap.set("n", "<Leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", { silent = true })
      end
      vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
      vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
    end,
  },

  -- ステータスライン lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- 相対パスをハイブリッドで表示（Git > LSP > CWD）
      local function hybrid_relative_path()
        local buf  = vim.api.nvim_get_current_buf()
        local file = vim.api.nvim_buf_get_name(buf)
        if file == "" then return "[No Name]" end

        -- 1) Git ルート
        local dir = vim.fn.fnamemodify(file, ":h")
        local git_root = vim.fn.systemlist(
          "git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel"
        )[1]
        if git_root and git_root ~= "" then
          local root_pat = "^" .. vim.pesc(vim.fn.fnamemodify(git_root, ":~:.") .. "/")
          return (vim.fn.fnamemodify(file, ":~:."):gsub(root_pat, ""))
        end

        -- 2) LSP ルート
        local clients = vim.lsp.get_active_clients({ bufnr = buf })
        if #clients > 0 and clients[1].config and clients[1].config.root_dir then
          local lsp_root = clients[1].config.root_dir
          local root_pat = "^" .. vim.pesc(vim.fn.fnamemodify(lsp_root, ":~:.") .. "/")
          return (vim.fn.fnamemodify(file, ":~:."):gsub(root_pat, ""))
        end

        -- 3) CWD ルート
        local cwd = vim.fn.getcwd()
        local root_pat = "^" .. vim.pesc(vim.fn.fnamemodify(cwd, ":~:.") .. "/")
        return (vim.fn.fnamemodify(file, ":~:."):gsub(root_pat, ""))
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          disabled_filetypes = { statusline = {}, winbar = {} },
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000, tabline = 1000, winbar = 1000,
            refresh_time = 16,
            events = {
              "WinEnter","BufEnter","BufWritePost","SessionLoadPost",
              "FileChangedShellPost","VimResized","Filetype",
              "CursorMoved","CursorMovedI","ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { hybrid_relative_path },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { hybrid_relative_path },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },

  -- Neo-tree
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
        filesystem = {
          filtered_items = { hide_dotfiles = false },
          follow_current_file = true,
          group_empty_dirs = true,
        },
        default_component_configs = {
          git_status = {
            symbols = {
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
          }
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
        signs = {
          add          = { text = "┃" },
          change       = { text = "┃" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
        signcolumn = true,
        numhl = true,
        linehl = false,
        word_diff = false,
        watch_gitdir = { follow_files = true },
        on_attach = function(bufnr)
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

  -- LSP: mason / mason-lspconfig / lspconfig
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function() require("mason").setup({}) end
  },
  { "williamboman/mason-lspconfig.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre","BufNewFile" },
    dependencies = { "williamboman/mason.nvim","williamboman/mason-lspconfig.nvim" },
    config = function()
      local ok_m, mlsp = pcall(require, "mason-lspconfig")
      local ok_l, lsp  = pcall(require, "lspconfig")
      if not (ok_m and ok_l) then return end

      -- LSP Server
      mlsp.setup({
        automatic_installation = true,
        ensure_installed = {
          "lua_ls",
          "jsonls",
          "yamlls",
          "dockerls",
          "docker_compose_language_service",
          "terraformls",
          "tflint",
          "pyright",
          "ts_ls",
          "gopls",
          "lua_ls",
          "gh_actions_ls",
          "nginx_language_server",
        },
      })

      -- Linters / Formatters
      local ok_mti, mti = pcall(require, "mason-tool-installer")
      if ok_mti then
        mti.setup({
          ensure_installed = {
            -- Formatters
            "prettier",      -- JS/TS/JSON/YAML など
            "black",         -- Python
            "isort",         -- Python import sort
            "gofumpt",       -- Go format
            "goimports",     -- Go imports fix
            "terraform_fmt", -- Terraform fmt

            -- Linters
            "eslint_d",      -- JS/TS linter (高速)
            "ruff",        -- Python
            "golangci-lint", -- Go
          },
          auto_update = true,
          run_on_start = true,
        })
      end

      local on_attach = function(_, bufnr)
        local map = function(m,l,r) vim.keymap.set(m,l,r,{buffer=bufnr,silent=true}) end
        map("n","gd", vim.lsp.buf.definition)
        map("n","K",  vim.lsp.buf.hover)
        map("n","gr", vim.lsp.buf.references)
        map("n","rn", vim.lsp.buf.rename)
      end
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local function setup_default(server)
        lsp[server].setup({ on_attach = on_attach, capabilities = capabilities })
      end

      if type(mlsp.setup_handlers) == "function" then
        mlsp.setup_handlers({
          function(server) setup_default(server) end,
          ["lua_ls"] = function()
            lsp.lua_ls.setup({
              on_attach = on_attach,
              settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty=false } } },
            })
          end,
        })
      else
        for _, server in ipairs(mlsp.get_installed_servers()) do
          if server == "lua_ls" then
            lsp.lua_ls.setup({
              on_attach = on_attach,
              settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty=false } } },
            })
          else
            setup_default(server)
          end
        end
      end
    end
  },
  -- nvim-cmp (LSP補完 UI) 一式
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- 挿入モードになったら読み込む
    dependencies = {
      -- LSP補完ソース
      "hrsh7th/cmp-nvim-lsp",
      -- バッファ内単語補完
      "hrsh7th/cmp-buffer",
      -- パス補完
      "hrsh7th/cmp-path",
      -- スニペットエンジン
      "L3MON4D3/LuaSnip",
      -- スニペット補完ソース
      "saadparwaiz1/cmp_luasnip",
      -- VSCode形式のスニペット集
      "rafamadriz/friendly-snippets",
    },
    config = function()
      vim.o.completeopt = "menu,menuone,noselect"

      -- LuaSnip 設定
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- nvim-cmp 設定
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
})

