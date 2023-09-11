local wez = require 'wezterm'
local act = wez.action

local function isViProcess(pane) 
    -- get_foreground_process_name On Linux, macOS and Windows, 
    -- the process can be queried to determine this path. Other operating systems 
    -- (notably, FreeBSD and other unix systems) are not currently supported
    return pane:get_foreground_process_name():find('n?vim') ~= nil
    -- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if isViProcess(pane) then
        window:perform_action(
            -- This should match the keybinds you set in Neovim.
            act.SendKey({ key = vim_direction, mods = 'CTRL' }),
            pane
        )
    else
        window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
    end
end

wez.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
end)
wez.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
end)
wez.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
end)
wez.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
end)

local colors = {
	rosewater = "#F4DBD6",
	flamingo = "#F0C6C6",
	pink = "#F5BDE6",
	mauve = "#C6A0F6",
	red = "#ED8796",
	maroon = "#EE99A0",
	peach = "#F5A97F",
	yellow = "#EED49F",
	green = "#A6DA95",
	teal = "#8BD5CA",
	sky = "#91D7E3",
	sapphire = "#7DC4E4",
	blue = "#8AADF4",
	lavender = "#B7BDF8",

	text = "#CAD3F5",
	subtext1 = "#B8C0E0",
	subtext0 = "#A5ADCB",
	overlay2 = "#939AB7",
	overlay1 = "#8087A2",
	overlay0 = "#6E738D",
	surface2 = "#5B6078",
	surface1 = "#494D64",
	surface0 = "#363A4F",

	base = "#24273A",
	mantle = "#1E2030",
	crust = "#181926",
}

local nerd = wez.nerdfonts
local function get_process(tab)
  local process_icons = {
    ["docker"] = {
      { Foreground = { Color = colors.blue } },
      { Text = nerd.linux_docker },
    },
    ["docker-compose"] = {
      { Foreground = { Color = colors.blue } },
      { Text = nerd.linux_docker },
    },
    ["nvim"] = {
      { Foreground = { Color = colors.green } },
      { Text = nerd.custom_vim },
    },
    ["vim"] = {
      { Foreground = { Color = colors.green } },
      { Text = nerd.dev_vim },
    },
    ["node"] = {
      { Foreground = { Color = colors.green } },
      { Text = nerd.mdi_hexagon },
    },
    ["zsh"] = {
      { Foreground = { Color = colors.peach } },
      { Text = nerd.dev_terminal },
    },
    ["fish"] = {
      { Foreground = { Color = colors.peach } },
      { Text = nerd.dev_terminal },
    },
    ["bash"] = {
      { Foreground = { Color = colors.subtext0 } },
      { Text = nerd.cod_terminal_bash },
    },
    ["htop"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = nerd.mdi_chart_donut_variant },
    },
    ["cargo"] = {
      { Foreground = { Color = colors.peach } },
      { Text = nerd.dev_rust },
    },
    ["go"] = {
      { Foreground = { Color = colors.sapphire } },
      { Text = nerd.mdi_language_go },
    },
    ["lazydocker"] = {
      { Foreground = { Color = colors.blue } },
      { Text = nerd.linux_docker },
    },
    ["git"] = {
      { Foreground = { Color = colors.peach } },
      { Text = nerd.dev_git },
    },
    ["lazygit"] = {
      { Foreground = { Color = colors.peach } },
      { Text = nerd.dev_git },
    },
    ["lua"] = {
      { Foreground = { Color = colors.blue } },
      { Text = nerd.seti_lua },
    },
    ["wget"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = nerd.mdi_arrow_down_box },
    },
    ["curl"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = nerd.mdi_flattr },
    },
    ["gh"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = nerd.dev_github_badge },
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  return wez.format(
  process_icons[process_name]
  or { { Foreground = { Color = colors.sky } }, { Text = string.format("[%s]", process_name) } }
  )
end

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane.current_working_dir
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	return current_dir == HOME_DIR and "  ~"
		or string.format("  %s", string.gsub(current_dir, "(.*[/\\])(.*)", "%2"))
end

wez.on("format-tab-title", function(tab)
	return wez.format({
		{ Attribute = { Intensity = "Half" } },
		{ Text = string.format(" %s  ", tab.tab_index + 1) },
		"ResetAttributes",
		{ Text = get_process(tab) },
		{ Text = " " },
		{ Text = get_current_working_dir(tab) },
		{ Foreground = { Color = colors.base } },
		{ Text = "  ▕" },
	})
end)

return {
  font = wez.font_with_fallback({
    -- "Berkeley Mono",
    "Liga SFMono Nerd Font",
    "BlexMono Nerd Font Mono",
    "Apple Color Emoji",
    "Iosevka Term"
  }),

  unix_domains = {
    {name = 'unix'},
  },
  ssh_domains = {
    {
      name = 'katvm',
      remote_address = 'katvm', 
      remote_wezterm_path = '/home/linuxbrew/.linuxbrew/bin/wezterm',
    }
  },
  -- default_gui_startup_args = { 'connect', 'unix' },

  term='wezterm',
  font_size = 13.0,
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
  -- font_rules = {
  --   {
  --     intensity = 'Bold', 
  --     italic = false,
  --     font = wez.font('Liga SFMono Nerd Font', {weight="Bold"})
  --   },
  --   {
  --     intensity = 'Bold',
  --     italic = true,
  --     font = wez.font('Liga SFMono Nerd Font', {weight="Bold", italic=true})
  --   }
  -- },
  front_end = 'WebGpu',
  max_fps = 120,
  window_decorations = 'RESIZE',
  window_padding = {
    top='0.5cell', 
    left='1cell', 
    right='1cell', 
    bottom='0.5cell',
  },
  underline_position=-2,
  audible_bell="Disabled",

  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  colors = {
    split = colors.surface0,
    foreground = colors.text,
    background = colors.base,
    cursor_bg = colors.rosewater,
    cursor_border = colors.rosewater,
    cursor_fg = colors.base,
    selection_bg = colors.surface2,
    selection_fg = colors.text,
    visual_bell = colors.surface0,
    indexed = {
      [16] = colors.peach,
      [17] = colors.rosewater,
    },
    scrollbar_thumb = colors.surface2,
    compose_cursor = colors.flamingo,
    ansi = {
      colors.surface1,
      colors.red,
      colors.green,
      colors.yellow,
      colors.blue,
      colors.pink,
      colors.teal,
      colors.subtext0,
    },
    brights = {
      colors.subtext0,
      colors.red,
      colors.green,
      colors.yellow,
      colors.blue,
      colors.pink,
      colors.teal,
      colors.surface1,
    },
    tab_bar = {
      background = colors.crust,
      active_tab = {
        bg_color = "none",
        fg_color = colors.subtext1,
        intensity = "Bold",
        underline = "None",
        italic = false,
        strikethrough = false,
      },
      inactive_tab = {
        bg_color = colors.crust,
        fg_color = colors.surface2,
      },
      inactive_tab_hover = {
        bg_color = colors.mantle,
        fg_color = colors.subtext0,
      },
      new_tab = {
        bg_color = colors.crust,
        fg_color = colors.subtext0,
      },
      new_tab_hover = {
        bg_color = colors.crust,
        fg_color = colors.subtext0,
      },
    },
  },


  leader = { key = 'a', mods = 'CTRL' },
  disable_default_key_bindings = true, 
  keys = { 
    { key = "-", mods = "LEADER",       action=act{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "\\",mods = "LEADER",       action=act{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "\'",mods = "LEADER",       action=act{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action=act{SpawnTab="CurrentPaneDomain"}},
    { key = "q", mods = "LEADER",          action = act.CloseCurrentPane({ confirm = false }) },
    { key = "s", mods = "CMD",          action=act.SendKey({key='s', mods='CTRL'})},
    { key = "s", mods = "LEADER",          action=act{ShowLauncherArgs = {flags="FUZZY|WORKSPACES"}} },


    { key = 'h', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-left') },
    { key = 'j', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-down') },
    { key = 'k', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-up') },
    { key = 'l', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-right') },

    { key = "h", mods = "ALT", action=act{AdjustPaneSize={"Left",  3}}},
    { key = "j", mods = "ALT", action=act{AdjustPaneSize={"Down",  3}}},
    { key = "k", mods = "ALT", action=act{AdjustPaneSize={"Up",    3}}},
    { key = "l", mods = "ALT", action=act{AdjustPaneSize={"Right", 3}}},

    { key = "1", mods = "LEADER",       action=act{ActivateTab=0}},
    { key = "2", mods = "LEADER",       action=act{ActivateTab=1}},
    { key = "3", mods = "LEADER",       action=act{ActivateTab=2}},
    { key = "4", mods = "LEADER",       action=act{ActivateTab=3}},
    { key = "5", mods = "LEADER",       action=act{ActivateTab=4}},
    { key = "6", mods = "LEADER",       action=act{ActivateTab=5}},
    { key = "7", mods = "LEADER",       action=act{ActivateTab=6}},
    { key = "8", mods = "LEADER",       action=act{ActivateTab=7}},
    { key = "9", mods = "LEADER",       action=act{ActivateTab=8}},

    { key = "c", mods = "CMD",          action=act{ CopyTo = "Clipboard" } },
    { key = "v", mods = "CMD",          action=act{ PasteFrom = "Clipboard" } },
    { key = 'q', mods = 'CMD',          action=act.QuitApplication },
    { key = 'l', mods = 'CMD',          action=act.ShowLauncher },
    { key="Enter", mods="CTRL",         action=act{SendString="\x1b[13;5u"}},
    { key="Enter", mods="SHIFT",        action=act{SendString="\x1b[13;2u"}},
  },
}
