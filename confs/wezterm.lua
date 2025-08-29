-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Platform detection
local function get_os()
  local handle = io.popen("uname -s")
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return result
end

local os_name = get_os()
local is_windows = os_name == "MINGW64_NT" or os.getenv("OS") == "Windows_NT"
local is_macos = os_name == "Darwin"
local is_linux = os_name == "Linux"

-- Font Configuration
config.font = wezterm.font_with_fallback({
    {
        family = "JetBrainsMono Nerd Font",
        weight = "Regular",
    },
})
config.font_size = 11
config.line_height = 1.1

-- Color Configuration
config.color_scheme = "Catppuccin Macchiato"
config.force_reverse_video_cursor = false

-- Window Configuration
config.initial_rows = 45
config.initial_cols = 180
config.window_background_opacity = 0.6
config.text_background_opacity = 0.95
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
}
config.adjust_window_size_when_changing_font_size = false
if is_windows then
  config.win32_system_backdrop = "Acrylic"
end

-- Performance Settings
config.max_fps = 144
config.animation_fps = 144
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- Tab Bar Configuration
config.use_fancy_tab_bar = false
config.tab_max_width = 1600

config.status_update_interval = 1000

-- Cache basename function for performance
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("update-status", function(window, pane)

	-- Current working directory
	local cwd = pane:get_current_working_dir()
	if cwd then
		if type(cwd) == "userdata" then
			cwd = basename(cwd.file_path)
		else
			cwd = basename(cwd)
		end
	else
		cwd = ""
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")

	-- Right status with custom colors
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#8aadf4" } },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Foreground = { Color = "#6e738d" } },
		{ Text = " | " },
		{ Foreground = { Color = "#f5a97f" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		{ Foreground = { Color = "#6e738d" } },
		{ Text = " | " },
		{ Foreground = { Color = "#a6da95" } },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " },
	}))
end)


-- Keybindings
config.disable_default_key_bindings = true

-- Helper function to generate tab activation keys
local function generate_tab_keys()
  local keys = {}
  for i = 1, 9 do
    table.insert(keys, {
      key = tostring(i),
      mods = "ALT",
      action = act.ActivateTab(i - 1)
    })
  end
  return keys
end

config.keys = {
	-- Clipboard
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "ALT|CTRL", action = act.PasteFrom("Clipboard") },
	
	-- Search and Copy Mode
	{ key = "f", mods = "CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },
	{ key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
	{ key = "u", mods = "CTRL|SHIFT", action = act.QuickSelect },
	
	-- Font Size
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	-- Tabs
	{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "[", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "]", mods = "ALT", action = act.ActivateTabRelative(-1) },
	-- Panes
	{ key = "-", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },
	{ key = "q", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },

	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "j", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 3 }) },
	{ key = "k", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "l", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 3 }) },
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 3 }) },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 3 }) },
	
	-- Workspace management
	{ key = "w", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
}

-- Add generated tab keys
for _, key in ipairs(generate_tab_keys()) do
  table.insert(config.keys, key)
end

-- Platform-specific configuration
if is_windows then
  config.wsl_domains = {
    {
      name = "WSL:Debian",
      distribution = "Debian",
      default_cwd = "~",
    },
  }
  config.default_domain = "WSL:Debian"
elseif is_macos then
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
elseif is_linux then
  config.enable_wayland = true
end

return config
