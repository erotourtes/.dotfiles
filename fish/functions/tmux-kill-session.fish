function tmux-kill-session
    if test (count $argv) -eq 0
        echo "Usage: tmux-kill-session <session-name>"
        return 1
    end

    for arg in $argv
        set -l name (tmux ls | string split --fields 1 ":")
        set -l selected (printf "%s\n" $name | rg $arg)

        for session in $selected
            echo "Terminating session $session"
            tmux kill-session -t $session
        end
    end
end
