#!/usr/bin/env bash

languages=$(echo "bash c cpp css docker go html java javascript json lua markdown perl php python ruby rust sql swift typescript vim yaml" | tr " " "\n")
core_utils=$(echo "find xargs git grep sed awk curl wget" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "Enter your query: " query

if echo "$languages" | grep -qs $selected; then
  tmux split-window -h -p 32 bash -c "curl cht.sh/$selected/$(echo $query | tr " " "+") | less -R"
else
  tmux split-window -h -p 32 bash -c  "curl cht.sh/$selected~$query | less -R"
fi
