local wezterm = require("wezterm")

local config = {}

-- if wezterm.config_builder then
-- 	config = wezterm.config_builder()
-- end

config.automatically_reload_config = true
config.default_prog = { "fish" }
config.default_cursor_style = "BlinkingBar"
config.initial_cols = 162
config.initial_rows = 40
-- config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"

config.window_background_opacity = 0.85
-- config.text_background_opacity = 0.4

-- Appearance
config.color_scheme = "kanagawabones"
-- config.color_scheme = 'OceanicNext (base16)'
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Font
config.font = wezterm.font_with_fallback({
	{ family = "Moralerspace Argon HWNF", scale = 1.0, italic = false },
	{ family = "Cascadia Next JP", scale = 1.0, italic = false },
	{ family = "Mononoki Nerd Font", scale = 1.0, italic = false },
})
config.font_size = 16

-- Behaviour
config.audible_bell = "Disabled"
config.animation_fps = 60

-- Leader
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Keymaps
config.keys = {
	{ key = "a", mods = "LEADER", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action.ShowLauncher },
	{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "h", mods = "LEADER", action = wezterm.action.PaneSelect },
}

return config
