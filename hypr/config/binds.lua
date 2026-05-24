local helpers = require("./config/helpers")

---@type fun(ctx: HyprConfigContext): nil
local function run(ctx)
    local bind = helpers.debug_bind(ctx, "config/binds.lua")
    local cmd = hl.dsp.exec_cmd
    local k = helpers.combine_keys

    local mod = ctx.keys.mod
    local scripts_dir = ctx.dirs.scripts

    bind(k(mod, "return"), cmd(ctx.terminal))
    bind(k(mod, "b"), cmd("pkill -SIGUSR1 waybar"))
    bind(k(mod, "d"), cmd("pkill rofi || rofi -show drun"))

    bind(k(mod, "SHIFT", "v"), cmd(scripts_dir .. "/ClipManager.sh"))
    bind(k(mod, "SHIFT", "d"), cmd(scripts_dir .. "/RofiEmoji.sh"))
    bind(k(mod, "SHIFT", "n"), cmd("swaync-client -t -sw"))

    bind(k(mod, "o"), cmd(scripts_dir .. "/open-clipboard-image.bash"))
    bind(k("print"), cmd("flameshot gui"))
    bind(k(mod, "print"), cmd("hyprshot -m output"))
    bind(k(mod, "CTRL", "print"), cmd("hyprshot -m window"))
    bind(k(mod, "SHIFT", "print"), cmd("hyprshot -m region"))

    bind(k("XF86MonBrightnessDown"), cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
    bind(k("XF86MonBrightnessUp"), cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
    bind(k("XF86AudioRaiseVolume"), cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
    bind(k("XF86AudioLowerVolume"), cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })
    bind(k("XF86AudioMute"), cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
    bind(k("XF86AudioMicMute"), cmd("amixer set Capture toggle"), { locked = true })

    bind(k(mod, "m"), cmd("amixer set Capture toggle"))
    bind(k(mod, "u"), cmd("playerctl play-pause"))
    bind(k(mod, "n"), cmd("playerctl next"))
    bind(k(mod, "p"), cmd("playerctl previous"))

    bind(k(mod, "F7"), hl.dsp.window.tag({ tag = ctx.tags.no_screen_share }))

    bind(k(mod, "t"), hl.dsp.submap("theme"))
    hl.define_submap("theme", function()
        local bind = helpers.debug_bind(ctx, "config/binds.lua", "theme")

        bind(k("w"), cmd(scripts_dir .. "/refresh.fish --wallpaper"))
        -- toggle default/auto
        bind(k("d"), cmd(scripts_dir .. "/refresh.fish --toggle-theme"))
        -- toggle light/dark
        bind(k("l"), cmd(scripts_dir .. "/theme.fish && " .. scripts_dir .. "/refresh.fish"))
        bind(k("r"), cmd(scripts_dir .. "/refresh.fish"))
        bind(k("escape"), hl.dsp.submap("reset"))
        bind(k("catchall"), hl.dsp.submap("reset"))
    end)

    bind(k(mod, "SHIFT", "r"), hl.dsp.submap("resize"))
    hl.define_submap("resize", function()
        local bind = helpers.debug_bind(ctx, "config/binds.lua", "resize")

        bind(k("l"), hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
        bind(k("h"), hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
        bind(k("k"), hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
        bind(k("j"), hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
        bind(k("escape"), hl.dsp.submap("reset"))
    end)

    bind(k(mod, "SHIFT", "CTRL", "e"), hl.dsp.exit())
    bind(k(mod, "SHIFT", "s"), cmd("systemctl suspend"))
    bind(k(mod, "f"), hl.dsp.window.fullscreen())
    bind(k(mod, "SHIFT", "space"), hl.dsp.window.float())
    bind(k(mod, "SHIFT", "p"), hl.dsp.window.pin())
    bind(k(mod, "SHIFT", "left"), hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
    bind(k(mod, "SHIFT", "right"), hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
    bind(k(mod, "SHIFT", "up"), hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
    bind(k(mod, "SHIFT", "down"), hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

    bind(k(mod, "tab"), function()
        hl.dispatch(hl.dsp.window.cycle_next())
        hl.dispatch(hl.dsp.window.bring_to_top())
    end)

    for i = 1, 10 do
        local key = tostring(i % 10)
        bind(k(mod, key), hl.dsp.focus({ workspace = i }))
    end

    if not ctx.plugins.hy3 then
        for i = 1, 10 do
            local key = tostring(i % 10)
            bind(k(mod, "SHIFT", key), hl.dsp.window.move({ workspace = i }))
        end

        bind(k(mod, "h"), hl.dsp.focus({ direction = "l" }))
        bind(k(mod, "j"), hl.dsp.focus({ direction = "d" }))
        bind(k(mod, "k"), hl.dsp.focus({ direction = "u" }))
        bind(k(mod, "l"), hl.dsp.focus({ direction = "r" }))
        bind(k(mod, "SHIFT", "h"), hl.dsp.window.move({ direction = "l" }))
        bind(k(mod, "SHIFT", "j"), hl.dsp.window.move({ direction = "d" }))
        bind(k(mod, "SHIFT", "k"), hl.dsp.window.move({ direction = "u" }))
        bind(k(mod, "SHIFT", "l"), hl.dsp.window.move({ direction = "r" }))
    end

    bind(k(mod, "minus"), hl.dsp.workspace.toggle_special("scratchpad"))
    bind(k(mod, "SHIFT", "minus"), hl.dsp.window.move({ workspace = "special:scratchpad" }))
    bind(k(mod, "equal"), hl.dsp.workspace.toggle_special("misc"))
    bind(k(mod, "SHIFT", "equal"), hl.dsp.window.move({ workspace = "special:misc" }))
    bind(k("CTRL", "ALT", mod, "SHIFT", "j"), hl.dsp.workspace.move({ monitor = "b" }))
    bind(k("CTRL", "ALT", mod, "SHIFT", "k"), hl.dsp.workspace.move({ monitor = "t" }))

    bind(k(mod, "mouse:272"), hl.dsp.window.drag(), { mouse = true })
    bind(k(mod, "mouse:273"), hl.dsp.window.resize(), { mouse = true })
    bind(k(mod, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
    bind(k(mod, "mouse_up"), hl.dsp.focus({ workspace = "e-1" }))

    hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
    hl.gesture({ fingers = 3, direction = "up", action = "cursorZoom", zoom_level = 3 })
    hl.gesture({ fingers = 3, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })
end

local M = {
    run = run,
}
return M
