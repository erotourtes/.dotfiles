#!/bin/env fish

argparse "w/wallpaper" "t/toggle-theme" -- $argv
or return

function update_wallust
  set theme (cat ~/.config/current-theme)
  if string match -q 'dark' -- $theme
    set theme 'dark'
  else if string match -q 'light' -- $theme
    set theme 'light'
  else
    echo "Unknown theme"
  end

  wallust run -s ~/.config/current-wallpaper --palette=$theme
end

function set_wallust_theme
  ~/.config/rofi/scripts/change_theme.fish auto.rasi
  ~/.config/hypr/scripts/change_theme.fish colors-auto.conf
  ~/.config/waybar/change_theme.fish auto.css
  ~/.config/swaync/change_theme.fish auto.css
end

function set_default_theme
  ~/.config/rofi/scripts/change_theme.fish
  ~/.config/hypr/scripts/change_theme.fish
  ~/.config/waybar/change_theme.fish
  ~/.config/swaync/change_theme.fish
end

function refresh_programs
  for process in waybar rofi swaync;
    if pidof "$process" >/dev/null;
      pkill "$process"
    end
  end

  sleep 0.2
  # Relaunch waybar
  waybar > /dev/null 2>&1 &

  # relaunch swaync
  sleep 0.2
  swaync > /dev/null 2>&1 &
end



if set -q _flag_wallpaper
  echo "Selecting wallpaper"
  ~/.config/hypr/scripts/Wallpaper.sh
  if test $status -eq 1
    exit 0
  end
end

if set -q _flag_toggle_theme
  echo "Toggling theme"
  if string match -q 'default' -- (string trim < ~/.config/current-color-theme)
    echo Setting auto theme
    set_wallust_theme
    echo auto > ~/.config/current-color-theme
  else
    echo Setting default theme
    set_default_theme
    echo default > ~/.config/current-color-theme
  end
end

echo "Refreshing programs"
update_wallust
refresh_programs
