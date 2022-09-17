#!/usr/bin/fish

function i3lockBg 
  set picture_path ~/.config/i3/scripts/screen.png

  flameshot screen -n 0 --path $picture_path

  i3lock -t -i $picture_path -p default -u --color "#141414"

  rm $picture_path
end

i3lockBg
