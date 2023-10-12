#!/bin/bash

# Define the list of Spanish letters and their English keyboard substitutions
letters=(
    "a:á"
    "e:é"
    "i:í"
    "o:ó"
    "u:ú"
    "n:ñ"
    "ud:ü"
    "!:¡"
    "?:¿"
)

# Use rofi to display the list and select a letter
selected_letter=$(printf "%s\n" "${letters[@]}" | cut -d':' -f1 | dmenu -p "Select Spanish Letter:")

# Find the corresponding English keyboard substitution
substitution=$(printf "%s\n" "${letters[@]}" | rg "^$selected_letter:" | cut -d':' -f2)

# Copy the substituted text to the clipboard using wl-copy
echo -n "$substitution" | wl-copy
