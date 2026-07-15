---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.config({
        general = {
            -- layout = "scrolling",
            -- layout = "dwindle",
            layout = "master",
        },
        dwindle = {
            preserve_split = true,
        },
        scrolling = {
            fullscreen_on_one_column = true,
            column_width = 1.0,
            direction = "right",
            explicit_column_widths = "1.0"
        }
    })
end

local M = {
    run = run,
}
return M
