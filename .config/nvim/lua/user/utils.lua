-- lua/user/utils.lua
local M = {}

-- 定数
M.DELAYS = {
  FOCUS_DELAY = 150,
  VISUAL_DELAY = 50,
}

-- ターミナルコマンドの共通処理
function M.create_terminal_with_autocmd(cmd_name)
  return function()
    vim.cmd("tab terminal " .. cmd_name)
    vim.api.nvim_create_autocmd("TermClose", {
      buffer = 0,
      once = true,
      callback = function()
        vim.cmd("bd!")
      end
    })
  end
end

-- ClaudeCodeウィンドウの検出（エラーハンドリング強化版）
function M.find_claudecode_window()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(current_tab)

  for _, win in ipairs(wins) do
    -- ウィンドウの有効性チェック
    if not vim.api.nvim_win_is_valid(win) then
      goto continue
    end

    local success, buf = pcall(vim.api.nvim_win_get_buf, win)
    if not success then
      -- バッファ取得エラーをログ
      vim.api.nvim_err_writeln(string.format("[ClaudeCode] Failed to get buffer for window %d", win))
      goto continue
    end

    -- バッファの有効性チェック
    if not vim.api.nvim_buf_is_valid(buf) then
      goto continue
    end

    local buf_type_success, buf_type = pcall(vim.api.nvim_buf_get_option, buf, 'buftype')
    if not buf_type_success then
      -- buftypeの取得エラーは通常発生しないが、念のためログ
      goto continue
    end

    if buf_type == 'terminal' then
      local name_success, buf_name = pcall(vim.api.nvim_buf_get_name, buf)
      if name_success then
        -- より厳密なClaudeCodeターミナルの判定
        if buf_name:match("claudecode") or buf_name:match("ClaudeCode") then
          return win
        end
      end
    end

    ::continue::
  end
  return nil
end

-- ClaudeCodeプロセスが実行中かチェック
function M.is_claudecode_running()
  local win = M.find_claudecode_window()
  if not win then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  -- ターミナルジョブが実行中かチェック
  local job_id = vim.b[buf].terminal_job_id
  if job_id then
    -- ジョブIDが有効かチェック（0 = 無効、1 = 有効）
    local job_status = vim.fn.jobwait({job_id}, 0)
    return job_status[1] == -1  -- -1 = まだ実行中
  end

  return false
end

-- ClaudeCodeを安全に再起動
function M.restart_claudecode()
  local claude_win = M.find_claudecode_window()

  -- 既存のウィンドウを閉じる
  if claude_win and vim.api.nvim_win_is_valid(claude_win) then
    pcall(vim.api.nvim_win_close, claude_win, false)
  end

  -- バッファのクリーンアップ（念のため）
  vim.defer_fn(function()
    local all_bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(all_bufs) do
      if vim.api.nvim_buf_is_valid(buf) then
        local success, buf_name = pcall(vim.api.nvim_buf_get_name, buf)
        if success and (buf_name:match("claudecode") or buf_name:match("ClaudeCode")) then
          local buf_type_success, buf_type = pcall(vim.api.nvim_buf_get_option, buf, 'buftype')
          if buf_type_success and buf_type == 'terminal' then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end
    end
  end, 100)

  -- 新しいClaudeCodeセッションを開始
  vim.defer_fn(function()
    local success, err = pcall(vim.cmd, "ClaudeCode")
    if not success then
      local has_snacks, snacks = pcall(require, "snacks")
      if has_snacks then
        snacks.notify.error(
          "ClaudeCodeの再起動に失敗しました: " .. tostring(err),
          { title = "ClaudeCode Restart Failed" }
        )
      else
        vim.notify(
          "ClaudeCodeの再起動に失敗しました: " .. tostring(err),
          vim.log.levels.ERROR
        )
      end
    end
  end, 200)
end

-- ClaudeCodeのトグル機能（エラーハンドリング強化版）
function M.toggle_claudecode()
  local claude_win = M.find_claudecode_window()

  if claude_win then
    -- ウィンドウを閉じる
    local success, err = pcall(vim.api.nvim_win_close, claude_win, false)
    if not success then
      -- 強制クローズを試行
      pcall(vim.api.nvim_win_close, claude_win, true)
      vim.api.nvim_err_writeln("[ClaudeCode] Failed to close window gracefully: " .. tostring(err))
    end
  else
    -- ClaudeCodeを開く
    local success, err = pcall(vim.cmd, "ClaudeCode")
    if not success then
      local has_snacks, snacks = pcall(require, "snacks")
      if has_snacks then
        snacks.notify.error(
          "ClaudeCodeの起動に失敗しました: " .. tostring(err),
          { title = "ClaudeCode Failed" }
        )
      else
        vim.notify(
          "ClaudeCodeの起動に失敗しました: " .. tostring(err),
          vim.log.levels.ERROR
        )
      end
    end
  end
end

-- 遅延付きでClaudeCodeにフォーカス（エラーハンドリング強化版）
function M.send_and_focus_claudecode()
  -- 選択範囲を送信
  local success, err = pcall(vim.cmd, "ClaudeCodeSend")
  if not success then
    local has_snacks, snacks = pcall(require, "snacks")
    if has_snacks then
      snacks.notify.error(
        "ClaudeCodeへの送信に失敗しました: " .. tostring(err),
        { title = "ClaudeCode Send Failed" }
      )
    else
      vim.notify(
        "ClaudeCodeへの送信に失敗しました: " .. tostring(err),
        vim.log.levels.ERROR
      )
    end
    return
  end

  -- フォーカス処理
  vim.defer_fn(function()
    -- ClaudeCodeウィンドウが存在するか確認
    local claude_win = M.find_claudecode_window()
    if not claude_win then
      vim.notify("ClaudeCodeウィンドウが見つかりません", vim.log.levels.WARN)
      return
    end

    local focus_success, focus_err = pcall(vim.cmd, "ClaudeCodeFocus")
    if not focus_success then
      -- フォーカスコマンドが失敗した場合、直接ウィンドウにフォーカス
      pcall(vim.api.nvim_set_current_win, claude_win)
    end
  end, M.DELAYS.FOCUS_DELAY)
end

-- エディタープラグイン用のユーティリティ
function M.hybrid_relative_path()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" then return "[No Name]" end

  local dir = vim.fn.fnamemodify(file, ":h")

  -- Git root を優先
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel")[1]
  if git_root and git_root ~= "" then
    local root_pat = "^" .. vim.pesc(vim.fn.fnamemodify(git_root, ":~:.") .. "/")
    return (vim.fn.fnamemodify(file, ":~:."):gsub(root_pat, ""))
  end

  -- LSP root を次に試す
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if #clients > 0 and clients[1].config and clients[1].config.root_dir then
    local lsp_root = clients[1].config.root_dir
    local root_pat = "^" .. vim.pesc(vim.fn.fnamemodify(lsp_root, ":~:.") .. "/")
    return (vim.fn.fnamemodify(file, ":~:."):gsub(root_pat, ""))
  end

  -- 最後にcwdを使用
  local cwd = vim.fn.getcwd()
  local root_pat = "^" .. vim.pesc(vim.fn.fnamemodify(cwd, ":~:.") .. "/")
  return (vim.fn.fnamemodify(file, ":~:."):gsub(root_pat, ""))
end

function M.setup_buffer_keymaps(callback)
  for i = 1, 10 do
    vim.keymap.set("n", "<Leader>"..i, callback(i), { silent = true })
  end
end

function M.setup_gitsigns_keymaps(bufnr, gs)
  local function m(mode, l, r, o)
    (o or {}).buffer = bufnr
    vim.keymap.set(mode, l, r, o or {})
  end

  -- Navigation
  m("n","]c", function()
    if vim.wo.diff then
      vim.cmd("normal ]c")
    else
      gs.next_hunk()
    end
  end)
  m("n","[c", function()
    if vim.wo.diff then
      vim.cmd("normal [c")
    else
      gs.prev_hunk()
    end
  end)

  -- Actions
  m("n","<leader>hs", gs.stage_hunk)
  m("n","<leader>hr", gs.reset_hunk)
  m("v","<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
  m("v","<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
  m("n","<leader>hS", gs.stage_buffer)
  m("n","<leader>hR", gs.reset_buffer)
  m("n","<leader>hp", gs.preview_hunk)
  m("n","<leader>hb", function() gs.blame_line({full=true}) end)
  m("n","<leader>hd", gs.diffthis)
  m("n","<leader>hD", function() gs.diffthis("~") end)
  m("n","<leader>hq", gs.setqflist)
  m("n","<leader>hQ", function() gs.setqflist("all") end)
  m("n","<leader>tb", gs.toggle_current_line_blame)
  m("n","<leader>tw", gs.toggle_word_diff)
  m({"o","x"}, "ih", gs.select_hunk)
end

return M
