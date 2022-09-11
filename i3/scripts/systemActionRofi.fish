#!/bin/fish

function systemAction
  set variant (printf " Power Off\n Restart\n Restart i3\n Suspend\n Lock\n" | rofi -dmenu -i -p "Do: ")

  switch $variant
    case " Power Off"
      sudo shutdown now
    case " Restart"
     i3-msg exit
    case " Restart i3"
     i3-msg exit
    case " Lock"
      i3lock --color "#141414"
    case " Suspend"
      systemctl suspend
  end
end

systemAction
