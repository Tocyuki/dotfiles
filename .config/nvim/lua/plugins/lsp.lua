-- lua/plugins/lsp.lua
return {
  -- mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function() require("mason").setup({}) end
  },
  { "williamboman/mason-lspconfig.nvim", lazy = true },

  -- lspconfig
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
          "gh_actions_ls",
          "nginx_language_server",
        },
      })

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

  -- ツール自動インストール（linters/formatters）
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier", "black", "isort", "gofumpt", "goimports", "terraform_fmt",
          -- Linters
          "eslint_d", "ruff", "golangci-lint",
        },
        auto_update = true,
        run_on_start = true,
      })
    end
  },

  -- nvim-cmp（補完）
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      vim.o.completeopt = "menu,menuone,noselect"
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
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
}
