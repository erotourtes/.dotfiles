#!/usr/bin/env fish

set -l source_dir (realpath (dirname (status filename)))
set -l firefox_dir "$HOME/.mozilla/firefox"
set -l profiles_ini "$firefox_dir/profiles.ini"

if not test -f "$profiles_ini"
    echo "Firefox profiles.ini not found: $profiles_ini" >&2
    exit 1
end

# Read Firefox's installation-specific default profile first.
set -l install_default ""
set -l profile_default ""
set -l section ""

for line in (string split \n -- (cat "$profiles_ini"))
    set line (string trim -- "$line")

    if string match -qr '^\[.*\]$' -- "$line"
        set section "$line"
        continue
    end

    if string match -qr '^\[Install[^]]+\]$' -- "$section"
        if string match -q 'Default=*' -- "$line"
            set install_default (string replace 'Default=' '' -- "$line")
        end
    end
end

if test -n "$install_default"
    if string match -q '/*' -- "$install_default"
        set profile_path "$install_default"
    else
        set profile_path "$firefox_dir/$install_default"
    end
end

if test -z "$profile_path"; or not test -d "$profile_path"
    echo "Could not resolve Firefox installation default profile." >&2
    exit 1
end

set -l chrome_dir "$profile_path/chrome"
mkdir -p "$chrome_dir"

for file in userChrome.css userContent.css
    set -l source "$source_dir/$file"
    set -l target "$chrome_dir/$file"

    if not test -f "$source"
        continue
    end

    if test -L "$target"
        if test (realpath "$target") = "$source"
            echo "Already linked: $file"
            continue
        end
    end

    if test -e "$target"; or test -L "$target"
        echo "Refusing to overwrite existing file: $target" >&2
        exit 1
    end

    ln -s "$source" "$target"
    echo "Linked: $target -> $source"
end

echo "Firefox profile: $profile_path"
echo "Restart Firefox to apply changes."
