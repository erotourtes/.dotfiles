function tmux-sessionizer -d "Switch to tmux session"
    set -l selected (printf "%s\n" \
            (fd --max-depth=2 --min-depth=1 --type=d . ~/Documents/projects ~/.config) \
            (echo "$HOME/.config") \
            | fzf)
    if test -z $selected; echo Canceled; return 0; end

    set -l dir_name (string sub --length 2 (basename (dirname $selected)))
    set -l base_name (string sub --length 5 (basename $selected))

    set -l selected_name  $dir_name/$base_name
    set -l selected_name (echo $selected_name | tr . _)

    # not in tmux
    if test -z $TMUX
        if tmux has-session -t=$selected_name 2> /dev/null
            echo "Not in tmux: attaching to a session $selected_name"
            tmux attach -t $selected_name
        else
            echo "Not in tmux: creating a session $selected_name"
            tmux new-session -s $selected_name -c $selected
        end
        return 0
    end

    # in tmux, but don't have a session
    if not tmux has-session -t=$selected_name 2> /dev/null
        echo "In tmux: creating a session $selected_name"
        tmux new-session -ds $selected_name -c $selected
    end

    echo "Switching to the session $selected_name"
    tmux switch-client -t $selected_name
end 
