local helpers = require("./config/helpers")

---@type fun(ctx: HyprConfigContext): nil
local run
---@type fun(ctx: HyprConfigContext): nil
local register_hy3_binds

---@param ctx HyprConfigContext
run = function(ctx)
    local hy3 = ctx.plugins.hy3
    if not hy3 then
        return
    end

    hl.config({
        general = {
            layout = "hy3",
        },
        plugin = {
            hy3 = {
                group_inset = 0,
                tabs = {
                    height = 5,
                    padding = 6,
                    render_text = false,

                    colors = {
                        active = ctx.colors.accent,
                        active_border = ctx.colors.accent,
                    },
                },
                autotile = {
                    enable = true,
                    trigger_width = 800,
                    trigger_height = 500,
                    workspaces = "6",
                },
            },
        },
    })

    register_hy3_binds(ctx)
end

---@param ctx HyprConfigContext
register_hy3_binds = function(ctx)
    local hy3 = ctx.plugins.hy3
    if not hy3 then
        return
    end
    local bind = helpers.debug_bind(ctx, "config/hy3.lua")
    local k = helpers.combine_keys
    local mod = ctx.keys.mod

    bind(k(mod, "SHIFT", "q"), hy3.kill_active())

    bind(k(mod, "h"), hy3.move_focus("l"))
    bind(k(mod, "j"), hy3.move_focus("d"))
    bind(k(mod, "k"), hy3.move_focus("u"))
    bind(k(mod, "l"), hy3.move_focus("r"))

    bind(k(mod, "CTRL", "h"), hy3.move_focus("l", { visible = true, warp = false }))
    bind(k(mod, "CTRL", "j"), hy3.move_focus("d", { visible = true, warp = false }))
    bind(k(mod, "CTRL", "k"), hy3.move_focus("u", { visible = true, warp = false }))
    bind(k(mod, "CTRL", "l"), hy3.move_focus("r", { visible = true, warp = false }))

    bind(k(mod, "SHIFT", "h"), hy3.move_window("l", { once = true }))
    bind(k(mod, "SHIFT", "j"), hy3.move_window("d", { once = true }))
    bind(k(mod, "SHIFT", "k"), hy3.move_window("u", { once = true }))
    bind(k(mod, "SHIFT", "l"), hy3.move_window("r", { once = true }))

    bind(k(mod, "CTRL", "SHIFT", "h"), hy3.move_window("l", { once = true, visible = true }))
    bind(k(mod, "CTRL", "SHIFT", "j"), hy3.move_window("d", { once = true, visible = true }))
    bind(k(mod, "CTRL", "SHIFT", "k"), hy3.move_window("u", { once = true, visible = true }))
    bind(k(mod, "CTRL", "SHIFT", "l"), hy3.move_window("r", { once = true, visible = true }))

    for i = 1, 10 do
        local key = tostring(i % 10)
        bind(k(mod, "SHIFT", key), hy3.move_to_workspace(tostring(i)))
    end

    bind(k("mouse_down"), hy3.focus_tab({ direction = "l", mouse = "require_hovered" }), { non_consuming = true })
    bind(k("mouse_up"), hy3.focus_tab({ direction = "r", mouse = "require_hovered" }), { non_consuming = true })
    bind(k(mod, "space"), hy3.toggle_focus_layer({ warp = false }))

    bind(k(mod, "g"), hy3.make_group("h"))
    bind(k(mod, "v"), hy3.make_group("v"))
    bind(k(mod, "CTRL", "w"), hy3.make_group("tab", { toggle = true }))
    bind(k(mod, "w"), hy3.change_group("toggletab"))
    bind(k(mod, "a"), hy3.change_focus("raise"))
    bind(k(mod, "SHIFT", "a"), hy3.change_focus("lower"))
    bind(k(mod, "e"), hy3.expand("expand"))
    bind(k(mod, "SHIFT", "e"), hy3.expand("shrink"))
    bind(k(mod, "r"), hy3.change_group("opposite"))

    for i = 1, 5 do
        bind(k(mod, "CTRL", i), hy3.focus_tab({ index = i }))
    end

    bind(k(mod, "CTRL", "c"), hy3.lock_tab())
    bind(k(mod, "q"), hy3.warp_cursor())
end

local M = {
    run = run,
}
return M
