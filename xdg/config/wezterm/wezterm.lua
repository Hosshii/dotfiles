local wezterm = require 'wezterm';

-- 常にフルスクリーンにする
-- https://github.com/wez/wezterm/issues/284
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  font = wezterm.font("HackGen35 Console NF"),
  use_ime = true, 
  font_size = 13.0,
  color_scheme = "Solarized Light (Gogh)", -- 自分の好きなテーマ探す https://wezfurlong.org/wezterm/colorschemes/index.html
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  keys = {
    -- ctrl+'-'で上下に分割
    {key="-",mods="CTRL",action=wezterm.action.SplitVertical({domain="CurrentPaneDomain"})},
    -- ctrl+'|'で左右で分割
    {key=";",mods="CTRL",action=wezterm.action.SplitHorizontal({domain="CurrentPaneDomain"})},
    -- ctrl+'w'でpaneを閉じる
    {key="w",mods="CTRL",action=wezterm.action.CloseCurrentPane{confirm=false}},
    -- full screen 切り替え
    {key = 'h',mods="CTRL",action = wezterm.action.ToggleFullScreen},
  }
}
