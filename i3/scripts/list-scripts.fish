#!/bin/fish

function listScripts
  set -f scriptsPath ~/.config/i3/scripts/
  set -l scripts (ls -I "list-scripts.fish" -I "draft*" $scriptsPath)
  
  fish "$scriptsPath$(printf %s\n  $scripts | rofi -dmenu -p "Execute: ")"
end

listScripts
