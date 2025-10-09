-- lua/user/autocmds.lua

-- Terminal は自動で insert
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() vim.cmd("startinsert") end,
})

-- ファイルの外部変更を自動検知してバッファを更新（フォーカス時のみ、CPU負荷軽減）
vim.api.nvim_create_autocmd({"FocusGained"}, {
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd("checktime")
    end
  end,
})

-- ファイル保存時に行末の空白を自動削除
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//ge]])
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})

-- バッファ管理: 空のバッファの自動作成/削除
local function is_empty_buffer(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buflisted
    and vim.api.nvim_buf_get_name(buf) == ""
    and not vim.bo[buf].modified
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] == ""
end

local function get_real_buffers()
  return vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
  end, vim.api.nvim_list_bufs())
end

-- スマートなバッファ削除: 次のバッファをアクティブにしてから削除
local function smart_buffer_delete()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = get_real_buffers()

  -- 現在のバッファ以外の通常バッファを探す
  local other_buffers = vim.tbl_filter(function(buf)
    return buf ~= current_buf
  end, buffers)

  if #other_buffers > 0 then
    -- 他のバッファがあれば、次のバッファに切り替えてから削除
    vim.cmd("bnext")
    vim.api.nvim_buf_delete(current_buf, { force = false })
  else
    -- 他のバッファがなければ、空のバッファを作成してから削除
    vim.cmd("enew")
    if vim.api.nvim_buf_is_valid(current_buf) then
      vim.api.nvim_buf_delete(current_buf, { force = false })
    end
  end
end

-- コマンドとして登録
vim.api.nvim_create_user_command("Bdelete", smart_buffer_delete, { desc = "Delete buffer smartly" })
vim.api.nvim_create_user_command("Bd", smart_buffer_delete, { desc = "Delete buffer smartly" })

-- 最後のバッファが閉じられた時に空のバッファを作成（フォールバック）
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    vim.schedule(function()
      if #get_real_buffers() == 0 then
        vim.cmd("enew")
      end
    end)
  end,
})

-- ファイルを開いた時に空のバッファを置き換え/削除
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()

    if vim.api.nvim_buf_get_name(current_buf) ~= "" and vim.bo[current_buf].buftype == "" then
      vim.defer_fn(function()
        -- 空のバッファを持つウィンドウを探して置き換え
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if win ~= current_win then
            local buf = vim.api.nvim_win_get_buf(win)
            if is_empty_buffer(buf) then
              -- 空のバッファのウィンドウで新しいファイルを開く
              vim.api.nvim_win_set_buf(win, current_buf)
              -- 元の空のバッファを削除
              pcall(vim.api.nvim_buf_delete, buf, { force = false })
              return
            end
          end
        end

        -- 空のバッファがウィンドウに表示されていない場合は単純に削除
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf ~= current_buf and is_empty_buffer(buf) then
            local buf_wins = vim.fn.win_findbuf(buf)
            if #buf_wins == 0 then
              pcall(vim.api.nvim_buf_delete, buf, { force = false })
            end
          end
        end
      end, 50)
    end
  end,
})

-- Terraformファイル保存後に自動フォーマット
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tf",
  callback = function()
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

