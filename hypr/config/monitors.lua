-- See https://wiki.hyprland.org/Configuring/Monitors/
---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
    hl.monitor({ output = ctx.monitors.secondary, mode = "preferred", position = "auto-up", scale = "auto" })
    hl.monitor({ output = ctx.monitors.primary, mode = "preferred", position = "0x0", scale = "auto" })
end

local M = {
    run = run,
}
return M
