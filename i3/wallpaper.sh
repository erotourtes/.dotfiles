#!/bin/bash

#run chmod u+x wallpaper
if [ "$(pgrep -c wallpaper.sh)" -gt "1" ]; then
  exit 1;
fi

while true
do
    feh --bg-fill --randomize /home/sirmax/Fedora_HDD/Pictures/wallpapers/* 
    echo running;
    sleep 1h
done
