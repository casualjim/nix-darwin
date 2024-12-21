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
  family = 'Monaspace Neon'
}
  
config.font_size = 13

config.window_background_opacity = 0.80
config.macos_window_background_blur = 30
config.default_cursor_style = "BlinkingBar"

config.use_fancy_tab_bar = true

config.scrollback_lines = 350000

config.keys = {
  -- Split pane
  {key='d', mods='CMD', action=act.SplitHorizontal{domain='CurrentPaneDomain'}},
  {key='D', mods='CMD|SHIFT', action=act.SplitVertical{domain='CurrentPaneDomain'}},
  {key='w', mods='CMD', action=act.CloseCurrentPane{confirm=false}},

  -- Pane navigation
  {key='LeftArrow', mods='CMD|ALT', action=act.ActivatePaneDirection('Left')},
  {key='RightArrow', mods='CMD|ALT', action=act.ActivatePaneDirection('Right')},
  {key='UpArrow', mods='CMD|ALT', action=act.ActivatePaneDirection('Up')},
  {key='DownArrow', mods='CMD|ALT', action=act.ActivatePaneDirection('Down')},

  -- Pane resizing
  {key='LeftArrow', mods='ALT|SHIFT', action=act.AdjustPaneSize{'Left', 1}},
  {key='RightArrow', mods='ALT|SHIFT', action=act.AdjustPaneSize{'Right', 1}},
  {key='UpArrow', mods='ALT|SHIFT', action=act.AdjustPaneSize{'Up', 1}},
  {key='DownArrow', mods='ALT|SHIFT', action=act.AdjustPaneSize{'Down', 1}},

  -- Tab navigation
  {key='RightArrow', mods='CMD', action=act.ActivateTabRelative(1)},
  {key='LeftArrow', mods='CMD', action=act.ActivateTabRelative(-1)},

  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  {key="LeftArrow", mods="ALT", action=act{SendString="\x1bb"}},
  -- Make Option-Right equivalent to Alt-f; forward-word
  {key="RightArrow", mods="ALT", action=act{SendString="\x1bf"}},

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
