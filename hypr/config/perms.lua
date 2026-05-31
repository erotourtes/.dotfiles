-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.config({
        ecosystem = {
            enforce_permissions = true,
        },
    })

    hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
    hl.permission("/usr/(bin|local/bin)/flameshot", "screencopy", "allow")
    hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
    hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
    hl.permission({ binary = "/usr/(bin|local/bin)/hyprlock", type = "screencopy", mode = "allow" })
    hl.permission({ binary = "~/Documents/Apps/wl-kbptr/bin/wl-kbptr", type = "screencopy", mode = "allow" })
end

local M = {
    run = run,
}
return M
