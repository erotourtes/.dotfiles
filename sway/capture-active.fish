#!/bin/fish

set -l dimensions $(swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')

set -l path "$(xdg-user-dir PICTURES)/Screenshots/$(date +'screen_screenshot_%Y-%m-%d-%H%M%S.png')"

grim -g "$dimensions" - | wl-copy -t image/png

set res $(notify-send "Screenshot copied to clipboard" --action="Save" --action="Save, Open")

if test $res -eq 0 # Save
  wl-paste > "$path"
end

if test $res -eq 1 # Open
  echo "$path"
    wl-paste > "$path"
    xdg-open "$path"
end
