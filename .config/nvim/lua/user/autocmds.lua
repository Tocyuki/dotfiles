-- lua/user/autocmds.lua

-- Terminal は自動で insert
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() vim.cmd("startinsert") end,
})

-- ファイルの外部変更を自動検知してバッファを更新
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd("checktime")
    end
  end,
})

-- Terraformファイル保存後に自動フォーマット
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tf",
  callback = function()
    local file = vim.fn.expand("%:p")

    -- シェル環境でterraformコマンドを実行（tfenv対応）
    local shell_cmd = string.format("cd %s && terraform fmt %s 2>&1",
      vim.fn.shellescape(vim.fn.expand("%:p:h")),
      vim.fn.shellescape(vim.fn.expand("%:t")))

    local result = vim.fn.system(shell_cmd)

    if vim.v.shell_error == 0 then
      -- フォーマット成功時はファイルを再読み込み
      vim.cmd("checktime")
    else
      -- エラーが発生した場合は通知（ただし、tfenvの警告は無視）
      if not string.match(result, "tfenv") then
        vim.notify("terraform fmt failed: " .. result, vim.log.levels.ERROR)
      end
    end
  end,
})

