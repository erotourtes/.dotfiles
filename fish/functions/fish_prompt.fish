function fish_prompt
    # Capture exit code of last command
    set -l exit_code $status

    if not set -q __prompt_on; or test "$__prompt_on" = 0
      echo (fish_git_prompt) (paint_last_path)\n(paint_arrow)
      return
    end

    # venv
    set -l venv_str ''
    set -U VIRTUAL_ENV_DISABLE_PROMPT 1
    if set -q VIRTUAL_ENV
        set venv_str (string join '' (set_color blue) "(" (basename $VIRTUAL_ENV) ")" (set_color normal))
    end

    # Left-aligned prompt content
    set -l left_str (string join '' "$venv_str" (fish_git_prompt))
    if test -n "$left_str"
      set left_str "$left_str "
    else
      set left_str ""
    end
    set left_str "$left_str"(paint_last_path)

    echo -n "$left_str"

    # Right-aligned execution time and timestamp
    set -l timestamp (date "+%H:%M:%S")
    set -l duration (format_duration)
    set -l exit_color

    if test $exit_code -eq 0
        set exit_color green
    else
        set exit_color red
    end

    # Calculate padding for right alignment
    set -l right_str (string join ' ' \
        (set_color brblack)"$timestamp"(set_color normal) \
        (set_color "$exit_color")"$duration"(set_color normal) \
    )

    set -l cols (tput cols)
    set -l left_len (visible_length "$left_str")
    set -l right_len (visible_length "$right_str")
    set -l padding (math "$cols - $left_len - $right_len")

    if test $padding -lt 0
        set padding 1
    end

    # Right content
    printf "%*s" $padding ""
    echo -n "$right_str"

    # Bottom content
    echo -n \n(paint_arrow)

    # echo Cols: $cols, L: $left_len, R: $right_len, Padding: $padding
end

function paint_last_path
    echo -n (set_color white)"~$(pwd)"(set_color normal)
end

function paint_arrow
    echo -n (set_color bryellow)'  '(set_color normal)
end

function format_duration --description 'Format $CMD_DURATION to fixed-width string'
    set -l ms $CMD_DURATION
    set -l s (math "$ms / 1000")   # seconds as float
    set -l s_int (math "floor($s)") # integer seconds

    if test $s_int -lt 60
        # Display seconds with fixed width
        printf "%3ds" $s_int
    else
        # Convert to minutes, round
        set -l m (math "($s + 30) / 60")   # add 30 to round
        set -l m_int (math "floor($m)")
        printf "%3dm" $m_int
    end
end

function visible_length --description 'Return length of string without color codes'
    string join '' $argv | string replace -r '\e\[[0-9;]*m' '' | string length -v
end
