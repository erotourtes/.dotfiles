#!/usr/bin/fish

function blurI3
  set picture_path ~/.config/i3/scripts/screen.png
  set -l tempPicture ~/.config/i3/scripts/temp.png 

  flameshot screen --path $picture_path
  ffmpeg -y -i $picture_path -vf "gblur=sigma=20:steps=6" -c:a copy $tempPicture

  i3lock -i $tempPicture -p default

  rm $picture_path
  rm $tempPicture
end

function i3lockBg 
  set picture_path ~/.config/i3/scripts/screen.png

  sleep 0.1s
  flameshot screen --path $picture_path

  i3lock -i $picture_path -p default -u --color "#141414"
  rm $picture_path
end

i3lockBg
