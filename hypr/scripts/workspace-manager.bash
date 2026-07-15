#!/usr/bin/env bash
# Manage named Hyprland workspaces without changing workspace on creation.

set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/named-workspaces"
harpoon_dir="$state_dir/workspace-harpoons"

notify() {
    command -v notify-send >/dev/null && notify-send "Named workspaces" "$1"
}

valid_name() {
    local pattern='^[[:alnum:]][[:alnum:] _.:_-]*$'
    [[ $1 =~ $pattern ]]
}

save_name() {
    mkdir -p "$state_dir"
    touch "$state_file"
    if ! grep -Fqx -- "$1" "$state_file"; then
        printf '%s\n' "$1" >>"$state_file"
    fi
}

workspace_names() {
    {
        [[ -f $state_file ]] && cat "$state_file"
        hyprctl workspaces -j 2>/dev/null |
            jq -r '.[] | .name | select(test("^[0-9]+$") | not)' 2>/dev/null || true
    } | sed '/^$/d' | LC_ALL=C sort -fu
}

choose_workspace() {
    local prompt=$1
    workspace_names | rofi -dmenu -i -p "$prompt"
}

create_workspace() {
    local name
    name=$(rofi -dmenu -p 'New workspace') || return
    name=$(printf '%s' "$name" | xargs)

    [[ -n $name ]] || return

    if ! valid_name "$name"; then
        notify 'Use letters, digits, spaces, dots, colons, underscores, or hyphens.'
        return 1
    fi

    save_name "$name"
    notify "Saved \"$name\". Move a window there when ready."
}

move_active_window() {
    local name
    name=$(choose_workspace 'Move window to') || return
    [[ -n $name ]] || return

    valid_name "$name" || {
        notify 'That workspace name contains unsupported characters.'
        return 1
    }

    save_name "$name"
    # follow=false keeps the current workspace focused.
    hyprctl dispatch "hl.dsp.window.move({ workspace = \"name:$name\", follow = false })"
}

focus_workspace() {
    local name
    name=$(choose_workspace 'Go to workspace') || return
    [[ -n $name ]] || return

    valid_name "$name" || {
        notify 'That workspace name contains unsupported characters.'
        return 1
    }

    save_name "$name"
    hyprctl dispatch "hl.dsp.focus({ workspace = \"name:$name\" })"
}

forget_workspace() {
    local name tmp
    name=$(choose_workspace 'Forget saved workspace') || return
    [[ -n $name && -f $state_file ]] || return

    tmp=$(mktemp "${state_file}.XXXXXX")
    grep -Fvx -- "$name" "$state_file" >"$tmp" || true
    mv "$tmp" "$state_file"
}

choose_harpoon_slot() {
    local slot name
    for slot in 1 2 3 4; do
        if [[ -f $harpoon_dir/$slot ]]; then
            name=$(<"$harpoon_dir/$slot")
        else
            name=''
        fi
        printf '%s  %s\n' "$slot" "$name"
    done | rofi -dmenu -i -p 'Harpoon slot'
}

set_harpoon() {
    local slot name
    slot=$(choose_harpoon_slot) || return
    slot=${slot%% *}
    [[ $slot =~ ^[1-4]$ ]] || return

    name=$(choose_workspace "Workspace for harpoon $slot") || return
    [[ -n $name ]] || return
    valid_name "$name" || {
        notify 'That workspace name contains unsupported characters.'
        return 1
    }

    mkdir -p "$harpoon_dir"
    printf '%s\n' "$name" >"$harpoon_dir/$slot"
    save_name "$name"
    notify "Harpoon $slot set to \"$name\"."
}

go_to_harpoon() {
    local slot=$1 name
    [[ $slot =~ ^[1-4]$ && -f $harpoon_dir/$slot ]] || {
        notify "Harpoon $slot is not set."
        return 1
    }

    name=$(<"$harpoon_dir/$slot")
    valid_name "$name" || {
        notify "Harpoon $slot has an invalid workspace name."
        return 1
    }

    hyprctl dispatch "hl.dsp.focus({ workspace = \"name:$name\" })"
}

case ${1:-menu} in
    create)
        create_workspace
        ;;
    move)
        move_active_window
        ;;
    go)
        focus_workspace
        ;;
    forget)
        forget_workspace
        ;;
    harpoon-set)
        set_harpoon
        ;;
    harpoon-go)
        go_to_harpoon "${2:-}"
        ;;
    menu)
        action=$(printf '%s\n' \
            'Create workspace' \
            'Move active window' \
            'Go to workspace' \
            'Forget saved workspace' \
            'Set workspace harpoon' |
            rofi -dmenu -i -p 'Workspaces') || exit 0

        case $action in
            'Create workspace') create_workspace ;;
            'Move active window') move_active_window ;;
            'Go to workspace') focus_workspace ;;
            'Forget saved workspace') forget_workspace ;;
            'Set workspace harpoon') set_harpoon ;;
        esac
        ;;
    *)
        exit 2
        ;;
esac
