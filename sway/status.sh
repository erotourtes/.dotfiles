# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01). Check `man date` on how to format
# time and date.
date_formatted=$(date "+%Y-%m-%d %a")
time=$(date "+%I:%M:%S %p")

# "upower --enumerate | grep 'BAT'" gets the battery name (e.g.,
# "/org/freedesktop/UPower/devices/battery_BAT0") from all power devices.
# "upower --show-info" prints battery information from which we get
# the state (such as "charging" or "fully-charged") and the battery's
# charge percentage. With awk, we cut away the column containing
# identifiers. i3 and sway convert the newline between battery state and
# the charge percentage automatically to a space, producing a result like
# "charging 59%" or "fully-charged 100%".
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "state" | awk '{print $2}')

# "amixer -M" gets the mapped volume for evaluating the percentage which
# is more natural to the human ear according to "man amixer".
# Column number 4 contains the current volume percentage in brackets, e.g.,
# "[36%]". Column number 6 is "[off]" or "[on]" depending on whether sound
# is muted or not.
# "tr -d []" removes brackets around the volume.
# Adapted from https://bbs.archlinux.org/viewtopic.php?id=89648
audio_volume=$(amixer -M get Master | grep -oE "[0-9]+%" | head -n 1)
audio_volume_icon=$(amixer -M get Master |  awk 'NR==6 && /\[.*\]/ {print $6}')

brightness=$(brightnessctl | grep -oE "[0-9]+%")

# Additional emojis and characters for the status bar:
# Electricity: ⚡ ↯ ⭍ 🔌
# Audio: 🔈 🔊 🎧 🎶 🎵 🎤
# Separators: \| ❘ ❙ ❚
# Misc: 🐧 💎 💻 💡 ⭐ 📁 ↑ ↓ ✉ ✅ ❎

network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}' | sort | uniq)

if ! [ $network ]
then
   network_active="⛔"
else
   network_active="⇆"
fi

if [ $battery_status = "discharging" ];
then
    battery_pluggedin='⚡'
else
    battery_pluggedin=''
fi

if [ $audio_volume_icon = "[off]" ];
then
    audio_volume_icon=''
    audio_volume=0
elif [ $audio_volume -lt 33 ];
then
    audio_volume_icon=''
elif [ $audio_volume -lt 66 ];
then
    audio_volume_icon=''
else
    audio_volume_icon=''
fi

media_title=$(playerctl metadata title)

micro=$(amixer get Capture | grep -q '\[off\]' && echo "󰍭" || echo "󰍬")

echo "$time | $micro | $audio_volume_icon $audio_volume | 󰃚 $brightness | $battery_pluggedin  $battery_charge |  $date_formatted | $network_active $interface_easyname"
