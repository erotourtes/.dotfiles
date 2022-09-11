#!/bin/fish

function findFunc
   set -f file (rofi -dmenu -p "Search for: ")
   set -f filePaths (find ~/ -not -path '*/.*' -type f -iname "$file*")
   if test (count $filePaths) -gt 0
    open (printf %s\n  $filePaths | rofi -dmenu -p "Search for: ")
   end
end

findFunc
