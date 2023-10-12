#!/bin/fish

set picture ~/Pictures/
set lastScreen (l $picture | rg clipboard |rg -o "\d")[-1]
set newScreen (math $lastScreen + 1)
if not test -n "$newScreen"
  echo "File do not exist, setting newScreen to 0"
  set newScreen 0
end

set picture $picture'clipboard'$newScreen'.png'

xclip -selection clipboard -target image/png -out > $picture && open $picture 

rm $picture
