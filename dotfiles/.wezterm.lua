local wezterm = require 'wezterm';

local mykeys = {
    {key="F10",
      action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="F12",
      action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
}
for i = 1, 8 do
  -- F1 through F8 to activate that tab
  table.insert(mykeys, {
    key="F" .. tostring(i),
    action=wezterm.action{ActivateTab=i-1},
  })
end

return {
  default_prog = {"/usr/local/bin/bash"},
  font = wezterm.font("JetBrains Mono"),
  color_scheme = "Dracula",
  keys = mykeys,
  initial_cols = 152,
  initial_rows = 52,
}
