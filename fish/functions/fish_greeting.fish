function fish_greeting
  set -l cols (tput cols)
  set -l timestamp (date -u "+%Y-%m-%dT%H:%M:%SZ")
  set -l len (string length -v "$timestamp")
  set -l padding (math "$cols - $len - 1")
  if test $padding -lt 0
      set padding 1
  end

  echo -n (string join '' (set_color yellow) "")
  printf "%*s" $padding ""
  echo (set_color brblack)$timestamp(set_color normal)
end
