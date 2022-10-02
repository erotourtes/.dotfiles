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
alias gs="git status --short"

bind -M insert \cl "accept-autosuggestion"

function fdf 
  # set -l options (fish_opt -s n -l name --required-val)
  # argparse $options -- $argv
  set -l path "./"
  set -l options "h/help" 
  set options $options "o/open-dir" 
  set options $options (fish_opt -s p -l path --required-val)
  argparse $options -- $argv
  if set -q _flag_help; echo "Default path:" $path \n$options; return 0; end
  if set -q _flag_path; set path $_flag_path; end
  if test -e $argv[1]; set path $argv[1]; end


  set file (find $path -not -path '*/.*'  -type f -iname '*' -not -iname '*.jpg' -not -iname '*.png' | fzf)

  if set -q _flag_open_dir;
    cd (string replace -r '(\/.[^\/]+)$' "\/" $file);
    return 0;
  end


  if test -e "$file"; vim $file; end
end

function fd
  set -l path ~/Fedora_HDD/projects/
  set -l options "h/help" 
  set options $options (fish_opt -s p -l path --required-val)
  argparse $options -- $argv
  if set -q _flag_help; echo "Default path:" $path \n$options; return 0; end
  if set -q _flag_path; set path $_flag_path; end
  if test -e $argv[1]; set path $argv[1]; end

  echo $path

  cd (find $path -not -path '*/.*'  -type d -iname '*' | fzf)
end

function mkfile; mkdir -p $argv[1] && touch $argv[1]/$argv[2]; end
function pd; cd ~/Fedora_HDD/projects/; end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    # fish_hybrid_key_bindings 
end

