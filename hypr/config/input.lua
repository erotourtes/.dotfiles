---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    hl.config({
        input = {
            kb_layout = "us,ua",
            kb_variant = "altgr-intl,",
            kb_model = "",
            kb_options = "grp:ctrls_toggle",
            kb_rules = "",
            repeat_delay = 220,
            repeat_rate = 30,
            follow_mouse = 1,
            touchpad = {
                natural_scroll = true,
            },
            tablet = {
                output = "current",
            },
        },
        gestures = {
            workspace_swipe_forever = true,
            workspace_swipe_cancel_ratio = 0.3,
        },
    })

    hl.device({
        name = "dell08e0:00-06cb:cd97-touchpad",
        sensitivity = 0.35,
        accel_profile = "adaptive",
    })
end

local M = {
    run = run,
}
return M
