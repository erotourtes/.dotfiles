#!/usr/bin/fish

function blurI3
  set picture_path ~/.config/i3/scripts/screen.jpg
  set -l tempPicture ~/.config/i3/scripts/temp.png

  flameshot screen -n 0 --path $picture_path

# ~~ 2s
  # convert $picture_path -virtual-pixel Black -scale 10% -resize 1000% -blur 0x5  $tempPicture

# ~~ 600ms
  convert $picture_path -scale 10% -blur 0x2.5 -resize 1000% $tempPicture

# ~~ 522ms
  # convert $picture_path -scale 2.5% -gaussian-blur 0x2.5 -resize 4000% $tempPicture
  # convert $picture_path -scale 2.5% -blur 0x2.5 -resize 4000% $tempPicture

  i3lock -t -i $tempPicture 

  rm $picture_path
  rm $tempPicture
end

blurI3
