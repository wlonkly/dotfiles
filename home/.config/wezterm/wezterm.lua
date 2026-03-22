local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

-- Color overrides from Ghostty (keeping Catppuccin theme)
config.colors = {
--  foreground = "#fbfefc",
  selection_fg = "#fbfefc",
  selection_bg = "#b83cb8",
  cursor_fg = "#fbfefc",
  cursor_bg = "#b83cb8",
  cursor_border = "#b83cb8",
}
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.default_cursor_style = "SteadyBlock"

-- Mouse
config.hide_mouse_cursor_when_typing = true 

-- Font
config.font = wezterm.font 'Fira Code'
config.font_size = 12

-- Window settings
config.initial_cols = 102
config.initial_rows = 59

-- Window padding
config.window_padding = {
  left = 4,
  right = 4,
  top = 2,
  bottom = 4,
}

config.enable_kitty_keyboard = true

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
-- -- Quick terminal (global ctrl+`)
-- local wezterm = require 'wezterm'
-- local mux = wezterm.mux
-- 
-- wezterm.on('toggle_quick_terminal', function(window, pane)
--   local gui = wezterm.gui
--   if not gui then
--     return
--   end
-- 
--   local existing = gui.get_guis_by_filter(function(w)
--     return w:get_config().quick_terminal == true
--   end)
-- 
--   if #existing > 0
--   then
--     for _, w in ipairs(existing) do
--       w:close()
--     end
--   else
--     local _, window = mux.spawn_window {
--       workspace = 'quick',
--     }
--     window:gui_window():toggle_fullscreen()
--     window:get_config().quick_terminal = true
--   end
-- end)
-- 
-- -- Key bindings
-- config.keys = {
--   {
--     key = '`',
--     mods = 'CTRL',
--     action = wezterm.action.EmitKey 'toggle_quick_terminal',
--   },
-- }


return config
