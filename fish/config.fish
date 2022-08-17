#run to set fish as default shell
#chsh -s $(which fish)

set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"


alias t="tmux"
alias ta="tmux attach -t"
alias tk="tmux kill-session -t"
alias v="nvim"

function mkfile; mkdir -p $argv[1] && touch $argv[1]/$argv[2]; end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
end
