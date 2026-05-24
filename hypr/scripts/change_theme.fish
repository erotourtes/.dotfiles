#!/bin/env fish

set theme_dir ~/.config/hypr/config

set current_symlink "$theme_dir/colors.lua"
set colors_file "$theme_dir/colors-auto.lua"
set default_file "$theme_dir/colors-default.lua"

set target_file "$argv[1]"
if test -n "$target_file"
  echo "Switching to $target_file"
  ln -sf "$target_file" "$current_symlink"
  exit 0
end

echo "Switching to $default_file"
ln -sf "$default_file" "$current_symlink"
