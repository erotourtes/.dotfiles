#run to set fish as default shell
#chsh -s $(which fish)

set TERM "alacritty"
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"


alias t="tmux"
alias ta="tmux attach -t"
alias tk="tmux kill-session -t"
alias vim="nvim"
alias l="exa --group-directories-first -1"

bind -M insert \cl "accept-autosuggestion"

function mkfile; mkdir -p $argv[1] && touch $argv[1]/$argv[2]; end
function pd; cd ~/Fedora_HDD/projects/; end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    # fish_hybrid_key_bindings 
end

