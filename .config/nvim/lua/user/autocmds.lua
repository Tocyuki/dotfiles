-- lua/user/autocmds.lua

-- Terminal は自動で insert
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() vim.cmd("startinsert") end,
})

-- ClaudeCodeターミナルの異常終了を検知してクリーンアップ
-- WebSocketエラーなどでプロセスが終了した場合の処理
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function(args)
    local buf_name = vim.api.nvim_buf_get_name(args.buf)

    -- ClaudeCodeターミナルかチェック
    if buf_name:match("claudecode") or buf_name:match("ClaudeCode") then
      -- 終了コードを取得（0以外ならエラー）
      local exit_code = vim.v.event.status or 0

      if exit_code ~= 0 then
        -- エラー終了の場合は通知
        local has_snacks, snacks = pcall(require, "snacks")
        if has_snacks then
          snacks.notify.error(
            string.format("ClaudeCodeターミナルが異常終了しました (exit code: %d)", exit_code),
            { title = "ClaudeCode Error" }
          )
        else
          vim.notify(
            string.format("ClaudeCodeターミナルが異常終了しました (exit code: %d)", exit_code),
            vim.log.levels.ERROR
          )
        end

        -- エラーログを記録
        vim.api.nvim_err_writeln(string.format(
          "[ClaudeCode] Terminal exited with code %d. Buffer: %s",
          exit_code,
          buf_name
        ))
      end

      -- バッファのクリーンアップ（auto_closeがtrueでも明示的に実行）
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          -- バッファが他のウィンドウで使用されていないか確認
          local wins = vim.fn.win_findbuf(args.buf)
          if #wins == 0 then
            pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
          end
        end
      end, 100)
    end
  end,
})

-- ファイルの外部変更を自動検知してバッファを更新
-- FocusGained: ウィンドウがフォーカスを得た時
-- BufEnter: バッファに入った時
-- CursorHold: カーソルが一定時間（updatetime）動かなかった時
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold"}, {
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
    if vim.b.trim_trailing_whitespace == false then return end
    local ft = vim.bo.filetype
    local skip = {
      markdown = true,
      gitcommit = true,
      help = true,
      man = true,
      diff = true,
      mail = true,
      make = true,
      tex = true,
    }
    if skip[ft] then return end
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[keeppatterns %s/\s\+$//ge]])
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

-- スマートなバッファ削除: 複数ウィンドウならウィンドウを閉じる、単一ウィンドウなら次のバッファへ
local function smart_buffer_delete()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = get_real_buffers()

  -- 現在のタブページで通常のウィンドウが複数あるかチェック
  local normal_windows = vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].buftype == ""  -- 通常のバッファのみカウント
  end, vim.api.nvim_tabpage_list_wins(0))

  if #normal_windows > 1 then
    -- 複数ウィンドウがある場合は、ウィンドウを閉じる
    vim.cmd("close")
  else
    -- 単一ウィンドウの場合は、バッファを切り替えてから削除
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

-- 自動保存: ノーマルモードの変更は1秒デバウンス、InsertLeave/FocusLostは即保存
-- TextChanged: ノーマルモードでテキストが変更された時（u, p, x など）
-- FocusLost: ウィンドウからフォーカスが外れた時（即時保存）
local autosave_timers = {}
local AUTOSAVE_DELAY = 1000 -- 1秒後に保存
local TF_FORMAT_FLAG = "_terraform_preformatted"

local function try_save_buffer(buf)
  -- 保存可能な条件をチェック
  if vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].modified
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
    and vim.bo[buf].readonly == false
    and vim.fn.filewritable(vim.api.nvim_buf_get_name(buf)) == 1
  then
    -- Terraformは保存前にフォーマット（autosave時も適用）
    if vim.bo[buf].filetype == "terraform" then
      local formatted = false
      local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
      local clients = get_clients({ bufnr = buf })
      if #clients > 0 then
        local ok = pcall(function()
          vim.api.nvim_buf_call(buf, function()
            vim.lsp.buf.format({ async = false, bufnr = buf })
          end)
        end)
        formatted = ok
      end
      if formatted then
        pcall(vim.api.nvim_buf_set_var, buf, TF_FORMAT_FLAG, true)
      end
    end

    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! write")
    end)
  end
end

local function stop_autosave_timer(buf)
  if autosave_timers[buf] then
    vim.fn.timer_stop(autosave_timers[buf])
    autosave_timers[buf] = nil
  end
end

local function start_autosave_timer(buf)
  stop_autosave_timer(buf)
  autosave_timers[buf] = vim.fn.timer_start(AUTOSAVE_DELAY, function()
    vim.schedule(function()
      try_save_buffer(buf)
    end)
    autosave_timers[buf] = nil
  end)
end

vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged", "FocusLost"}, {
  callback = function(args)
    local buf = args.buf
    if not vim.api.nvim_buf_is_valid(buf) then return end

    -- FocusLost/InsertLeave は即時保存
    if args.event == "FocusLost" or args.event == "InsertLeave" then
      stop_autosave_timer(buf)
      try_save_buffer(buf)
      return
    end

    -- TextChanged はデバウンス付き
    start_autosave_timer(buf)
  end,
})

-- Terraformファイル保存前に自動フォーマット（LSP使用）
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.tf",
  callback = function()
    -- autosaveで事前にフォーマット済みならスキップ
    local formatted = false
    local ok, flag = pcall(vim.api.nvim_buf_get_var, 0, TF_FORMAT_FLAG)
    if ok and flag then
      formatted = true
      pcall(vim.api.nvim_buf_del_var, 0, TF_FORMAT_FLAG)
    end
    if formatted then return end

    -- LSPクライアントがアタッチされているかチェック
    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    local clients = get_clients({ bufnr = 0 })
    if #clients > 0 then
      vim.lsp.buf.format({ async = false })
    end
  end,
})
