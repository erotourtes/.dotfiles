#run to set fish as default shell
#chsh -s $(which fish)

set -gx EDITOR nvim

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
end
