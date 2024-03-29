#!/usr/bin/fish


if test (pgrep -c wallpaper.fish) -gt 1
  echo it\'s running
  return 1 
end

echo running

set picture_path ~/Pictures/Wallpapers/
if not test -e ~/Fedora_HDD/Pictures/wallpapers/Favourites/ 
  set picture_path (find ~/ -type d -name Pictures -not -path "*/.*" | xargs -I {} find "{}" -type d -iname wallpapers)
end

while true
  feh --bg-fill --randomize $picture_path*
  sleep 1h 
end
