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

      -- ファイルタイプ設定
      vim.filetype.add({
        extension = {
          tf = 'terraform',
          tfvars = 'terraform',
          jsonnet = 'jsonnet',
          libsonnet = 'jsonnet',
        },
      })

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
          "pyright",
          "ts_ls",
          "gopls",
          "gh_actions_ls",
          "nginx_language_server",
          "ansiblels",
          "jsonnet_ls",
        },
      })

      -- LSP診断の設定
      vim.diagnostic.config({
        float = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      })

      local on_attach = function(_, bufnr)
        local map = function(m,l,r) vim.keymap.set(m,l,r,{buffer=bufnr,silent=true}) end
        map("n","gd", vim.lsp.buf.definition)
        map("n","gr", vim.lsp.buf.references)
        map("n","rn", vim.lsp.buf.rename)
        map("n","K", vim.diagnostic.open_float)
        map("n","<leader>q", vim.diagnostic.setloclist)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local function setup_default(server)
        lsp[server].setup({ on_attach = on_attach, capabilities = capabilities })
      end

      local function setup_lua_ls()
        lsp.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }
              },
              workspace = {
                checkThirdParty = false
              }
            }
          },
        })
      end

      local function setup_terraformls()
        lsp.terraformls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            terraformls = {
              experimentalFeatures = {
                validateOnSave = true,
                prefillRequiredFields = true,
              },
              validation = {
                enableEnhancedValidation = true,
              },
              indexing = {
                ignorePaths = {
                  ".terraform/**",
                  "**/.terraform/**",
                }
              },
            },
            terraform = {
              validation = {
                enableEnhancedValidation = true,
              },
              format = {
                enable = true,
                ignoreExtensionsOnCompletion = true,
              },
              logging = {
                level = "warn",
              },
            },
          },
        })
      end

      if type(mlsp.setup_handlers) == "function" then
        mlsp.setup_handlers({
          function(server) setup_default(server) end,
          ["lua_ls"] = setup_lua_ls,
          ["terraformls"] = setup_terraformls,
        })
      else
        for _, server in ipairs(mlsp.get_installed_servers()) do
          if server == "lua_ls" then
            setup_lua_ls()
          elseif server == "terraformls" then
            setup_terraformls()
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
          "eslint_d", "ruff", "golangci-lint", "tflint",
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
      vim.o.pumblend = 20  -- 補完ウィンドウの透過度 (0-100)
      vim.o.winblend = 20  -- フローティングウィンドウの透過度 (0-100)

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
            winblend = 15,
            col_offset = -3,
            side_padding = 1,
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
            winblend = 15,
          },
        },
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
