function fish_prompt
    echo (fish_git_prompt) (paint_last_path)\n(paint_arrow)
end

function paint_last_path
    echo -n (set_color white)"~$(pwd)"(set_color normal)
end

function paint_arrow
    echo -n (set_color bryellow)'  '(set_color normal)
end
