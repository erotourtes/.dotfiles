status is-interactive || exit

function fish_user_key_bindings
  bind -M insert \cl "accept-autosuggestion"
  bind -M insert \cp "clear -x && commandline -f repaint"

  bind -M insert \cr "_fzf_search_history"
  bind -M insert \e\cl "_fzf_search_git_log" # alt + ctrl + l

  for mode in (bind --list-modes)
      bind -M $mode ctrl-c cancel-commandline
  end
end

fish_vi_key_bindings

set fish_cursor_default     block
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_replace     underscore
set fish_cursor_visual      block

abbr --add --global -- ge "git checkout"
abbr --add --global -- gps "gh copilot suggest"
abbr --add --global -- gs "git status --short"
abbr --add --global -- ga "git add"
abbr --add --global -- gp "git push"
abbr --add --global -- gpf "git push --force-with-lease"
abbr --add --global -- gl "git pull"
abbr --add --global -- gm "git commit"
abbr --add --global -- c "clear"
abbr --add --global -- s "sudo"
