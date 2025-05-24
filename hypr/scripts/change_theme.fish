#!/bin/env fish

set theme_dir ~/.config/hypr/configs

set current_symlink "$theme_dir/colors.conf"
set colors_file "$theme_dir/colors-auto.conf"
set default_file "$theme_dir/colors-default.conf"

set target_file "$argv[1]"
if test -n "$target_file"
  echo "Switching to $target_file"
  ln -sf "$target_file" "$current_symlink"
  exit 0
end

echo "Switching to $default_file"
ln -sf "$default_file" "$current_symlink"
