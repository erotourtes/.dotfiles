#!/bin/bash

# Name of the script
name=$(basename "$0")

# Check if wl-clipboard is installed
if ! command -v wl-copy &>/dev/null; then
  notify-send -a "$name" "Error: wl-clipboard is not installed. Please install it."
  exit 1
fi

# Copy the clipboard contents to a temporary file
temp_file=$(mktemp /tmp/clipboard_image_XXXXXX.png)
wl-paste -t"image/png" > "$temp_file"

# Check if the clipboard contains an image
if [ -s "$temp_file" ]; then
  xdg-open "$temp_file"
else
  notify-send -a "$name" "No image found in the clipboard."
fi

# Clean up the temporary file
# rm -f "$temp_file"
