-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Platform detection (optimized to avoid shell calls)
local is_windows = os.getenv("OS") == "Windows_NT" or os.getenv("WSLENV") ~= nil
local is_macos = wezterm.target_triple:find("apple") ~= nil
local is_linux = not is_windows and not is_macos

-- Font Configuration (simplified for faster loading)
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 11
config.line_height = 1.1

-- Color Configuration
config.color_scheme = "GruvboxDark"
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

config.status_update_interval = 5000

-- Cache basename function for performance
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Status cache to reduce redundant updates
local status_cache = {}

wezterm.on("update-status", function(window, pane)
  local pane_id = pane:pane_id()

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

  -- Time (update less frequently)
  local time = wezterm.strftime("%H:%M")

  -- Create cache key
  local cache_key = cwd .. "|" .. cmd .. "|" .. time

  -- Only update if changed
  if status_cache[pane_id] ~= cache_key then
    status_cache[pane_id] = cache_key

    -- Right status with gruvbox colors
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#83a598" } },
      { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
      { Foreground = { Color = "#928374" } },
      { Text = " | " },
      { Foreground = { Color = "#fabd2f" } },
      { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
      { Foreground = { Color = "#928374" } },
      { Text = " | " },
      { Foreground = { Color = "#b8bb26" } },
      { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
      { Text = "  " },
    }))
  end
end)


-- Keybindings
config.disable_default_key_bindings = true

config.keys = {
  -- Clipboard
  { key = "c",          mods = "SHIFT|CTRL",   action = act.CopyTo("Clipboard") },
  { key = "v",          mods = "SHIFT|CTRL",   action = act.PasteFrom("Clipboard") },

  -- Search and Copy Mode
  { key = "f",          mods = "CTRL|SHIFT", action = act.Search({ CaseInSensitiveString = "" }) },
  { key = "x",          mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "u",          mods = "CTRL|SHIFT", action = act.QuickSelect },

  -- Font Size
  { key = "=",          mods = "CTRL",       action = act.IncreaseFontSize },
  { key = "-",          mods = "CTRL",       action = act.DecreaseFontSize },
  { key = "0",          mods = "CTRL",       action = act.ResetFontSize },
  -- Tabs
  { key = "t",          mods = "ALT",        action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w",          mods = "ALT",        action = act.CloseCurrentTab({ confirm = false }) },
  { key = "[",          mods = "ALT",        action = act.ActivateTabRelative(1) },
  { key = "]",          mods = "ALT",        action = act.ActivateTabRelative(-1) },
  -- Panes
  { key = "-",          mods = "ALT",        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "=",          mods = "ALT",        action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "z",          mods = "ALT",        action = act.TogglePaneZoomState },
  { key = "q",          mods = "ALT",        action = act.CloseCurrentPane({ confirm = false }) },

  { key = "h",          mods = "ALT",        action = act.ActivatePaneDirection("Left") },
  { key = "j",          mods = "ALT",        action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "ALT",        action = act.ActivatePaneDirection("Up") },
  { key = "l",          mods = "ALT",        action = act.ActivatePaneDirection("Right") },
  { key = "h",          mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 3 }) },
  { key = "j",          mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 3 }) },
  { key = "k",          mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "l",          mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 3 }) },
  { key = "LeftArrow",  mods = "ALT",        action = act.ActivatePaneDirection("Left") },
  { key = "DownArrow",  mods = "ALT",        action = act.ActivatePaneDirection("Down") },
  { key = "UpArrow",    mods = "ALT",        action = act.ActivatePaneDirection("Up") },
  { key = "RightArrow", mods = "ALT",        action = act.ActivatePaneDirection("Right") },
  { key = "LeftArrow",  mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 3 }) },
  { key = "DownArrow",  mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 3 }) },
  { key = "UpArrow",    mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "RightArrow", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 3 }) },

  -- Workspace management
  { key = "w",          mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },

  -- Tab activation keys (ALT+1-9)
  { key = "1",          mods = "ALT",        action = act.ActivateTab(0) },
  { key = "2",          mods = "ALT",        action = act.ActivateTab(1) },
  { key = "3",          mods = "ALT",        action = act.ActivateTab(2) },
  { key = "4",          mods = "ALT",        action = act.ActivateTab(3) },
  { key = "5",          mods = "ALT",        action = act.ActivateTab(4) },
  { key = "6",          mods = "ALT",        action = act.ActivateTab(5) },
  { key = "7",          mods = "ALT",        action = act.ActivateTab(6) },
  { key = "8",          mods = "ALT",        action = act.ActivateTab(7) },
  { key = "9",          mods = "ALT",        action = act.ActivateTab(8) },
}

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
