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
    bind(k(mod, "SHIFT", "w"), hl.dsp.submap("workspaces"), {
        description = "Named workspace actions",
    })
    hl.define_submap("workspaces", "reset", function()
        local bind = helpers.debug_bind(ctx, "config/binds.lua", "workspaces")

        bind(k("c"), cmd(scripts_dir .. "/workspace-manager.bash create"))
        bind(k("m"), cmd(scripts_dir .. "/workspace-manager.bash move"))
        bind(k("g"), cmd(scripts_dir .. "/workspace-manager.bash go"))
        bind(k("f"), cmd(scripts_dir .. "/workspace-manager.bash forget"))
        bind(k("h"), cmd(scripts_dir .. "/workspace-manager.bash harpoon-set"))
        bind(k("a"), cmd(scripts_dir .. "/workspace-manager.bash"))
        for i = 1, 4 do
            bind(k(tostring(i)), cmd(scripts_dir .. "/workspace-manager.bash harpoon-go " .. i))
            bind(k("SHIFT", tostring(i)), cmd(scripts_dir .. "/workspace-manager.bash harpoon-move " .. i))
        end
        bind(k("escape"), hl.dsp.submap("reset"))
        bind(k("catchall"), hl.dsp.submap("reset"))
    end)

    for i = 1, 4 do
        bind(k(mod, "ALT", tostring(i)), cmd(scripts_dir .. "/workspace-manager.bash harpoon-go " .. i), {
            description = "Go to workspace harpoon " .. i,
        })
        bind(k(mod, "ALT", "SHIFT", tostring(i)), cmd(scripts_dir .. "/workspace-manager.bash harpoon-move " .. i), {
            description = "Go to workspace harpoon " .. i,
        })
    end

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

    local c = function(str)
        return hl.dsp.exec_cmd("fish -lc '" .. str .. "'")
    end

    bind(k(mod, "s"), c([[
        hyprctl dispatch "hl.dsp.submap(\"reset\")"
        and wl-kbptr -c ~/.config/wl-kbptr/config.ini
        and sleep 0.01

        set pos (hyprctl cursorpos)
        set coords (string split "," $pos)
        set x (string trim $coords[1])
        set y (string trim $coords[2])

        hyprctl dispatch "hl.dsp.cursor.move({ x = "(math "$x + 1")", y = $y })"
        and hyprctl dispatch "hl.dsp.cursor.move({ x = $x, y = $y })"

        and hyprctl dispatch "hl.dsp.submap(\"cursor\")"
    ]]))
    bind(k(mod, "SHIFT", "CTRL", "s"), cmd("pkill wl-kbptr"))
    bind(k(mod, "c"), hl.dsp.submap("cursor"))
    hl.define_submap("cursor", function()
        local bind = helpers.debug_bind(ctx, "config/binds.lua", "cursor")

        bind(k(mod, "j"), cmd("wlrctl pointer move 0 10"), { repeating = true })
        bind(k(mod, "k"), cmd("wlrctl pointer move 0 -10"), { repeating = true })
        bind(k(mod, "l"), cmd("wlrctl pointer move 10 0"), { repeating = true })
        bind(k(mod, "h"), cmd("wlrctl pointer move -10 0"), { repeating = true })
        bind(k("j"), cmd("wlrctl pointer move 0 10"), { repeating = true })
        bind(k("k"), cmd("wlrctl pointer move 0 -10"), { repeating = true })
        bind(k("l"), cmd("wlrctl pointer move 10 0"), { repeating = true })
        bind(k("h"), cmd("wlrctl pointer move -10 0"), { repeating = true })

        bind(k(mod, "u"), cmd("wlrctl pointer click left"))
        bind(k(mod, "i"), cmd("wlrctl pointer click middle"))
        bind(k(mod, "o"), cmd("wlrctl pointer click right"))
        bind(k("u"), cmd([[wlrctl pointer click left && hyprctl dispatch "hl.dsp.submap(\"reset\")"]]))
        bind(k("i"), cmd([[wlrctl pointer click middle && hyprctl dispatch "hl.dsp.submap(\"reset\")"]]))
        bind(k("o"), cmd([[wlrctl pointer click right && hyprctl dispatch "hl.dsp.submap(\"reset\")"]]))

        bind(k("y"), cmd("wlrctl pointer scroll 10 0"), { repeating = true })
        bind(k("n"), cmd("wlrctl pointer scroll -10 0"), { repeating = true })
        bind(k("m"), cmd("wlrctl pointer scroll 0 10"), { repeating = true })
        bind(k("comma"), cmd("wlrctl pointer scroll 0 -10"), { repeating = true })

        bind(k("escape"), hl.dsp.submap("reset"))
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
        bind(k(mod, "SHIFT", "h"), hl.dsp.window.move({ direction = "l", group_aware = "true" }))
        bind(k(mod, "SHIFT", "j"), hl.dsp.window.move({ direction = "d", group_aware = "true" }))
        bind(k(mod, "SHIFT", "k"), hl.dsp.window.move({ direction = "u", group_aware = "true" }))
        bind(k(mod, "SHIFT", "l"), hl.dsp.window.move({ direction = "r", group_aware = "true" }))

        bind(k(mod, "SHIFT", "q"), hl.dsp.window.close())

        bind(k(mod, "w"), hl.dsp.group.toggle())
        bind(k(mod, "CTRL","l"), hl.dsp.group.next())
        bind(k(mod, "CTRL", "h"), hl.dsp.group.prev())
        bind(k(mod, "CTRL", "SHIFT", "l"), hl.dsp.group.move_window({ forward = true }))
        bind(k(mod, "CTRL", "SHIFT", "h"), hl.dsp.group.move_window({ forward = false }))
        bind(k(mod, "x"), hl.dsp.group.lock_active("toggle"))
        for i = 1, 5 do
            local key = tostring(i)
            bind(k(mod, "CTRL", key), hl.dsp.group.active({ index = i }))
        end
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
