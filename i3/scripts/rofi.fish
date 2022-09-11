#!/bin/fish

function wifi
  notify-send "Getting list of available Wi-Fi networks..."

  set -l wifiList (nmcli --fields "SECURITY,SSID" dev wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")
  set -l statusWifi "睊 Enable"
  if test "$(nmcli radio wifi)" = "enabled"
    set statusWifi "直 Disable"
  end

  set -l variant (printf %s\n $statusWifi $wifiList | rofi -dmenu -selected-row 1 -p "Wi-Fi: ")
  if test "$variant" = "直 Disable"
    nmcli radio wifi off
  else if test "$variant" = "睊 Enable"
    nmcli radio wifi on
  else
	  set savedConnections $(nmcli -g NAME connection)
    set chosenId (string sub -s 2 "$variant" | string trim)

    if contains "$chosenId" $savedConnections
		  nmcli connection up id "$chosenId" | grep "successfully" && notify-send "Connection Established" 
    # else if  "$chosen_network" =~ "" 
    #   wifi_password=$(rofi -dmenu -p "Password: ")
    # end
    #
    # nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
  end

end

wifi
