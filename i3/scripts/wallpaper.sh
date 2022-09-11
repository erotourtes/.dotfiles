#!/usr/bin/fish


if test (pgrep -c wallpaper.sh) -gt 1
  echo it\'s running
  return 1 
end

echo running

set picture_path ~/Fedora_HDD/Pictures/wallpapers/
if not test -e ~/Fedora_HDD/Pictures/wallpapers/
  set picture_path (find ~/ -type d -name Pictures -not -path "*/.*" | xargs -I {} find "{}" -type d -iname wallpapers)
end

while true
  feh --bg-fill --randomize $picture_path*
  sleep 1h 
end
