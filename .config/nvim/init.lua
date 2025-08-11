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

  -- 置き換え: もとのVimプラグイン群
  { "bronson/vim-trailing-whitespace", event="BufReadPost" },
  { "simeji/winresizer", event="VeryLazy" },
  { "jiangmiao/auto-pairs", event="InsertEnter" },
  { "cespare/vim-toml", ft={ "toml" } },
  { "tpope/vim-surround", keys={"cs","ds","ys"} },
  { "markonm/traces.vim", event="VeryLazy" },
  { "vim-jp/vimdoc-ja", lazy=true },
  { "easymotion/vim-easymotion", keys = { "<Leader>m" }, config=function()
      vim.api.nvim_set_keymap("n","<Leader>m","<Plug>(easymotion-overwin-f2)",{})
    end
  },
  -- fzf
  {
    "junegunn/fzf",
    build = function() vim.fn["fzf#install"]() end
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
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
      { "<Leader>a", ":Ag<CR>", mode="n" },
    },
  },

  -- ステータスライン lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- アイコン用
    config = function()
      require("lualine").setup({
        options = {
          cons_enabled = true,
          theme = "auto",
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {},
        },
      })
    end,
  },

  -- emmet / endwise / json / fugitive / terraform / devicons
  { "mattn/emmet-vim", ft = { "html","css","javascript","typescript","vue","tsx","jsx" },
    init=function()
      vim.g.user_emmet_expandabbr_key = "<c-e>"
      vim.g.user_emmet_settings = { variables = { lang = "ja" } }
    end
  },
  { "tpope/vim-endwise", event="InsertEnter" },
  { "elzr/vim-json", ft={ "json" }, init=function()
      vim.g.vim_json_syntax_conceal = 0
    end
  },
  { "tpope/vim-fugitive", cmd={ "G","Git","Gblame","Gread","Gwrite","Gdiffsplit" },
    config=function()
      vim.keymap.set("n","[fugitive]r", ":Gread<CR>", { silent=true })
      vim.keymap.set("n","[fugitive]b", ":Gblame<CR>", { silent=true })
      vim.keymap.set("n","<C-g>", "[fugitive]", {})
    end
  },
  { "hashivim/vim-terraform", ft={ "terraform","tf","tfvars" },
    init=function()
      vim.g.terraform_align = 1
      vim.g.terraform_fmt_on_save = 1
      vim.g.terraform_binary_path = "/usr/local/bin/terraform"
    end
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

      mlsp.setup({
        automatic_installation = true,
        -- ensure_installed = { "lua_ls","jsonls","yamlls" },
      })

      local on_attach = function(_, bufnr)
        local map = function(m,l,r) vim.keymap.set(m,l,r,{buffer=bufnr,silent=true}) end
        map("n","gd", vim.lsp.buf.definition)
        map("n","K",  vim.lsp.buf.hover)
        map("n","gr", vim.lsp.buf.references)
        map("n","rn", vim.lsp.buf.rename)
      end
      local capabilities = vim.lsp.protocol.make_client_capabilities()

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
})

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

