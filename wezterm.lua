local wezterm = require "wezterm"
local act = wezterm.action

-- function scheme_for_appearance(appearance)
--   if appearance:find "Dark" then
--     return "Catppuccin Mocha" -- Dark mode flavor
--   else
--     return "Catppuccin Latte" -- Light mode flavor
--   end
-- end

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font {
  family = 'CaskaydiaCove Nerd Font Mono'
}
  
config.font_size = 14

config.window_background_opacity = 0.80
config.macos_window_background_blur = 30
config.default_cursor_style = "BlinkingBar"

config.use_fancy_tab_bar = true

config.scrollback_lines = 350000

config.keys = {
  -- Split pane
  {key='D', mods='CMD', action=wezterm.action.SplitHorizontal{domain='CurrentPaneDomain'}},
  {key='d', mods='CMD|SHIFT', action=wezterm.action.SplitVertical{domain='CurrentPaneDomain'}},
  {key='w', mods='CMD', action=wezterm.action.CloseCurrentPane{confirm=false}},

  -- Pane navigation
  {key='LeftArrow', mods='CMD|ALT', action=wezterm.action.ActivatePaneDirection('Left')},
  {key='RightArrow', mods='CMD|ALT', action=wezterm.action.ActivatePaneDirection('Right')},
  {key='UpArrow', mods='CMD|ALT', action=wezterm.action.ActivatePaneDirection('Up')},
  {key='DownArrow', mods='CMD|ALT', action=wezterm.action.ActivatePaneDirection('Down')},

  -- Pane resizing
  {key='LeftArrow', mods='ALT|SHIFT', action=wezterm.action.AdjustPaneSize{'Left', 1}},
  {key='RightArrow', mods='ALT|SHIFT', action=wezterm.action.AdjustPaneSize{'Right', 1}},
  {key='UpArrow', mods='ALT|SHIFT', action=wezterm.action.AdjustPaneSize{'Up', 1}},
  {key='DownArrow', mods='ALT|SHIFT', action=wezterm.action.AdjustPaneSize{'Down', 1}},

  -- Tab navigation
  {key='RightArrow', mods='CMD', action=wezterm.action.ActivateTabRelative(1)},
  {key='LeftArrow', mods='CMD', action=wezterm.action.ActivateTabRelative(-1)},

  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  {key="LeftArrow", mods="ALT", action=wezterm.action{SendString="\x1bb"}},
  -- Make Option-Right equivalent to Alt-f; forward-word
  {key="RightArrow", mods="ALT", action=wezterm.action{SendString="\x1bf"}},

  -- Clears the scrollback and viewport, and then sends CTRL-L to ask the
  -- shell to redraw its prompt
  {
    key = 'K',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.ClearScrollback 'ScrollbackAndViewport',
      act.SendKey { key = 'L', mods = 'CTRL' },
    },
  },
}

return config
