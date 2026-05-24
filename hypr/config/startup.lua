---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.env("XCURSOR_SIZE", "24")
    hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

    hl.env("CLUTTER_BACKEND", "wayland")
    hl.env("GDK_BACKEND", "wayland,x11")

    hl.env("QT_QPA_PLATFORM", "wayland;xcb")
    hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
    hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_TYPE", "wayland")
    hl.env("MOZ_ENABLE_WAYLAND", "1")

    hl.on("hyprland.start", function()
        -- start hyprland-session.target as a hack
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE")
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE")
        hl.exec_cmd("systemctl --user start hyprland-session.target")

        hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

        hl.exec_cmd("hyprpm reload -n")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("systemctl --user start hyprpolkitagent")

        hl.exec_cmd(os.getenv("HOME") .. "/Documents/Apps/python/.venv/bin/safeeyes")
        hl.exec_cmd(os.getenv("HOME") .. "/.cargo/bin/xremap " .. os.getenv("HOME") .. "/.config/xremap/config.yml --watch=device")
        hl.exec_cmd("waybar")
        hl.exec_cmd("firefox", { workspace = "2 silent" })
        hl.exec_cmd("XDG_CURRENT_DESKTOP=sway flameshot")
        hl.exec_cmd(ctx.dirs.scripts .. "/Wallpaper.sh random")
        hl.exec_cmd("safeeyes")

        hl.exec_cmd("wl-paste --type text --watch cliphist store")
        hl.exec_cmd("wl-paste --type image --watch cliphist store")

        hl.dispatch(hl.dsp.focus({ workspace = 2 }))
    end)
end

local M = {
    run = run,
}
return M
