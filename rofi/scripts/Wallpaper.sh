#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# This script for selecting wallpapers (SUPER W)

# Wallpapers Path
wallpaperDir="$HOME/Pictures/Wallpapers"
themesDir="$HOME/.config/rofi/themes"

# Transition config
FPS=60
TYPE="grow"
DURATION=1
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER} --transition-pos 0.854,0.977"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files as a list
PICS=($(find -L "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort ))

# Use date variable to increase randomness
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"
randomChoice="[${#PICS[@]}] Random"

PICS=("$randomPicture" "${PICS[@]}")

# Rofi command
rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper-select.rasi"

# Execute command according the wallpaper manager
executeCommand() {

  if command -v swww &>/dev/null; then
    swww img "$1" ${SWWW_PARAMS}

  elif command -v swaybg &>/dev/null; then
    swaybg -i "$1" &

  else
    echo "Neither swww nor swaybg are installed."
    exit 1
  fi

  ln -sf "$1" ~/.config/current-wallpaper
}

# Show the images
menu() {
  for i in "${!PICS[@]}"; do
    if [[ $i -eq 0 ]]; then
        picture="$randomPicture"
        placeholder="$randomChoice"
    else
        picture="${PICS[$i]}"
        placeholder=$(basename "$picture" | cut -d. -f1)
    fi

    # If not *.gif, display
    if [[ -z $(echo "$picture" | grep .gif$) ]]; then
      printf "$placeholder\x00icon\x1f$picture\n"
    else
    # Displaying .gif to indicate animated images
      printf "$(basename "$picture")\n"
    fi
  done
}

# If swww exists, start it
if command -v swww &>/dev/null; then
  swww query || swww-daemon &
fi

# Execution
main() {
  if [[ "$1" == "random" ]]; then
    choice="$randomChoice"
  else
    choice=$(menu | ${rofiCommand})
  fi

  # No choice case
  if [[ -z $choice ]]; then
    exit 1
  fi

  # Random choice case
  if [ "$choice" = "$randomChoice" ]; then
    executeCommand "${randomPicture}"
    return 0
  fi

  # Find the selected file
  for file in "${PICS[@]}"; do
  # Getting the file
    if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]]; then
      selectedFile="$file"
      break
    fi
  done

  # Check the file and execute
  if [[ -n "$selectedFile" ]]; then
    executeCommand "${selectedFile}"
    return 0
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main "$@"

