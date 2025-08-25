-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local is_windows = os.getenv("OS") == "Windows_NT"
local is_macos = os.getenv("OS") == "Darwin"

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
config.force_reverse_video_cursor = true

-- Window Configuration
config.initial_rows = 45
config.initial_cols = 180
config.window_background_opacity = 0.4
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

-- Tab Bar Configuration
config.use_fancy_tab_bar = false
config.tab_max_width = 1600
config.show_new_tab_button_in_tab_bar = false
function get_max_cols(window)
  local tab = window:active_tab()
  local cols = tab:get_size().cols
  return cols
end

wezterm.on(
  'window-config-reloaded',
  function(window)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'window-resized',
  function(window, pane)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  -- Extract current directory name (or ~ for home)
  local current_dir = (string.gsub(tab.active_pane.current_working_dir.path, "/$", ""))
  local home_dir = "/" .. wezterm.home_dir:gsub("\\", "/")
  local dir_name
  if current_dir == home_dir then
    dir_name = "~"
  else
    dir_name = string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
  end

  -- Build base title (index + dir)
  local base_title = tostring(tab.tab_index + 1) .. ": " .. dir_name
  local full_title = "[" .. base_title .. "]"

  -- Centering logic from your second snippet
  local pad_length = (wezterm.GLOBAL.cols // #tabs - #full_title) // 2
  if pad_length * 2 + #full_title > max_width then
    pad_length = (max_width - #full_title) // 2
  end

  return string.rep(" ", pad_length) .. full_title .. string.rep(" ", pad_length)
end)

-- Keybindings
config.disable_default_key_bindings = true
config.keys = {
	-- Clipboard
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- Tabs
	{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "[", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "]", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },
	-- Panes
	{ key = "-", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "=", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },
	{ key = "q", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },

	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "j", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "k", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "l", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) }
}

if is_windows then
  config.wsl_domains = {
    {
      name = "WSL:Debian",
      distribution = "Debian",
    },
  }
  -- start straight into WSL
  config.default_domain = "WSL:Debian"
end

return config
