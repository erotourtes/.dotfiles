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
end

local M = {
    run = run,
}
return M
