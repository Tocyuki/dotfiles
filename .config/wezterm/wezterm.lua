-- wezterm設定ファイル
-- 参考: https://github.com/ryoppippi/dotfiles/tree/main/wezterm

local wezterm = require("wezterm")

-- 設定ファイルのディレクトリをpackage.pathに追加
local config_file = wezterm.config_file
local config_dir = config_file:match("(.*/)")
package.path = package.path .. ";" .. config_dir .. "?.lua" .. ";" .. config_dir .. "?/init.lua"

local utils = require("utils")
local keys = require("keymaps")

-- イベントハンドラーを読み込む
require("on")
require("zen-mode")

-- ローカル設定の読み込み（オプション）
-- 公開したくない設定（ssh_domainsなど）を記述
local function load_local_config()
	local ok, re = pcall(require, "local")
	if not ok then
		return {}
	end
	return re.setup()
end

local local_config = load_local_config()

-- 基本設定
local config = {
	-- フォント設定
	font = wezterm.font_with_fallback({
		"Moralerspace Argon",
	}),
	font_size = 16,
	-- 日本語対応設定（ghosttyのfont-feature = -calt,-liga,-kern,-dlig,-hlig に相当）
	harfbuzz_features = { "calt=0", "liga=0", "kern=0", "dlig=0", "hlig=0" },
	font_rules = {
		{
			italic = true,
			font = wezterm.font_with_fallback({
				"Moralerspace Argon",
			}),
		},
		{
			intensity = "Bold",
			font = wezterm.font_with_fallback({
				"Moralerspace Argon",
			}),
		},
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font_with_fallback({
				"Moralerspace Argon",
			}),
		},
	},

	-- カラースキーム（kanagawa_dragonを使用）

	-- ウィンドウ設定
	window_padding = {
		left = 1,
		right = 0,
		top = 0,
		bottom = 0,
	},
	window_background_opacity = 0.70,
	window_background_gradient = {
		colors = { "#000000" },
	},
	text_background_opacity = 0.8,
	macos_window_background_blur = 20,
	window_decorations = "RESIZE",

	-- ターミナル設定
	default_prog = { "/bin/zsh", "-l" },
	term = "xterm-256color",

	-- カーソル設定
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 500,
	force_reverse_video_cursor = true,

	-- スクロール設定
	scrollback_lines = 40960,
	enable_scroll_bar = true,

	-- マウス設定
	enable_kitty_keyboard = false,

	-- macOS固有設定
	native_macos_fullscreen_mode = false,
	quit_when_all_windows_are_closed = false,

	-- パフォーマンス設定：非フォーカス時の透明度
	inactive_pane_hsb = {
		saturation = 0.5,
		brightness = 0.5,
	},

	-- キーバインド設定
	keys = keys,

	-- IME設定
	use_ime = true,
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = false,
	macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",

	-- その他の設定
	adjust_window_size_when_changing_font_size = false,
	enable_csi_u_key_encoding = true,

	-- 環境変数設定
	set_environment_variables = {},

	-- マウスバインド設定
	mouse_bindings = {
		-- 右クリックでペースト
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action({ PasteFrom = "Clipboard" }),
		},
		-- ダブルクリックで単語選択
		{
			event = { Down = { streak = 2, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ SelectTextAtMouseCursor = "Word" }),
		},
		-- トリプルクリックで行選択
		{
			event = { Down = { streak = 3, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ SelectTextAtMouseCursor = "Line" }),
		},
		-- テキスト選択時の自動コピー
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ CompleteSelection = "Clipboard" }),
		},
	},
}

-- タブバー設定をマージ
config = utils.merge_tables(config, require("tab_bar"))

-- カラースキーム設定をマージ
config = utils.merge_tables(config, require("colors.kanagawa_dragon"))

-- ローカル設定をマージ
config = utils.merge_tables(config, local_config)

return config
