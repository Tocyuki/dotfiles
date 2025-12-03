-- TypeScript専用のLSPプラグイン設定
return {
  {
    "pmizio/typescript-tools.nvim",
    -- TypeScript/JavaScriptファイルを開いた時のみ読み込み
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig"
    },
    config = function()
      local ok, ts_tools = pcall(require, "typescript-tools")
      if not ok then
        vim.notify("typescript-tools.nvim が読み込めませんでした", vim.log.levels.ERROR)
        return
      end

      -- 既存のLSP設定と同じcapabilitiesを使用
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- 既存のLSP設定と同じon_attach関数をベースに、TypeScript専用コマンドを追加
      local on_attach = function(client, bufnr)
        -- 基本的なLSPキーマッピング（既存設定と同じ）
        local map = function(m, l, r, desc)
          local opts = { buffer = bufnr, silent = true }
          if desc then
            opts.desc = desc
          end
          vim.keymap.set(m, l, r, opts)
        end

        -- 標準LSPコマンド（gd, gr, rn, K, leader+q）は lsp.lua で定義済み

        -- TypeScript専用コマンド（<leader>ts* プレフィックス）
        map("n", "<leader>tso", "<cmd>TSToolsOrganizeImports<CR>", "Import整理")
        map("n", "<leader>tss", "<cmd>TSToolsSortImports<CR>", "Importソート")
        map("n", "<leader>tsu", "<cmd>TSToolsRemoveUnused<CR>", "未使用コード削除")
        map("n", "<leader>tsf", "<cmd>TSToolsFixAll<CR>", "すべて修正")
        map("n", "<leader>tsa", "<cmd>TSToolsAddMissingImports<CR>", "不足Importを追加")
        map("n", "<leader>tsi", "<cmd>TSToolsGoToSourceDefinition<CR>", "ソース定義へ")
        map("n", "<leader>tsr", "<cmd>TSToolsRenameFile<CR>", "ファイルリネーム")
        map("n", "<leader>tsF", "<cmd>TSToolsFileReferences<CR>", "ファイル参照を表示")

        -- LSPアタッチ時に診断を強制的に表示（既存設定と同じ）
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.show(nil, bufnr)
          end
        end, 100)
      end

      -- typescript-tools.nvimのセットアップ
      ts_tools.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          -- TypeScriptサーバーの設定
          separate_diagnostic_server = true,  -- 診断用サーバーを分離してパフォーマンス向上
          publish_diagnostic_on = "insert_leave",  -- 挿入モード終了時に診断を更新

          -- tsserver関連の設定
          expose_as_code_action = "all",  -- すべてのコードアクションを公開
          tsserver_path = nil,  -- nilの場合は自動検出
          tsserver_plugins = {},  -- 追加のtsserverプラグイン
          tsserver_max_memory = "auto",  -- メモリ制限（auto = 自動調整）

          -- 補完の設定
          complete_function_calls = true,  -- 関数呼び出しの補完
          include_completions_with_insert_text = true,  -- insertTextを含む補完

          -- コードレンズの設定
          code_lens = "off",  -- コードレンズ（implementations/references）の表示

          -- フォーマット設定（既存のフォーマッターと併用する場合はfalse）
          disable_member_code_lens = true,  -- メンバーのコードレンズを無効化

          -- TypeScriptサーバーのログレベル
          tsserver_logs = "off",  -- "off" | "terse" | "normal" | "verbose"

          -- JSX設定
          jsx_close_tag = {
            enable = false,  -- JSXタグの自動クローズ
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
        handlers = {
          -- TypeScript特有のハンドラーをカスタマイズ可能
          -- 例: 特定の診断をフィルタリング
        },
      })
    end,
  },
}
