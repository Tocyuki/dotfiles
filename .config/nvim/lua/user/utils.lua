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

-- ClaudeCodeウィンドウの検出
function M.find_claudecode_window()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(current_tab)

  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local success, buf_type = pcall(vim.api.nvim_buf_get_option, buf, 'buftype')

    if success and buf_type == 'terminal' then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      -- より厳密なClaudeCodeターミナルの判定
      if buf_name:match("claudecode") or buf_name:match("ClaudeCode") then
        return win
      end
    end
  end
  return nil
end

-- ClaudeCodeのトグル機能
function M.toggle_claudecode()
  local claude_win = M.find_claudecode_window()

  if claude_win then
    vim.api.nvim_win_close(claude_win, false)
  else
    vim.cmd("ClaudeCode")
  end
end

-- 遅延付きでClaudeCodeにフォーカス
function M.send_and_focus_claudecode()
  vim.cmd("ClaudeCodeSend")
  vim.defer_fn(function()
    vim.cmd("ClaudeCodeFocus")
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
