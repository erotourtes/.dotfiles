---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.config({
        general = {
            layout = "dwindle",
        },
        dwindle = {
            preserve_split = true,
        }
    })
end

local M = {
    run = run,
}
return M
