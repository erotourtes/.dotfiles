#!/usr/bin/fish

function favouriteWallpaper 
  set picturesPath ~/Fedora_HDD/Pictures/wallpapers/Favourites/
  feh --bg-fill --randomize $picturesPath*
end

favouriteWallpaper 
