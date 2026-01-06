local wezterm = require 'wezterm'
local act = wezterm.action

return {
  font = wezterm.font_with_fallback({
    'Ayuthaya',
    'JetBrains Mono',
    'Noto Sans Mono CJK KR',
  }),
  font_size = 13,

  window_background_opacity = 0.93,
  text_background_opacity = 1.0,
  macos_window_background_blur = 10,

  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,
  tab_bar_at_bottom = true,

  tab_max_width = 24,
  automatically_reload_config = true,

  -- color_scheme = "Tin (Gogh)",
  -- color_scheme = "Catppuccin Latte (Gogh)",

  window_decorations = 'RESIZE',
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  scrollback_lines = 5000,
  enable_scroll_bar = false,

  default_cursor_style = 'SteadyBlock',
  animation_fps = 60,
  cursor_blink_rate = 800,

  keys = {
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  },

  set_environment_variables = {
    LANG = 'ko_KR.UTF-8',
  },

  window_frame = {
    font_size = 11.0,
  },

  default_prog = {
    '/bin/zsh', '-l'
  },

  font_rules = {
    {
      italic = true,
      intensity = 'Bold',
      font = wezterm.font_with_fallback({
        'JetBrains Mono Italic',
        'Noto Sans Mono CJK KR',
      }),
    },
  },
}
