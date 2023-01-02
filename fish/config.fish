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
alias ll="ls -l --group-directories-first -h"
alias gs="git status --short"
alias clear="clear -x"

bind -M insert \cl "accept-autosuggestion"

function fdf 
  # set -l options (fish_opt -s n -l name --required-val)
  # argparse $options -- $argv
  set -l path "./"
  set -l options "h/help" 
  set options $options "o/open-file" 
  set options $options (fish_opt -s p -l path --required-val)
  argparse $options -- $argv
  if set -q _flag_help; echo "Default path:" $path \n$options; return 0; end
  if set -q _flag_path; set path $_flag_path; end
  if test -n "$argv[1]"; and test -e "$argv[1]"; set path $argv[1]; end

  # set file (find $path -not -path '*/.*'  -type f -iname '*' -not -iname '*.jpg' -not -iname '*.png' | fzf)
  set file (fd --base-directory $path -t f -E "*.png" -E "*.jpg" | fzf)

  if set -q _flag_open_file;
    if test -e "$file"; vim $file; end
  else if test -e "$file" 
    cd (string replace -r '(\/.[^\/]+)$' "\/" $file);
  else
    echo "Canceled"
  end
end

function fdd
  set -l path ~/Fedora_HDD/Documents/projects/
  set -l options "h/help" 
  set options $options "a/all" 
  set options $options (fish_opt -s p -l path --required-val)
  argparse $options -- $argv
  if set -q _flag_help; echo "Default path:" $path \n$options; return 0; end
  if set -q _flag_path; set path $_flag_path; end

  echo $path

  if set -q _flag_all
    cd (fd --base-directory $path -H -I -t d | fzf)
  else
    cd $path/(fd --base-directory  $path -t d | string split -n $path | fzf)
  end
end

function mkfile; mkdir -p $argv[1] && touch $argv[1]/$argv[2]; end
function pd; cd ~/Fedora_HDD/Documents/projects/; end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    # fish_hybrid_key_bindings 
end



# Prompt functions

function fish_prompt
    echo (fish_git_prompt) '~'(pwd)\n '  ' 
end

function fish_greeting
  echo (set_color yellow) ""
end

function fish_mode_prompt --description 'displays the current mode'
                        # Do nothing if not in vi mode
                        if test "$fish_key_bindings" = "fish_vi_key_bindings"
                            switch $fish_bind_mode
                                case default
                                    set_color --bold "F55D3E"  
                                    echo N
                                case insert
                                    set_color --bold yellow
                                    echo I
                                 case replace
                                     set_color --bold "04A777"
                                     echo R
                                case visual
                                    set_color --bold "8AFFC1"
                                    echo V
                            end
                            set_color normal
                            printf " "
                        end
                    end
