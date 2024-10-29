#!/usr/bin/env bash

tmp_dir="/tmp/cliphist"
rm -rf "$tmp_dir"

echo "ROFI_RETV: $ROFI_RETV" >> /tmp/rofi.log

# Check for custom keybinding actions first, regardless of input
case "$ROFI_RETV" in
    10)
        if [[ -n "$1" ]]; then
            cliphist delete <<<"$1"
        fi
        # Return empty list to refresh
        cliphist list | gawk "$prog"
        exit 0
        ;;
    11)
        cliphist wipe
        # Return empty list to refresh
        cliphist list | gawk "$prog"
        exit 0
        ;;
esac

if [[ -n "$1" ]]; then
    # Normal selection - copy to clipboard
    cliphist decode <<<"$1" | wl-copy
    exit 0
fi

mkdir -p "$tmp_dir"

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
    next
}
1
EOF
cliphist list | gawk "$prog"
