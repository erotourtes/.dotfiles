#!/usr/bin/env fish

# Use zoxide to generate the list of directories
set directories (zoxide query -ls | awk '{print $2}' | rofi -dmenu -show-icons -markup-rows -i -p "Search:")


# Open the selected directory
if test -n "$directories"
    xdg-open "$directories" &
end
