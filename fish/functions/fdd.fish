function fdd
  set -l path ~/Files/Documents/projects/
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
