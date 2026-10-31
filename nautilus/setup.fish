#!/usr/bin/env fish

set -l source_dir (realpath (dirname (status filename)))
set -l config_home "$HOME/.config"
set -l data_home "$HOME/.local/share"
if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
    set config_home "$XDG_CONFIG_HOME"
end
if set -q XDG_DATA_HOME; and test -n "$XDG_DATA_HOME"
    set data_home "$XDG_DATA_HOME"
end

for dependency in nautilus xdg-mime systemctl
    if not command -q "$dependency"
        echo "Required command not found: $dependency" >&2
        exit 1
    end
end

set -l sources "$source_dir/hyprland-portals.conf" "$source_dir/nautilus.portal"
set -l targets "$config_home/xdg-desktop-portal/hyprland-portals.conf" \
    "$data_home/xdg-desktop-portal/portals/nautilus.portal"

# Check every destination before making changes. Re-running is safe.
for i in (seq (count $sources))
    if not test -f "$sources[$i]"
        echo "Configuration not found: $sources[$i]" >&2
        exit 1
    end
    if test -L "$targets[$i]"
        if test "$targets[$i]" -ef "$sources[$i]"
            continue
        end
    end
    if test -e "$targets[$i]"; or test -L "$targets[$i]"
        echo "Refusing to overwrite existing file: $targets[$i]" >&2
        echo "Move it aside, then run this script again." >&2
        exit 1
    end
end

for i in (seq (count $sources))
    if test -L "$targets[$i]"
        echo "Already linked: $targets[$i]"
        continue
    end
    mkdir -p (dirname -- "$targets[$i]"); or exit 1
    ln -s -- "$sources[$i]" "$targets[$i]"; or exit 1
    echo "Linked: $targets[$i] -> $sources[$i]"
end

# Update just the folder association, preserving other application defaults.
xdg-mime default org.gnome.Nautilus.desktop inode/directory; or exit 1
echo "Default folder opener: org.gnome.Nautilus.desktop"

if not systemctl --user restart xdg-desktop-portal.service
    echo "Configuration installed, but the desktop portal could not be restarted." >&2
    echo "Log out and back into Hyprland to activate the file chooser." >&2
    exit 1
end

echo "Nautilus is now the file chooser for portal-enabled apps in Hyprland."
echo "Restart applications that still show their previous file dialog."
