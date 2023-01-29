function add -d "Create a new file or directory"
    set -l options "h/help" "o/open"
    argparse $options -- $argv
    if set -q _flag_help; echo $options; return 0; end
 

    set -l path $argv[1]

    if test -z $path
        echo "path is null"
        return 1
    end

    if test (string sub -s -1 $path) = "/"
        mkdir -p $path
    else
        set dir (dirname $path)

        mkdir -p $dir
        touch $path
    end

    if set -q _flag_open; cd (dirname $path); end;
end
