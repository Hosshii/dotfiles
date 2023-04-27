local wezterm = require 'wezterm';

return {
  font = wezterm.font("Ricty"), -- 自分の好きなフォントいれる
  use_ime = true, -- wezは日本人じゃないのでこれがないとIME動かない
  font_size = 10.0,
--   color_scheme = "OneHalfDark", -- 自分の好きなテーマ探す https://wezfurlong.org/wezterm/colorschemes/index.html
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  keys{
    -- ctrl+'-'で上下に分割
    {key="-",mods="CTRL",action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    -- ctrl+'|'で左右で分割
    {key="t",mods="CTRL",action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    -- ctrl+'w'でpaneを閉じる
    {key="w",mods="CTRL",action=wezterm.action.CloseCurrentPane{confirm=false}}
  }
}