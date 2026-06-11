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
      if not ok_m then return end

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
          "gopls",
          "gh_actions_ls",
          "nginx_language_server",
          "ansiblels",
          "jsonnet_ls",
          "bashls",
          "marksman",
          "html",
          "cssls",
          "sqlls",
          "vimls",
        },
      })

      -- LSP診断の設定
      vim.diagnostic.config({
        -- 診断の更新タイミング
        update_in_insert = false, -- 挿入モード中は更新しない（パフォーマンス向上）

        -- 仮想テキスト（行末に表示されるエラーメッセージ）
        virtual_text = {
          spacing = 4,
          source = "if_many", -- 複数のソースがある場合はソース名を表示
          prefix = "●", -- アイコン
          -- severity.minを削除してすべての診断を表示（ERROR, WARN, INFO, HINT全て）
        },

        -- サイン列（左端のアイコン）
        signs = {
          -- severity.minを削除してすべての診断を表示
          priority = 10, -- gitsigns (6) より高く設定し、診断（error/warning等）を優先表示
          text = {
            [vim.diagnostic.severity.ERROR] = "🔴",
            [vim.diagnostic.severity.WARN] = "⚠️",
            [vim.diagnostic.severity.INFO] = "ℹ️",
            [vim.diagnostic.severity.HINT] = "💡",
          },
        },

        -- フロートウィンドウ（必要に応じて手動で開く診断詳細）
        -- snacks.nvimで統一されたスタイルで表示
        float = {
          border = "rounded",
          source = "always", -- ソース名を常に表示（例: [lua_ls]）
          header = "", -- ヘッダーをカスタマイズ可能
          format = function(diagnostic)
            return string.format(
              "[%s] %s",
              diagnostic.source or "diagnostic",
              diagnostic.message
            )
          end,
          -- snacks.nvimで定義したハイライトグループで視覚的統一
          winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder",
          focusable = true, -- フロートウィンドウをフォーカス可能にする
          scope = "cursor", -- カーソル位置の診断を表示
          max_width = 80,
          max_height = 20,
        },

        -- アンダーライン（すべての診断を表示）
        underline = true,

        -- 重大度の順序（エラーを最優先で表示）
        severity_sort = true,
      })

      -- 診断が変更されたときに強制的に再表示（deprecated含む）
      vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = vim.api.nvim_create_augroup("LspDiagnosticRefresh", { clear = true }),
        callback = function(args)
          vim.diagnostic.show(nil, args.buf)
        end,
      })

      -- LSPフロートウィンドウのハンドラーをsnacks.nvimで統一
      local function create_lsp_float_handler(opts)
        return function(_, result, ctx, config)
          config = config or {}
          config.focus_id = ctx.method

          local lines = opts.get_lines(result)
          if not lines or vim.tbl_isempty(lines) then return end

          local win = require("snacks").win({
            width = math.min(80, vim.o.columns - 4),
            height = opts.get_height(lines),
            border = "rounded",
            title = opts.title,
            ft = "markdown",
            wo = {
              winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder",
              wrap = true,
              linebreak = true,
              conceallevel = 3,
            },
            on_buf = function(self)
              vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
              vim.bo[self.buf].modifiable = false
              vim.keymap.set("n", "q", function() self:hide() end, { buffer = self.buf })
              vim.keymap.set("n", "<Esc>", function() self:hide() end, { buffer = self.buf })
            end,
          })
          return win.buf, win.win
        end
      end

      vim.lsp.handlers["textDocument/hover"] = create_lsp_float_handler({
        title = " Hover ",
        get_lines = function(result)
          if not (result and result.contents) then return nil end
          local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
          return vim.lsp.util.trim_empty_lines(lines)
        end,
        get_height = function(lines) return math.min(#lines + 2, math.floor(vim.o.lines * 0.5)) end,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = create_lsp_float_handler({
        title = " Signature ",
        get_lines = function(result)
          if not (result and result.signatures and #result.signatures > 0) then return nil end
          local lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result)
          return vim.lsp.util.trim_empty_lines(lines)
        end,
        get_height = function(lines) return math.min(#lines + 2, 10) end,
      })

      local on_attach = function(_, bufnr)
        local map = function(m,l,r,desc) vim.keymap.set(m,l,r,{buffer=bufnr,silent=true,desc=desc}) end
        map("n","gd", vim.lsp.buf.definition, "Go to definition")
        map("n","gr", vim.lsp.buf.references, "List references")
        map("n","K", vim.lsp.buf.hover, "Show hover")
        map("n","rn", vim.lsp.buf.rename, "Rename symbol")
        map("n","<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n","<leader>q", vim.diagnostic.setloclist, "Diagnostics to location list")

        -- LSPアタッチ時に診断を強制的に表示
        require("user.utils").show_diagnostics_deferred(bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local function setup_server(server, opts)
        vim.lsp.config(server, vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, opts or {}))
        vim.lsp.enable(server)
      end

      local function setup_default(server)
        setup_server(server)
      end

      local function setup_lua_ls()
        setup_server("lua_ls", {
          settings = {
            Lua = {
              runtime = {
                -- Neovim の Lua ランタイムバージョンを指定
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { "vim" }
              },
              workspace = {
                -- Neovim のランタイムファイルを認識させる
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
              },
              telemetry = {
                enable = false,
              },
            }
          },
        })
      end

      local function setup_terraformls()
        setup_server("terraformls", {
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
        auto_update = false,  -- 安定性のため自動更新を無効化
        run_on_start = false,  -- 起動時の自動実行を無効化（手動で:MasonToolsUpdate）
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

      -- 補完メニューのハイライト設定
      -- CmpNormal, CmpBorder, CmpSel などのハイライトグループは
      -- snacks.nvim (plugins/snacks.lua) で一元的に定義されています
      -- これにより fzf、nvim-cmp、snacks で統一された UI が実現されます

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
          ["<C-e>"]     = cmp.mapping.abort(),  -- 補完をキャンセル
          ["<Esc>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.abort()
            else
              fallback()
            end
          end, { "i", "s" }),
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
