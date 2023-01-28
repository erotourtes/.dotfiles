function fdf 
  # set -l options (fish_opt -s n -l name --required-val)
  # argparse $options -- $argv
  set -l path "./"
  set -l options "h/help" 
  set options $options "o/open-file" 
  set options $options "a/all" 
  set options $options (fish_opt -s p -l path --required-val)
  argparse $options -- $argv
  if set -q _flag_help; echo "Default path:" $path \n$options; return 0; end
  if set -q _flag_path; set path $_flag_path; end
  if test -n "$argv[1]"; and test -e "$argv[1]"; set path $argv[1]; end

  # set file (find $path -not -path '*/.*'  -type f -iname '*' -not -iname '*.jpg' -not -iname '*.png' | fzf)
  if set -q _flag_all
    set file $path(fd --base-directory $path -t f | fzf)
  else 
    set file $path(fd --base-directory $path -t f -E "*.png" -E "*.jpg" | fzf)
  end

  if set -q _flag_open_file;
    if test -e "$file"; xdg-open $file; end
  else if test -e "$file" 
    cd (string replace -r '(\/.[^\/]+)$' "\/" $file);
  else
    echo "Canceled"
  end
end
