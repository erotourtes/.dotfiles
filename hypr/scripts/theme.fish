#!/usr/bin/env fish

argparse h/help= -- $argv
or return

if set -q _flag_help[-1]
    echo "Usage: theme.fish [<empty>|light|dark]"
    exit 0
end

# Theme names
set light_theme "WhiteSur-Light-orange"
set dark_theme "WhiteSur-Dark-orange"

# Config paths
set gtk_file ~/.config/gtk-3.0/settings.ini
set gtk4_file ~/.config/gtk-4.0/settings.ini
set qt_file ~/.config/qt5ct/qt5ct.conf
set hypr_theme_link ~/.config/hypr/theme.conf
set current_theme_file ~/.config/current-theme

set a_theme $argv[1]

if test -z "$a_theme"
  if test -f "$current_theme_file"
    set a_theme (cat $current_theme_file)
  end

  if test "$a_theme" = "dark"
    set a_theme light
  else
    set a_theme dark
  end
end

switch $a_theme
  case "light"
    set theme_type "light"
    set gtk_theme $light_theme
    set dark_pref 0
  case "dark"
    set theme_type "dark"
    set gtk_theme $dark_theme
    set dark_pref 1
  case "*"
    echo "Unknown option: $argv[1]"
    exit 1
end

function update_gtk_config --argument file key value
    if test -f $file
        grep -q "^$key=" $file
        if test $status -eq 0
            sed -i "s|^$key=.*|$key=$value|" $file
        else
            echo "$key=$value" >> $file
        end
    end
end

echo Switching to the $a_theme theme

# Update GTK settings
for file in $gtk_file $gtk4_file
  if test -f $file
    update_gtk_config $file "gtk-theme-name" $gtk_theme
    update_gtk_config $file "gtk-application-prefer-dark-theme" $dark_pref
  end
end

# for GTK4 apps
if test $dark_pref -eq 0
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
else
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
end

# Update Qt5ct theme
if test -f $qt_file
    sed -i "s/^color_scheme=.*/color_scheme=$gtk_theme/" $qt_file
end

# Save current theme state
echo $theme_type > $current_theme_file

# Reload things
hyprctl reload
killall waybar 2>/dev/null; and waybar &

notify-send "🌗 Theme set to $theme_type"
