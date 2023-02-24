function tmux-attach
    if test (count $argv) -eq 0
        echo "Usage: tmux-attach <session-name>"
        return 1
    end

    set -l name (tmux ls | string split --fields 1 ":")
    set -l str (echo $argv[1] | sed 's/\(.\{1\}\)/\1.*/g')
    set -l selected (printf "%s\n" $name | rg -i "$str")
    echo "Attaching to $selected"
    tmux attach -t $selected
end
