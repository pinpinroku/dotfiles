local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { "fish" }
config.launch_menu = {
	{ label = "Bottom", args = { "btm" } },
}

config.initial_cols = 105
config.initial_rows = 28
-- config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"

config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

-- Appearance
config.color_scheme = "kanagawabones"
config.window_padding = {
	top = 0,
	bottom = 0,
	right = 0,
	left = 0,
}

-- Font
config.font = wezterm.font_with_fallback({
	{ family = "Moralerspace Radon NF", scale = 1.0, italic = false },
})
config.font_size = 18
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Behaviour
config.audible_bell = "Disabled"
-- config.animation_fps = 30

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

	-- Swap keymaps for toggle fullscreen.
	{
		-- Press `F11` to toggle fullscreen.
		key = "F11",
		mods = "",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		-- Disable default keymap. This combination used in broot.
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config
