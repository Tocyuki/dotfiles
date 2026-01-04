local wezterm = require("wezterm")
local act = wezterm.action

-- キーバインド設定
local keys = {
	-- タブ操作
	{
		key = "t",
		mods = "CMD",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "CMD",
		action = act.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "n",
		mods = "CMD",
		action = act.SpawnCommandInNewWindow({}),
	},
	-- ペイン分割
	{
		key = "|",
		mods = "CMD|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CMD",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- ペイン移動
	{
		key = "h",
		mods = "CMD|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CMD|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CMD|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CMD|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	-- ペインサイズ調整
	{
		key = "H",
		mods = "CMD|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "CMD|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "CMD|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "CMD|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	-- ペインズーム
	{
		key = "z",
		mods = "CMD",
		action = act.TogglePaneZoomState,
	},
	-- タブ移動
	{
		key = "(",
		mods = "CMD|SHIFT",
		action = act.MoveTabRelative(-1),
	},
	{
		key = ")",
		mods = "CMD|SHIFT",
		action = act.MoveTabRelative(1),
	},
	-- ブラー切り替え
	{
		key = "f",
		mods = "CMD|SHIFT",
		action = act.EmitEvent("toggle-blur"),
	},
	-- ワークスペース機能
	{
		key = "n",
		mods = "CMD|SHIFT",
		action = act.SwitchWorkspaceRelative(1),
	},
	{
		key = "p",
		mods = "CMD|SHIFT",
		action = act.SwitchWorkspaceRelative(-1),
	},
	{
		-- ワークスペース作成
		key = "S",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "(wezterm) Create new workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		-- ワークスペース選択
		key = "s",
		mods = "CMD",
		action = wezterm.action_callback(function(win, pane)
			-- ワークスペースリストを作成
			local workspaces = {}
			for i, name in ipairs(wezterm.mux.get_workspace_names()) do
				table.insert(workspaces, {
					id = name,
					label = string.format("%d. %s", i, name),
				})
			end
			-- ワークスペース選択を起動
			win:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(_, _, id, label)
						if not id and not label then
							wezterm.log_info("Workspace selection canceled")
						else
							win:perform_action(act.SwitchToWorkspace({ name = id }), pane)
						end
					end),
					title = "Select workspace",
					choices = workspaces,
					fuzzy = true,
				}),
				pane
			)
		end),
	},
	{
		-- ワークスペースリネーム
		key = "R",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "(wezterm) Set workspace title:",
			action = wezterm.action_callback(function(win, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
}

-- タブアクティベーション（1-9）
for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.ActivateTab(i - 1),
	})
end

return keys
