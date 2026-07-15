---@type fun(ctx: HyprConfigContext): nil
local run
---@type fun(ctx: HyprConfigContext): nil
local animations
---@type fun(ctx: HyprConfigContext): nil
local layers

local colors = {
    inactive = "rgba(595959aa)"
}

---@type fun(ctx: HyprConfigContext): nil
run = function(ctx)
    hl.config({
        general = {
            gaps_in = 3,
            gaps_out = 5,
            border_size = 2,
            col = {
                active_border = ctx.colors.accent,
                inactive_border = colors.inactive,
            },
            resize_on_border = true,
            extend_border_grab_area = 25,
        },
        group = {
            auto_group = true,
            col = {
                border_active = ctx.colors.accent,
                border_inactive = colors.inactive,
                border_locked_active = ctx.colors.accent_alt,
                border_locked_inactive = colors.inactive,
            },
            groupbar = {
                enabled = true,
                indicator_height = 5,
                render_titles = false,
                col = {
                    active = ctx.colors.accent,
                    inactive = colors.inactive,
                    locked_active = ctx.colors.accent_alt,
                    locked_inactive = colors.inactive,
                },
            },
        },
        decoration = {
            rounding = 5,
            blur = {
                enabled = true,
                size = 7,
                passes = 4,
                noise = 0.008,
                contrast = 0.8916,
                brightness = 0.8,
            },
            shadow = {
                enabled = true,
                range = 20,
                offset = { 0, 2 },
                render_power = 4,
                color = "rgba(0000002A)",
            },
            active_opacity = 1.0,
            inactive_opacity = 0.999,
            fullscreen_opacity = 1.0,
            dim_inactive = true,
            dim_strength = 0.1,
            dim_special = 0.8,
        },
        xwayland = {
            force_zero_scaling = true,
        },
        misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            vrr = 1,
            key_press_enables_dpms = true,
        },
        cursor = {
            persistent_warps = true,
        },
        binds = {
            disable_keybind_grabbing = true,
        },
    })

    animations(ctx)
    layers(ctx)
end

---@type fun(ctx: HyprConfigContext): nil
layers = function(ctx)
    hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0 })
end

---@type fun(ctx: HyprConfigContext): nil
animations = function(ctx)
    hl.config({
        animations = {
            enabled = true,
        },
    })

    hl.curve("windowIn", { type = "bezier", points = { { 0.06, 0.71 }, { 0.25, 1 } } })
    hl.curve("windowResize", { type = "bezier", points = { { 0.04, 0.67 }, { 0.38, 1 } } })
    hl.curve("fast", { type = "bezier", points = { { 0.05, 1 }, { 0.01, 1 } } })

    hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "windowIn", style = "slide" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "windowIn", style = "slide" })
    hl.animation({ leaf = "windowsMove", enabled = false, speed = 2.5, bezier = "windowResize" })
    hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
    hl.animation({ leaf = "workspaces", enabled = false, speed = 9, bezier = "fast" })
    hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "fast" })
    hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "default", style = "fade" })
end

local M = {
    run = run,
}
return M
