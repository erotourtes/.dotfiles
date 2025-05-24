#!/bin/env fish

set theme_dir ~/.config/rofi/colors

set current_symlink "$theme_dir/color.rasi"
set colors_file "$theme_dir/auto.rasi"
set default_file "$theme_dir/default.rasi"

set target_file "$argv[1]"
if test -n "$target_file"
  echo "Switching to $target_file"
  ln -sf "$target_file" "$current_symlink"
  exit 0
end

echo "Switching to $default_file"
ln -sf "$default_file" "$current_symlink"
