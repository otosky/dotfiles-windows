local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}
local haswork,work = pcall(require,"work")

-- Windows config
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  --- Grab the ver info for later use.
  local success, stdout, stderr = wezterm.run_child_process { 'cmd.exe', 'ver' }
  local major, minor, build, rev = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
  local is_windows_11 = tonumber(build) >= 22000
  
  --- Make it look cool.
  if is_windows_11 then
    wezterm.log_info "We're running Windows 11!"
  end

  --- Set Pwsh as the default on Windows
  config.default_domain = 'WSL:Ubuntu'
-- Non-Windows config
else
  
end

-- Mousing bindings
mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- and make CTRL-Click open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

--- Default config settings
config.scrollback_lines = 7000
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Tokyo Night Storm'
config.font_size = 12
--config.launch_menu = launch_menu
config.launch_menu = {
    {
      args = { 'top' },
    },
    {
      -- Optional label to show in the launcher. If omitted, a label
      -- is derived from the `args`
      label = 'Bash',
      -- The argument array to spawn.  If omitted the default program
      -- will be used as described in the documentation above
      args = { 'bash', '-l' },
  
      -- You can specify an alternative current working directory;
      -- if you don't specify one then a default based on the OSC 7
      -- escape sequence will be used (see the Shell Integration
      -- docs), falling back to the home directory.
      -- cwd = "/some/path"
  
      -- You can override environment variables just for this command
      -- by setting this here.  It has the same semantics as the main
      -- set_environment_variables configuration option described above
      -- set_environment_variables = { FOO = "bar" },
    },
  }
config.default_cursor_style = 'BlinkingUnderline'
config.disable_default_key_bindings = true
config.keys = {
    { key = 'g', mods = 'ALT', action = wezterm.action.ShowLauncher },
  }
config.mouse_bindings = mouse_bindings

-- Allow overwriting for work stuff
if haswork then
  work.apply_to_config(config)
end

return config