#!/usr/bin/fish

function chooseWallpaper 
  set picturesPath ~/Fedora_HDD/Pictures/wallpapers/Favourites/

  set picturesNames (ls $picturesPath)
  set chosen (printf %s\n $picturesNames | rofi -dmenu -p "Choose: ")

  feh --bg-fill $picturesPath$chosen
end


chooseWallpaper
