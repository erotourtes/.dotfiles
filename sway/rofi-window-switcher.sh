#!/bin/sh

row=$(swaymsg -t get_tree | jq  -r '
    ..
    | objects
    | select(.type == "workspace") as $ws
    | ..
    | objects
    | select(has("app_id"))
    | (if .focused == true then "*" else " " end) as $asterisk
    | "[\($ws.name)] \($asterisk) <span weight=\"bold\">\(.app_id)</span>  - \(.name) <!-- \(.id) -->\u0000icon\u001f\(.app_id)"' \
| sed 's/&/&amp;/g' \
| rofi -dmenu -show-icons -markup-rows -i -p "Switch")

if [ ! -z "$row" ]
then
    winid=$(echo "$row" | sed 's/.*<!-- \([0-9]*\) -->.*/\1/')
    swaymsg "[con_id=$winid] focus"
fi
